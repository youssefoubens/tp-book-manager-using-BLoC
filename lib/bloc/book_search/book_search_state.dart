// lib/bloc/book_search/book_search_state.dart
import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';

abstract class BookSearchState extends Equatable {
  const BookSearchState();

  @override
  List<Object?> get props => [];
}

class BookSearchInitial extends BookSearchState {}

class BookSearchLoading extends BookSearchState {}

class BookSearchLoaded extends BookSearchState {
  final List<Book> books;

  const BookSearchLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BookSearchError extends BookSearchState {
  final String message;

  const BookSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
