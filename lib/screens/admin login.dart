import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'favorites.dart';
import 'product details.dart';
import 'manage users.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> favorites = [];
  String searchQuery = "";
  bool isLoading = true;
  String baseUrl = "http://10.0.2.2/flutter_api";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_allproducts.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }
    });
  }

  Future<void> _addProduct() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newProduct = {
                  'title': titleController.text,
                  'category': categoryController.text.isNotEmpty
                      ? categoryController.text
                      : 'Uncategorized',
                  'description': descriptionController.text,
                  'price': priceController.text.isNotEmpty
                      ? priceController.text
                      : '0',
                  'image_url': imageUrlController.text.isNotEmpty
                      ? imageUrlController.text
                      : '',
                };

                try {
                  final response = await http.post(
                    Uri.parse('$baseUrl/add_product.php'),
                    body: json.encode(newProduct),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    fetchProducts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added successfully')),
                    );
                  } else {
                    throw Exception('Failed to add product: ${response.body}');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding product: $e')),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProduct(int index) async {
    final product = products[index];
    TextEditingController titleController = TextEditingController(text: product['title']);
    TextEditingController categoryController = TextEditingController(text: product['category']);
    TextEditingController descriptionController = TextEditingController(text: product['description']);
    TextEditingController priceController = TextEditingController(text: product['price']?.toString() ?? '0');
    TextEditingController imageUrlController = TextEditingController(text: product['image_url'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedProduct = {
                  'id': product['id'],
                  'title': titleController.text,
                  'category': categoryController.text.isNotEmpty
                      ? categoryController.text
                      : 'Uncategorized',
                  'description': descriptionController.text,
                  'price': priceController.text.isNotEmpty
                      ? priceController.text
                      : '0',
                  'image_url': imageUrlController.text.isNotEmpty
                      ? imageUrlController.text
                      : '',
                };

                try {
                  final response = await http.post(
                    Uri.parse('$baseUrl/update_product.php'),
                    body: json.encode(updatedProduct),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    fetchProducts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product updated successfully')),
                    );
                  } else {
                    throw Exception('Failed to update product: ${response.body}');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating product: $e')),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int index) async {
    final product = products[index];
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_product.php'),
        body: json.encode({'id': product['id']}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          products.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> categorizedProducts = {};
    for (var product in products) {
      categorizedProducts.putIfAbsent(product['category'], () => []).add(product);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favorites: favorites,
                    onRemoveFavorite: (product) {
                      setState(() {
                        favorites.remove(product);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.supervisor_account),
            tooltip: "Manage Users",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageUsersPage()),
              );
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a product...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: categorizedProducts.entries.map((entry) {
          List<Map<String, dynamic>> filteredProducts = entry.value.where((product) {
            return product['title'].toLowerCase().contains(searchQuery) ||
                product['category'].toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredProducts.isEmpty) return Container();

          return ExpansionTile(
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: filteredProducts.map((product) {
              return ListTile(
                leading: product['image_url'] != null && product['image_url'].isNotEmpty
                    ? Image.network(
                  product['image_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.book),
                )
                    : const Icon(Icons.book),
                title: Text(product['title']),
                subtitle: Text(product['category'] ?? 'Unspecified'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        favorites.contains(product) ? Icons.favorite : Icons.favorite_border,
                        color: favorites.contains(product) ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editProduct(products.indexOf(product)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProduct(products.indexOf(product)),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: product,
                        onFavoriteAdded: _toggleFavorite,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
