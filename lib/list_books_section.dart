import 'package:books/bloc/app_bloc/app_bloc.dart';
import 'package:books/styles/colors.dart';
import 'package:books/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'add_book_form.dart';
import 'dependencies/dependency_init.dart';
import 'local_storage.dart';
import 'models/book_model.dart';

class ListBooksSection extends StatefulWidget {
  const ListBooksSection(
      {Key? key,
      required this.books,
      required this.appBloc,
      required this.title})
      : super(key: key);
  final String title;
  final List<Book> books;
  final AppBloc appBloc;

  @override
  State<ListBooksSection> createState() => _ListBooksSectionState();
}

class _ListBooksSectionState extends State<ListBooksSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getW(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: widget.books.isEmpty,
            child: Center(
              child: Text(
                'empty',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.books.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Book book = widget.books[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: AddBookForm(
                                  book: book,
                                  function: () {
                                    widget.appBloc.add(GetBooksFromDB());
                                  },
                                  appBloc: widget.appBloc,
                                ),
                              );
                            })
                        .then((value) => widget.appBloc.add(GetBooksFromDB()));
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Delete Book?'),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      getIt<DBHelper>().delete(
                                              booksT, widget.books[index].id!)
                                          .then((value) {
                                        widget.appBloc.add(GetBooksFromDB());
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: const Icon(Icons.done)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.clear)),
                              ],
                            ));
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.getW(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book,
                                  size: SizeConfig.getFontSize(50)),
                              if (book.rate != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(book.rate!.toString()),
                                    sizedBoxW(5),
                                    const Icon(Icons.star,
                                        color: yellow, size: 15),
                                  ],
                                )
                            ],
                          ),
                          sizedBoxW(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.name ?? 'no name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: dark),
                                ),
                                Text(
                                  'by ' + (book.author ?? 'no name'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(color: dark.withOpacity(.5)),
                                ),
                                Text(
                                  intl.DateFormat('y-M-d / ')
                                      .add_jm()
                                      .format(DateTime.parse(book.date!)),
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(color: dark.withOpacity(.5)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  sizedBoxH(5),
            ),
          ),
          // const Divider(color: mainColor),
        ],
      ),
    );
  }
}
