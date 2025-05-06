import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onFavoriteAdded;

  const ProductDetails({
    super.key,
    required this.product,
    required this.onFavoriteAdded,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double rating = 0;
  bool isFavorite = false;
  int likes = 0;
  List<double> ratings = [];
  List<String> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product['isFavorite'] ?? false;
    likes = widget.product['likes'] ?? 0;
  }

  void _rateProduct(double value) {
    setState(() {
      ratings.add(value);
      rating = ratings.reduce((a, b) => a + b) / ratings.length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for rating! ⭐')),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.product['isFavorite'] = isFavorite;
    });

    widget.onFavoriteAdded(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isFavorite ? 'Added to favorites! ❤️' : 'Removed from favorites! ❌')),
    );
  }

  void _addComment() {
    if (commentController.text.isNotEmpty) {
      setState(() {
        comments.add(commentController.text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added! 📝')),
      );
      commentController.clear();
    }
  }

  void _likeProduct() {
    setState(() {
      likes++;
      widget.product['likes'] = likes;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You liked this product! 👍')),
    );
  }

  Widget _glassCard({required Widget child, double padding = 12}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProductImage() {
    final imageUrl = widget.product['image_url'] ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 220,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.broken_image,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
          ),
        )
            : Center(
          child: Icon(
            Icons.book,
            size: 60,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[800],
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.product['title'] ?? 'Product Details'),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
                size: 28,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _glassCard(
                padding: 8,
                child: _buildProductImage(),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.product['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.product['description'] ?? 'No Description',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Centered Price Card
              _glassCard(
                child: Center(
                  child: Text(
                    '${widget.product['price'] ?? 'N/A'} DA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              _glassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enjoyed the product?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : colorScheme.onSurface,
                            size: 28,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: index < rating ? Colors.amber : colorScheme.onSurface.withOpacity(0.3),
                            size: 32,
                          ),
                          onPressed: () => _rateProduct(index + 1.0),
                        );
                      }),
                    ),
                    Text(
                      'Average Rating: ${rating.toStringAsFixed(1)} / 5.0',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              _glassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: colorScheme.primary, size: 28),
                      onPressed: _likeProduct,
                    ),
                    Text(
                      '$likes likes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leave a comment:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceVariant,
                        hintText: 'Write your comment...',
                        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _addComment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Add Comment',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Comments:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    comments.isEmpty
                        ? Text(
                      'No comments yet.',
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.person, color: colorScheme.primary),
                          title: Text(
                            comments[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}