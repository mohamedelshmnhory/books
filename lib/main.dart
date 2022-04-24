import 'dart:io';
import 'package:books/add_book_form.dart';
import 'package:books/models/status_model.dart';
import 'package:books/styles/colors.dart';
import 'package:books/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'backup/storage.dart';
import 'list_books_section.dart';
import 'models/book_model.dart';
import 'local_storage.dart';
import 'styles/themes.dart';

void main() {
  runApp(const MyApp());
}

const String appName = 'Abdelsalam books';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context) {
          return MaterialApp(
            title: appName,
            theme: lightTheme,
            home: MyHomePage(storage: Storage()),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);
  final Storage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> books = [];
  List<Book> searchBooks = [];
  int selectedStatus = 0;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(appName);

  Future<File> saveBooksToFile() {
    return widget.storage.writeBooks(books);
  }

  Future readBooks() async {
    var importedBooks = await widget.storage.readBooks();
    setState(() {
      books = importedBooks;
    });
    for (var element in books) {
      DBHelper.insert(booksT, element);
    }
  }

  void readBooksFromFilePicker() async {
    var importedBooks = await widget.storage.readFromFilePicker();
    setState(() {
      books = importedBooks;
    });
  }

  Future<void> getBooks() async {
    await DBHelper.getData(booksT).then((dataList) {
      setState(() {
        books = dataList.map((e) => Book.fromMap(e)).toList();
        books.sort((a, b) => b.date!.compareTo(a.date!));
      });
    });
  }

  Widget get gestureTile {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => saveBooksToFile().then((value) {
                        doneAlert();
                      }),
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () => readBooks().then((value) {
                        doneAlert();
                      }),
                      child: const Text('Read'),
                    ),
                    TextButton(
                      onPressed: () => widget.storage.share(books),
                      child: const Text('Share'),
                    ),
                    TextButton(
                      onPressed: () => readBooksFromFilePicker(),
                      child: const Text('File Picker'),
                    ),
                  ],
                ),
              );
            });
      },
      child: const Text(appName),
    );
  }

  void doneAlert() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (_) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(Icons.cloud_done_rounded, size: 35),
            ),
          );
        });
  }

  @override
  void initState() {
    getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customIcon.icon == Icons.search ? gestureTile : customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(Icons.search, color: white),
                      title: TextField(
                        onChanged: (value) {
                          searchBooks = books
                              .where((book) => buildContains(book, value))
                              .toList();
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: 'book name, author, classification...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    // getBooks();
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text(appName);
                  }
                });
              },
              icon: customIcon)
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: customIcon.icon == Icons.search,
            child: Column(
              children: [
                sizedBoxH(15),
                Wrap(
                  children: [
                    ...List.generate(
                      statusList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            setState(() {
                              selectedStatus = index;
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              end: SizeConfig.getW(5)),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.getW(20),
                              vertical: SizeConfig.getH(5)),
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            borderRadius: BorderRadius.circular(25),
                            color: selectedStatus == index ? mainColor : white,
                          ),
                          child: Text(
                            statusList[index].title ?? '',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: selectedStatus == index
                                          ? white
                                          : mainColor,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          sizedBoxH(10),
          Expanded(
            child: ListBooksSection(
                books: customIcon.icon != Icons.search
                    ? searchBooks
                    : books
                        .where((book) => book.status == selectedStatus)
                        .toList(),
                function: getBooks,
                title: 'Reading'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return const Dialog(
                  child: AddBookForm(),
                );
              }).then((value) => getBooks());
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool buildContains(Book book, String value) {
    return book.name!.toLowerCase().contains(value.toLowerCase()) ||
        book.author!.toLowerCase().contains(value.toLowerCase()) ||
        (book.classification ?? '').toLowerCase().contains(value.toLowerCase());
  }
}
