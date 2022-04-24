import 'package:books/add_rate_form.dart';
import 'package:books/styles/size_config.dart';
import 'package:books/widgets/app_button.dart';
import 'package:flutter/material.dart';

import 'local_storage.dart';
import 'models/book_model.dart';
import 'models/status_model.dart';
import 'styles/colors.dart';
import 'widgets/components.dart';

class AddBookForm extends StatefulWidget {
  final Book? book;
  final Function? function;
  const AddBookForm({Key? key, this.book, this.function}) : super(key: key);

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final statusController = TextEditingController();
  int statusId = 1;

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
      // nameController.text = widget.book!.name!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    statusController.dispose();
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
                type: TextInputType.name,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return emptyError;
                  }
                  return null;
                },
                label: 'name',
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
                label: 'author',
                prefix: null,
              ),
              sizedBoxH(10),
              Visibility(
                  visible: widget.book != null,
                  child: Text('Number of reads : ${widget.book?.numberOfReads}',
                      style: Theme.of(context).textTheme.headline2)),
              sizedBoxH(10),
              Visibility(
                visible: widget.book != null,
                child: Text(
                  widget.book?.classification ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontStyle: FontStyle.italic,color: yellow),
                ),
              ),
              sizedBoxH(10),
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
                    if (widget.book == null) {
                      final bk = Book(
                        name: nameController.text,
                        status: statusId,
                        author: authorController.text,
                        date: DateTime.now().toString(),
                      );
                      DBHelper.insert(booksT, bk)
                          .whenComplete(() => Navigator.pop(context));
                    } else {
                      widget.book?.name = nameController.text;
                      widget.book?.author = authorController.text;
                      widget.book?.status = statusId;
                      widget.book?.date = DateTime.now().toString();
                      if (widget.book?.status == 2) {
                        widget.book?.numberOfReads++;
                      }
                      DBHelper.update(booksT, widget.book!).whenComplete(() {
                        if (widget.book?.status == 2) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: AddRateFrom(book: widget.book),
                                  )).then((value) => widget.function!());
                        } else {
                          Navigator.pop(context);
                        }
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
}
