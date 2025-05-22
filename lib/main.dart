// lib/main.dart
import 'package:book_manager_app/bloc/favorites/favorites_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/book_search/book_search_bloc.dart';
import 'bloc/favorites/favorites_bloc.dart';
import 'data/repositories/book_repository.dart';
import 'data/repositories/favorites_repository.dart';
import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BookManagerApp());
}

class BookManagerApp extends StatelessWidget {
  const BookManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookSearchBloc>(
          create: (context) => BookSearchBloc(bookRepository: BookRepository()),
        ),
        BlocProvider<FavoritesBloc>(
          create:
              (context) =>
                  FavoritesBloc(favoritesRepository: FavoritesRepository())
                    ..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: 'Book Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
