// lib/bloc/book_search/book_search_event.dart
import 'package:equatable/equatable.dart';

abstract class BookSearchEvent extends Equatable {
  const BookSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchBooks extends BookSearchEvent {
  final String query;

  const SearchBooks(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends BookSearchEvent {}
