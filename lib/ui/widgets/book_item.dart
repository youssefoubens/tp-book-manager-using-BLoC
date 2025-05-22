// lib/ui/widgets/book_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../data/models/book.dart';
import '../pages/detail_page.dart';

class BookItem extends StatefulWidget {
  final Book book;

  const BookItem({Key? key, required this.book}) : super(key: key);

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  void initState() {
    super.initState();
    // Vérifier si ce livre est dans les favoris
    context.read<FavoritesBloc>().add(CheckFavoriteStatus(widget.book.id));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(book: widget.book),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image de couverture du livre
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.book.imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Détails du livre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.author,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Bouton Favoris
              BlocBuilder<FavoritesBloc, FavoritesState>(
                buildWhen: (previous, current) {
                  return current is FavoriteStatus &&
                      current.bookId == widget.book.id;
                },
                builder: (context, state) {
                  bool isFavorite = false;
                  bool isLoading = true;

                  if (state is FavoriteStatus &&
                      state.bookId == widget.book.id) {
                    isFavorite = state.isFavorite;
                    isLoading = false;
                  }

                  return IconButton(
                    icon:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                    onPressed:
                        isLoading
                            ? null
                            : () {
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
        ),
      ),
    );
  }
}
