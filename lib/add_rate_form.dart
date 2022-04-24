import 'package:books/styles/size_config.dart';
import 'package:books/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'local_storage.dart';
import 'models/book_model.dart';
import 'widgets/components.dart';

class AddRateFrom extends StatefulWidget {
  final Book? book;
  const AddRateFrom({Key? key, this.book}) : super(key: key);

  @override
  State<AddRateFrom> createState() => _AddRateFromState();
}

class _AddRateFromState extends State<AddRateFrom> {
  final formKey = GlobalKey<FormState>();

  final classificationController = TextEditingController();
  double rate = 0;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      classificationController.text = widget.book!.classification ?? '';
      rate = widget.book!.rate ?? 0.0;
      // nameController.text = widget.book!.name!;
    }
  }

  @override
  void dispose() {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxH(20),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rate = rating;
                },
              ),
              sizedBoxH(20),
              defaultFormField(
                controller: classificationController,
                type: TextInputType.name,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return emptyError;
                  }
                  return null;
                },
                label: ' classification',
                prefix: null,
              ),
              sizedBoxH(20),
              AppButton(
                function: () {
                  if (formKey.currentState!.validate()) {
                    widget.book?.classification = classificationController.text;
                    widget.book?.rate = rate;
                    DBHelper.update(booksT, widget.book!).whenComplete(() {
                      Navigator.pop(context);
                    });
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
