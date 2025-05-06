import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(Map<String, dynamic>) onRemoveFavorite;

  const FavoritesPage({super.key, required this.favorites, required this.onRemoveFavorite});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeFavorite(int index, Map<String, dynamic> book) {
    widget.onRemoveFavorite(book);
    setState(() {
      widget.favorites.removeAt(index);
    });
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildListItem(book, index, animation),
    );
  }

  Widget _buildListItem(Map<String, dynamic> book, int index, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent.withOpacity(0.2),
            child: const Icon(Icons.book, color: Colors.redAccent),
          ),
          title: Text(
            book['title'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(book['category']),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red), // 🔴 Red heart
            onPressed: () => _removeFavorite(index, book),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: widget.favorites.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: widget.favorites.length,
          itemBuilder: (context, index, animation) {
            return _buildListItem(widget.favorites[index], index, animation);
          },
        ),
      ),
    );
  }
}