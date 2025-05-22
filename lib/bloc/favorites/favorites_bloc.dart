// lib/bloc/favorites/favorites_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc({required FavoritesRepository favoritesRepository})
    : _favoritesRepository = favoritesRepository,
      super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      final books = await _favoritesRepository.getFavoriteBooks();
      emit(FavoritesLoaded(books));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.addToFavorites(event.book);
      add(LoadFavorites()); // Recharger la liste après l'ajout
      emit(FavoriteStatus(isFavorite: true, bookId: event.book.id));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesRepository.removeFromFavorites(event.bookId);
      add(LoadFavorites()); // Recharger la liste après la suppression
      emit(FavoriteStatus(isFavorite: false, bookId: event.bookId));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatus event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite = await _favoritesRepository.isBookFavorite(
        event.bookId,
      );
      emit(FavoriteStatus(isFavorite: isFavorite, bookId: event.bookId));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
