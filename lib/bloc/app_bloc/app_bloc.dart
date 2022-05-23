import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../local_storage.dart';
import '../../main.dart';
import '../../models/book_model.dart';
import '../../utils/backup/storage.dart';

part 'app_event.dart';
part 'app_state.dart';

const String all = 'All';

@Injectable()
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.storage, this.dbHelper) : super(AppInitial()) {
    on<AppEvent>((event, emit) async {
      if (event is GetBooksFromDB) {
        await _getBooksFromDB(emit);
      } else if (event is FilterByClassification) {
        _filterByClassification(emit, event);
      } else if (event is FilterByAuthor) {
        _filterByAuthor(emit, event);
      }
    });
  }

  final Storage storage;
  final DBHelper dbHelper;

  List<Book> _books = [];
  List<Book> searchBooks = [];
  Map authors = {};
  Map classifications = {};
  String filter = all;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(appName);

  List<Book> get books => _books;

  void _filterByAuthor(Emitter<AppState> emit, FilterByAuthor event) {
    emit(GetBooksLoading());
    filter = event.author;
    searchBooks = _books.where((book) {
      return book.author?.contains(event.author) ?? false;
    }).toList();
    emit(GetBooksSuccess());
  }

  void _filterByClassification(
      Emitter<AppState> emit, FilterByClassification event) {
    emit(GetBooksLoading());
    filter = event.classification;
    searchBooks = _books.where((book) {
      return book.classification?.contains(event.classification) ?? false;
    }).toList();
    emit(GetBooksSuccess());
  }

  void cleatSearch() {
    searchBooks.clear();
    filter = all;
    customIcon = const Icon(Icons.search);
    customSearchBar = const Text(appName);
  }

  Future<void> _getBooksFromDB(Emitter<AppState> emit) async {
    emit(GetBooksLoading());

    await dbHelper.getData(booksT).then((dataList) {
      _books = dataList.map((e) => Book.fromMap(e)).toList();
      _books.sort((a, b) => b.date!.compareTo(a.date!));

      setAuthorsAndClassifications();
    });

    emit(GetBooksSuccess());
  }

  void setAuthorsAndClassifications() {
    final List<String> temp = [];
    authors.clear();
    classifications.clear();

    for (var element in _books) {
      authors.containsKey(element.author)
          ? authors[element.author]++
          : authors[element.author] = 1;

      if (element.classification != '' && element.classification != null) {
        temp.addAll(element.classification!.split(' '));
      }
    }

    for (var element in temp) {
      classifications.containsKey(element)
          ? classifications[element]++
          : classifications[element] = 1;
    }

    authors =
        SplayTreeMap<String, dynamic>.from(authors, (a, b) => a.compareTo(b));
    classifications = SplayTreeMap<String, dynamic>.from(
        classifications, (a, b) => a.compareTo(b));
  }

  Future<File?> saveBooksToFile() {
    return storage.writeBooks(_books);
  }

  Future readBooks() async {
    List<Book> importedBooks = await storage.readBooks();
    _books = importedBooks;
    dbHelper.deleteDatabase();
    for (var element in _books) {
      dbHelper.insert(booksT, element);
    }
    add(GetBooksFromDB());
  }

  Future readBooksFromFilePicker() async {
    var importedBooks = await storage.readFromFilePicker();
    _books = importedBooks;
    dbHelper.deleteDatabase();
    for (var element in _books) {
      dbHelper.insert(booksT, element);
    }
    add(GetBooksFromDB());
  }
}
