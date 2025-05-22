// lib/data/repositories/favorites_repository.dart
import 'package:book_manager_app/data/services/native_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/book.dart';
import '../services/storage_service.dart';
import '../services/web_storage_service.dart'
    if (dart.library.io) '../services/native_storage_service.dart';

class FavoritesRepository {
  final StorageService _storageService;

  FavoritesRepository() : _storageService = _getStorageService();

  static StorageService _getStorageService() {
    if (kIsWeb) {
      return WebStorageService();
    } else {
      // Import and return NativeStorageService through function implementation
      return _getNativeStorage();
    }
  }

  static StorageService _getNativeStorage() {
    try {
      dynamic nativeStorage = NativeStorageService();
      return nativeStorage;
    } catch (e) {
      // Fallback to web storage if something goes wrong
      return WebStorageService();
    }
  }

  Future<List<Book>> getFavoriteBooks() async {
    return await _storageService.getAllBooks();
  }

  Future<void> addToFavorites(Book book) async {
    await _storageService.saveBook(book);
  }

  Future<void> removeFromFavorites(String id) async {
    await _storageService.deleteBook(id);
  }

  Future<bool> isBookFavorite(String id) async {
    return await _storageService.isBookSaved(id);
  }
}
