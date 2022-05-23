import 'package:books/bloc/app_bloc/app_bloc.dart';
import 'package:books/styles/size_config.dart';
import 'package:books/widgets/app_button.dart';
import 'package:books/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'dependencies/dependency_init.dart';
import 'local_storage.dart';
import 'models/book_model.dart';
import 'models/status_model.dart';
import 'styles/colors.dart';
import 'widgets/components.dart';

class AddBookForm extends StatefulWidget {
  final Book? book;
  final Function? function;
  final AppBloc appBloc;
  const AddBookForm({Key? key, this.book, this.function, required this.appBloc})
      : super(key: key);

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = getIt<DBHelper>();
  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final statusController = TextEditingController();
  final classificationController = TextEditingController();
  double rate = 0;
  int statusId = 1;
  bool statusChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      nameController.text = widget.book!.name!;
      authorController.text = widget.book!.author!;
      statusController.text = statusList
          .firstWhere((element) => element.id == widget.book!.status!)
          .title!;
      statusId = widget.book!.status!;
      classificationController.text = widget.book!.classification ?? '';
      rate = widget.book!.rate ?? 0.0;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    statusController.dispose();
    classificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.getW(8)),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxH(20),
              defaultFormField(
                controller: nameController,
                type: TextInputType.text,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return emptyError;
                  }
                  return null;
                },
                label: 'Name',
                prefix: null,
              ),
              sizedBoxH(10),
              defaultFormField(
                controller: authorController,
                type: TextInputType.name,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return emptyError;
                  }
                  // List<String> v = BookStatus.values.map((e) => e.name).toList();
                  return null;
                },
                label: 'Author',
                prefix: null,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Authors',
                      style: Theme.of(context).textTheme.bodyText1),
                  items: List.generate(
                      widget.appBloc.authors.length,
                      (index) => DropdownMenuItem<String>(
                            value: widget.appBloc.authors.keys.toList()[index],
                            child: Text(
                                widget.appBloc.authors.keys.toList()[index]),
                          )),
                  onChanged: (value) {
                    authorController.text = value!;
                  },
                ),
              ),

              defaultFormField(
                controller: classificationController,
                type: TextInputType.text,
                validate: (String? value) {
                  // if (value!.isEmpty) {
                  //   return emptyError;
                  // }
                  return null;
                },
                label: ' Classification',
                prefix: null,
              ),
              sizedBoxH(10),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Classifications',
                      style: Theme.of(context).textTheme.bodyText1),
                  items: List.generate(
                      widget.appBloc.classifications.length,
                      (index) => DropdownMenuItem<String>(
                            value: widget.appBloc.classifications.keys
                                .toList()[index],
                            child: Text(widget.appBloc.classifications.keys
                                .toList()[index]),
                          )),
                  onChanged: (value) {
                    if (!classificationController.text.contains(value!)) {
                      classificationController.text += ' ' + value.trim();
                    }
                  },
                ),
              ),
              sizedBoxH(10),
              Visibility(
                  visible: widget.book != null,
                  child: Text('Number of reads : ${widget.book?.numberOfReads}',
                      style: Theme.of(context).textTheme.headline2)),
              sizedBoxH(10),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemSize: SizeConfig.getFontSize(20),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: yellow,
                ),
                onRatingUpdate: (rating) {
                  rate = rating;
                },
              ),
              // sizedBoxH(10),
              // Visibility(
              //   visible: widget.book != null,
              //   child: Text(
              //     widget.book?.classification ?? '',
              //     style: Theme.of(context)
              //         .textTheme
              //         .headline2!
              //         .copyWith(fontStyle: FontStyle.italic, color: yellow),
              //   ),
              // ),
              sizedBoxH(20),
              DropdownButtonHideUnderline(
                child: DropdownButton<Status>(
                  isExpanded: true,
                  hint: Text(
                    statusController.text.isNotEmpty
                        ? statusController.text
                        : 'status',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  items: statusList.map((Status value) {
                    return DropdownMenuItem<Status>(
                      value: value,
                      child: Text(value.title!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    statusChanged = true;
                    setState(() {
                      statusController.text = value!.title!;
                      statusId = value.id!;
                    });
                  },
                ),
              ),
              sizedBoxH(20),
              AppButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.appBloc.books.any((book) {
                      if (widget.book != null && book.id == widget.book?.id) {
                        return false;
                      }
                      return book.name?.trim().toLowerCase() ==
                          nameController.text.trim().toLowerCase();
                    })) {
                      return alert(context);
                    }
                    if (widget.book == null) {
                      Book bk = Book(
                        name: nameController.text.trim(),
                        author: authorController.text.trim(),
                        classification: classificationController.text.trim(),
                        status: statusId,
                        rate: rate,
                        numberOfReads: 0,
                        date: DateTime.now().toString(),
                      );
                      increaseReadsNumder(bk);
                      dbHelper.insert(booksT, bk).then((int id) {
                        Navigator.pop(context);
                        // bk.id = id;
                        // showRateDialog(context, bk);
                      });
                    } else {
                      widget.book?.name = nameController.text.trim();
                      widget.book?.author = authorController.text.trim();
                      widget.book?.classification =
                          classificationController.text.trim();
                      widget.book?.rate = rate;
                      widget.book?.status = statusId;
                      widget.book?.date = DateTime.now().toString();
                      increaseReadsNumder(widget.book!);
                      dbHelper.update(booksT, widget.book!).whenComplete(() {
                        Navigator.pop(context);
                        // showRateDialog(context, widget.book!);
                      });
                    }
                  }
                },
                text: widget.book != null ? 'Save' : 'Add book',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void showRateDialog(BuildContext context, Book bk) {
  //   if (statusId == 2 && statusChanged) {
  //     Navigator.pop(context);
  //     showDialog(
  //         context: context,
  //         builder: (context) => Dialog(
  //               child: AddRateFrom(book: bk),
  //             )).then((value) => widget.function!());
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }

  void increaseReadsNumder(Book bk) {
    if (statusId == 2 && statusChanged) {
      bk.numberOfReads++;
    }
  }
}
