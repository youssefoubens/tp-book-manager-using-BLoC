// lib/ui/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../widgets/book_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Charger les favoris quand la page est chargée
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Books')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        buildWhen: (previous, current) {
          return current is FavoritesInitial ||
              current is FavoritesLoading ||
              current is FavoritesLoaded ||
              current is FavoritesError;
        },
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          } else if (state is FavoritesLoaded) {
            if (state.books.isEmpty) {
              return const Center(
                child: Text(
                  'No favorite books yet.\nSearch and add some books to your favorites!',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return BookItem(book: book);
              },
            );
          }
          return const Center(child: Text('Loading your favorite books...'));
        },
      ),
    );
  }
}
