// lib/bloc/favorites/favorites_state.dart
import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Book> books;

  const FavoritesLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteStatus extends FavoritesState {
  final bool isFavorite;
  final String bookId;

  const FavoriteStatus({required this.isFavorite, required this.bookId});

  @override
  List<Object?> get props => [isFavorite, bookId];
}
