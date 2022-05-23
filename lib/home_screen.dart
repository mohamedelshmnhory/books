import 'package:books/bloc/app_bloc/app_bloc.dart';
import 'package:books/styles/colors.dart';
import 'package:books/styles/size_config.dart';
import 'package:books/widgets/backup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_book_form.dart';
import 'dependencies/dependency_init.dart';
import 'list_books_section.dart';
import 'main.dart';
import 'models/book_model.dart';
import 'models/status_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppBloc appBloc = getIt<AppBloc>();
  int selectedStatus = 0;

  @override
  void initState() {
    appBloc.add(GetBooksFromDB());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              if (selectedStatus > 0) {
                selectedStatus--;
              }
            });
          } else if (details.primaryVelocity! < 0) {
            setState(() {
              if (selectedStatus < 2) {
                selectedStatus++;
              }
            });
          }
        },
        child: BlocConsumer<AppBloc, AppState>(
          bloc: appBloc,
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Visibility(
                  visible: appBloc.searchBooks.isEmpty &&
                      appBloc.customIcon.icon == Icons.search,
                  child: Column(
                    children: [
                      sizedBoxH(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...List.generate(
                            statusList.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStatus = index;
                                });
                              },
                              child: StatusNavButton(
                                  selectedStatus: selectedStatus, index: index),
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
                      books: appBloc.searchBooks.isNotEmpty ||
                              appBloc.customIcon.icon != Icons.search
                          ? appBloc.searchBooks
                          : appBloc.books
                              .where((book) => book.status == selectedStatus)
                              .toList(),
                      appBloc: appBloc,
                      title: 'Reading'),
                ),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocConsumer<AppBloc, AppState>(
              bloc: appBloc,
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sizedBoxH(20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          appBloc.cleatSearch();
                        });
                        Navigator.pop(context);
                      },
                      child: Text('All (${appBloc.books.length})'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              appBloc.filter == all
                                  ? mainColor
                                  : mainColor.withOpacity(.3))),
                    ),
                    ExpansionTile(
                      title: Text('Authors (${appBloc.authors.length})'),
                      children: [
                        ...List.generate(appBloc.authors.length, (index) {
                          final String author =
                              appBloc.authors.keys.toList()[index];
                          return ElevatedButton(
                            onPressed: () {
                              appBloc.add(FilterByAuthor(author));
                              Navigator.pop(context);
                            },
                            child: Text(author +
                                ' (${appBloc.authors.values.toList()[index]})'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    appBloc.filter == author
                                        ? mainColor
                                        : mainColor.withOpacity(.5))),
                          );
                        })
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                          'Classifications (${appBloc.classifications.length})'),
                      children: [
                        ...List.generate(appBloc.classifications.length,
                            (index) {
                          final String classification =
                              appBloc.classifications.keys.toList()[index];

                          return ElevatedButton(
                            onPressed: () {
                              appBloc
                                  .add(FilterByClassification(classification));
                              Navigator.pop(context);
                            },
                            child: Text(classification +
                                ' (${appBloc.classifications.values.toList()[index]})'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    appBloc.filter == classification
                                        ? mainColor
                                        : mainColor.withOpacity(.5))),
                          );
                        })
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  child: AddBookForm(
                      function: () {
                        appBloc.add(GetBooksFromDB());
                      },
                      appBloc: appBloc),
                );
              }).then((value) => appBloc.add(GetBooksFromDB()));
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      title: appBloc.customIcon.icon == Icons.search
          ? gestureTitle
          : appBloc.customSearchBar,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                if (appBloc.customIcon.icon == Icons.search) {
                  appBloc.customIcon = const Icon(Icons.cancel);
                  appBloc.filter = all;
                  appBloc.customSearchBar = ListTile(
                    leading: const Icon(Icons.search, color: white),
                    title: TextField(
                      onChanged: (value) {
                        appBloc.searchBooks = appBloc.books
                            .where((book) => buildContains(book, value))
                            .toList();
                        setState(() {});
                      },
                      decoration: buildInputDecoration,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  appBloc.searchBooks.clear();
                  appBloc.customIcon = const Icon(Icons.search);
                  appBloc.customSearchBar = const Text(appName);
                }
              });
            },
            icon: appBloc.customIcon)
      ],
    );
  }

  InputDecoration get buildInputDecoration {
    return const InputDecoration(
      hintText: 'book name, author, classification...',
      hintStyle: TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
        fontSize: 14,
      ),
      border: InputBorder.none,
    );
  }

  Widget get gestureTitle {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: BackupDialog(appBloc: appBloc, context: context),
              );
            });
      },
      child: const Text(appName),
    );
  }

  bool buildContains(Book book, String value) {
    return book.name!.toLowerCase().contains(value.toLowerCase()) ||
        book.author!.toLowerCase().contains(value.toLowerCase()) ||
        (book.classification ?? '').toLowerCase().contains(value.toLowerCase());
  }
}

class StatusNavButton extends StatelessWidget {
  const StatusNavButton({
    Key? key,
    required this.selectedStatus,
    required this.index,
  }) : super(key: key);

  final int selectedStatus;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: SizeConfig.getW(5)),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getW(20), vertical: SizeConfig.getH(5)),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(15),
        color: selectedStatus == index ? mainColor : white,
      ),
      child: Text(
        statusList[index].title ?? '',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: selectedStatus == index ? white : mainColor,
            ),
      ),
    );
  }
}
