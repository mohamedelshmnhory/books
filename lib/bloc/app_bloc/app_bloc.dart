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

@Injectable()
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.storage) : super(AppInitial()) {
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
  List<Book> _books = [];
  List<Book> searchBooks = [];
  final Map authors = {};
  final Map classifications = {};
  String filter = 'All';
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(appName);

  List<Book> get books => _books;

  void _filterByAuthor(Emitter<AppState> emit, FilterByAuthor event) {
    emit(GetBooksLoading());
    filter = event.author;
    searchBooks = _books.where((book) {
      if (book.author == null) {
        return false;
      }
      return book.author!.contains(event.author);
    }).toList();
    emit(GetBooksSuccess());
  }

  void _filterByClassification(
      Emitter<AppState> emit, FilterByClassification event) {
    emit(GetBooksLoading());
    filter = event.classification;
    searchBooks = _books.where((book) {
      if (book.classification == null) {
        return false;
      }
      return book.classification!.contains(event.classification);
    }).toList();
    emit(GetBooksSuccess());
  }

  void cleatSearch() {
    searchBooks.clear();
    filter = 'All';
    customIcon = const Icon(Icons.search);
    customSearchBar = const Text(appName);
  }

  Future<void> _getBooksFromDB(Emitter<AppState> emit) async {
    emit(GetBooksLoading());
    authors.clear();
    classifications.clear();
    await DBHelper.getData(booksT).then((dataList) {
      _books = dataList.map((e) => Book.fromMap(e)).toList();
      _books.sort((a, b) => b.date!.compareTo(a.date!));
      final List<String> temp = [];
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
    });

    emit(GetBooksSuccess());
  }

  Future<File> saveBooksToFile() {
    return storage.writeBooks(_books);
  }

  Future readBooks() async {
    List<Book> importedBooks = await storage.readBooks();
    _books = importedBooks;
    DBHelper.deleteDatabase();
    for (var element in _books) {
      DBHelper.insert(booksT, element);
    }
    add(GetBooksFromDB());
  }

  Future readBooksFromFilePicker() async {
    var importedBooks = await storage.readFromFilePicker();
    _books = importedBooks;
    DBHelper.deleteDatabase();
    for (var element in _books) {
      DBHelper.insert(booksT, element);
    }
    add(GetBooksFromDB());
  }
}
