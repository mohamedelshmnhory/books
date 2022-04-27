import 'package:books/bloc/app_bloc/app_bloc.dart';
import 'package:books/styles/colors.dart';
import 'package:books/styles/size_config.dart';
import 'package:books/widgets/backup_dialog.dart';
import 'package:flutter/foundation.dart';
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
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(appName);

  @override
  void initState() {
    appBloc.add(GetBooksFromDB());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customIcon.icon == Icons.search ? gestureTitle : customSearchBar,
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
                          appBloc.searchBooks = appBloc.books
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
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text(appName);
                  }
                });
              },
              icon: customIcon)
        ],
      ),
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
        child: Column(
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
                              selectedStatus = index;
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
                              color:
                                  selectedStatus == index ? mainColor : white,
                            ),
                            child: Text(
                              statusList[index].title ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
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
              child: BlocConsumer<AppBloc, AppState>(
                bloc: appBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  return ListBooksSection(
                      books: customIcon.icon != Icons.search
                          ? appBloc.searchBooks
                          : appBloc.books
                              .where((book) => book.status == selectedStatus)
                              .toList(),
                      appBloc: appBloc,
                      title: 'Reading');
                },
              ),
            ),
          ],
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
