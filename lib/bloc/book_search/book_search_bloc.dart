// lib/bloc/book_search/book_search_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/book_repository.dart';
import 'book_search_event.dart';
import 'book_search_state.dart';

class BookSearchBloc extends Bloc<BookSearchEvent, BookSearchState> {
  final BookRepository _bookRepository;

  BookSearchBloc({required BookRepository bookRepository})
    : _bookRepository = bookRepository,
      super(BookSearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<BookSearchState> emit,
  ) async {
    emit(BookSearchLoading());
    try {
      final books = await _bookRepository.searchBooks(event.query);
      emit(BookSearchLoaded(books));
    } catch (e) {
      emit(BookSearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<BookSearchState> emit) {
    emit(BookSearchInitial());
  }
}
