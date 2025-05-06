import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product details.dart';
import 'cart.dart';

class ProductList extends StatefulWidget {
  final String category;
  final bool isDarkMode;

  const ProductList({
    super.key,
    required this.category,
    this.isDarkMode = false,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final url = Uri.parse(
        "http://10.0.2.2/flutter_api/fetchproducts.php?category=${Uri.encodeComponent(widget.category)}",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map && decoded["status"] == "success" && decoded["products"] is List) {
          setState(() {
            products = List<Map<String, dynamic>>.from(decoded["products"]);
            isLoading = false;
          });
        } else {
          _showError("Invalid response format or no products.");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection error: $e");
    }
  }

  void _showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _addToCart(Map<String, dynamic> product) {
    final price = double.tryParse(product['price'].toString()) ?? 0;
    setState(() {
      cartItems.add(product);
      totalPrice += price;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['title']} added to cart"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withOpacity(0.7) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.brown[200]!,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDark ? Colors.grey[800] : Colors.brown[50],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl ?? '',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.amber,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.book,
              size: 40,
              color: isDark ? Colors.grey[600] : Colors.brown[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    final product = products[index];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _glassCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetails(
                product: product,
                onFavoriteAdded: (_) {},
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product['image_url']),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? 'No title',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.brown[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['description'] ?? 'No description',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.brown[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${product['price'] ?? 'N/A'} DA",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.amber : Colors.brown[800],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: isDark ? Colors.amber : Colors.brown[700],
                            size: 24,
                          ),
                          onPressed: () => _addToCart(product),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[800], // Brown app bar
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey[850] : const Color(0xFFFDF6EE),
        appBar: AppBar(
          title: Text(widget.category),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      cartItems: cartItems,
                      totalPrice: totalPrice,
                      onCartUpdated: (updatedCart, updatedPrice) {
                        setState(() {
                          cartItems = updatedCart;
                          totalPrice = updatedPrice;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "${totalPrice.toStringAsFixed(0)} DA",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        )
            : products.isEmpty
            ? Center(
          child: Text(
            "No products found in this category.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.brown[800],
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: _buildProductItem,
        ),
      ),
    );
  }
}