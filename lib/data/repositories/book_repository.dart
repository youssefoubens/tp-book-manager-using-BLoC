// lib/data/repositories/book_repository.dart
import '../models/book.dart';
import '../services/api_service.dart';

class BookRepository {
  final ApiService _apiService;

  BookRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<Book>> searchBooks(String query) {
    return _apiService.searchBooks(query);
  }

  Future<Book> getBookDetails(String bookId) {
    return _apiService.getBookDetails(bookId);
  }
}
