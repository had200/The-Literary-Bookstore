import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product list.dart';
import 'admin login.dart';
import 'favorites.dart';
import 'product details.dart';
import 'library.dart';
import 'user profile.dart';
class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const HomeScreen({super.key, required this.changeTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Books', 'image': 'assets/books.jpg'},
    {'name': 'Audiobooks & E-books', 'image': 'assets/audiobooks.jpg'},
    {'name': 'Manga & Graphic Novels', 'image': 'assets/manga.jpg'},
    {'name': 'Horror Books', 'image': 'assets/horror.jpg'},
    {'name': 'Novels', 'image': 'assets/novels.jpg'},
    {'name': 'Scientific Books', 'image': 'assets/scientific books.jpg'},
    {'name': 'Science Fiction', 'image': 'assets/science fiction.jpg'},
    {'name': 'Fantasy Books', 'image': 'assets/fantasy.jpg'},
    {'name': 'Historical Fiction', 'image': 'assets/historical.jpg'},
    {'name': 'Self-Help Books', 'image': 'assets/self help.jpg'},
  ];

  List<Map<String, dynamic>> favorites = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/flutter_api/search.php?query=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data['products']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search error: $e')),
      );
    }
  }

  void _toggleFavorite(Map<String, dynamic> book) {
    setState(() {
      if (favorites.contains(book)) {
        favorites.remove(book);
      } else {
        favorites.add(book);
      }
    });
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList(category: categories[index]['name']),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                categories[index]['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    Icons.book,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                categories[index]['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, int index) {
    final product = searchResults[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: product['image_url'] != null
            ? Image.network(
          product['image_url'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : Icon(Icons.book, size: 50),
        title: Text(product['title'] ?? 'No title'),
        subtitle: Text('${product['price'] ?? 'N/A'} DA'),
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "The Literary Bookstore",
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black, // White in dark mode, black in light
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : Colors.black, // Match title color
            ),
            onPressed: () {
              widget.changeTheme(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 700,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/books library.jpg",
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Home of Knowledge & Imagination",
                        style: GoogleFonts.lora(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Transform.translate(
                offset: const Offset(0, 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search books...",
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: theme.cardTheme.color,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: _searchProducts,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: isSearching
                ? SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildSearchResultItem,
                childCount: searchResults.length,
              ),
            )
                : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCategoryCard(context, index),
                childCount: categories.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LibraryScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(
                  favorites: favorites,
                  onRemoveFavorite: (book) {
                    setState(() {
                      favorites.remove(book);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from favorites')),
                    );
                  },
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: theme.colorScheme.primary),
            title: Text(
              'Home',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book, color: theme.colorScheme.primary),
            title: Text(
              'Library',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibraryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text(
              'Favorites',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favorites: favorites,
                    onRemoveFavorite: (book) {
                      setState(() {
                        favorites.remove(book);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from favorites')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: theme.colorScheme.primary),
            title: Text(
              'Profile',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(), // Navigate to UserProfile
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.admin_panel_settings, color: theme.colorScheme.primary),
            title: Text(
              'Admin Panel',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPanel(),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'The Literary Bookstore',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}