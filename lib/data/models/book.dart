// lib/data/models/book.dart
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String? description;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, author, imageUrl, description];

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    List<dynamic> authorsList = volumeInfo['authors'] ?? [];
    String authorText =
        authorsList.isNotEmpty ? authorsList.join(', ') : 'Unknown Author';

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author: authorText,
      imageUrl:
          imageLinks['thumbnail'] ??
          'https://via.placeholder.com/128x192?text=No+Image',
      description: volumeInfo['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? 'No Title',
      author: map['author'] ?? 'Unknown Author',
      imageUrl:
          map['imageUrl'] ??
          'https://via.placeholder.com/128x192?text=No+Image',
      description: map['description'],
    );
  }
}
