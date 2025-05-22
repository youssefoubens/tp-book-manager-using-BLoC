// lib/bloc/favorites/favorites_event.dart
import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final Book book;

  const AddToFavorites(this.book);

  @override
  List<Object?> get props => [book];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String bookId;

  const RemoveFromFavorites(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class CheckFavoriteStatus extends FavoritesEvent {
  final String bookId;

  const CheckFavoriteStatus(this.bookId);

  @override
  List<Object?> get props => [bookId];
}
