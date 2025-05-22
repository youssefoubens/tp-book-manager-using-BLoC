// lib/ui/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../data/models/book.dart';

class DetailPage extends StatefulWidget {
  final Book book;

  const DetailPage({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    // Vérifier si ce livre est dans les favoris
    context.read<FavoritesBloc>().add(CheckFavoriteStatus(widget.book.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            buildWhen: (previous, current) {
              return current is FavoriteStatus &&
                  current.bookId == widget.book.id;
            },
            builder: (context, state) {
              bool isFavorite = false;
              bool isLoading = true;

              if (state is FavoriteStatus && state.bookId == widget.book.id) {
                isFavorite = state.isFavorite;
                isLoading = false;
              }

              return isLoading
                  ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                  : IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        context.read<FavoritesBloc>().add(
                          RemoveFromFavorites(widget.book.id),
                        );
                      } else {
                        context.read<FavoritesBloc>().add(
                          AddToFavorites(widget.book),
                        );
                      }
                    },
                  );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Couverture et informations de base
            Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Couverture du livre
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.book.imageUrl,
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, size: 40),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Détails du livre
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'by ${widget.book.author}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildInfoChip(
                                label: 'Book ID',
                                value: widget.book.id,
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

            const Divider(),

            // Description du livre
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About this book',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.description ??
                        'This is a book by ${widget.book.author}. No detailed description available.',
                    style: TextStyle(color: Colors.grey[800], height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500),
      ),
    );
  }
}
