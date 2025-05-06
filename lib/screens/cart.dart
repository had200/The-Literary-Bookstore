import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final Function(List<Map<String, dynamic>>, double) onCartUpdated;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.onCartUpdated,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _cart;
  late double _total;

  @override
  void initState() {
    super.initState();
    _cart = List<Map<String, dynamic>>.from(widget.cartItems);
    _total = widget.totalPrice;
  }

  void _removeItem(int index) {
    final price = double.tryParse(_cart[index]['price'].toString()) ?? 0;
    setState(() {
      _total -= price;
      _cart.removeAt(index);
    });
  }

  void _buyItems() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchased!")));
    setState(() {
      _cart.clear();
      _total = 0;
    });
    widget.onCartUpdated([], 0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.brown,
      ),
      body: _cart.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (_, index) {
                final item = _cart[index];
                return ListTile(
                  title: Text(item['title'] ?? 'No title'),
                  subtitle: Text("${item['price']} DA"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ${_total.toStringAsFixed(0)} DA",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _cart.isNotEmpty ? _buyItems : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Buy"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
