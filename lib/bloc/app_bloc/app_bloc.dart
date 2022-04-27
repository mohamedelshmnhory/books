import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../local_storage.dart';
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
      }
    });
  }

  final Storage storage;
  List<Book> books = [];
  List<Book> searchBooks = [];
  List<String> authors = [];
  List<String> classifications = [];

  Future<void> _getBooksFromDB(Emitter<AppState> emit) async {
    emit(GetBooksLoading());
    await DBHelper.getData(booksT).then((dataList) {
      books = dataList.map((e) => Book.fromMap(e)).toList();
      books.sort((a, b) => b.date!.compareTo(a.date!));
      for (var element in books) {
        if (!authors.contains(element.author!)) {
          authors.add(element.author!);
        }
        if (element.classification != null &&
            !classifications.contains(element.classification!)) {
          classifications.add(element.classification!);
        }
      }
    });
    if (books.isNotEmpty) {
      emit(GetBooksSuccess());
    }
  }

  Future<File> saveBooksToFile() {
    return storage.writeBooks(books);
  }

  Future readBooks() async {
    List<Book> importedBooks = await storage.readBooks();
    books = importedBooks;
    for (var element in books) {
      DBHelper.insert(booksT, element);
    }
  }

  void readBooksFromFilePicker() async {
    var importedBooks = await storage.readFromFilePicker();

    books = importedBooks;
  }
}
