import 'package:flutter/material.dart';

import '../bloc/app_bloc/app_bloc.dart';
import '../dependencies/dependency_init.dart';
import '../utils/backup/storage.dart';
import 'dialogs.dart';

class BackupDialog extends StatelessWidget {
  const BackupDialog({
    Key? key,
    required this.appBloc,
    required this.context,
  }) : super(key: key);

  final AppBloc appBloc;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => appBloc.saveBooksToFile().then((value) {
            doneAlert(context);
          }),
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => appBloc.readBooks().then((value) {
            doneAlert(context);
          }),
          child: const Text('Read'),
        ),
        TextButton(
          onPressed: () => getIt<Storage>().share(appBloc.books),
          child: const Text('Share'),
        ),
        TextButton(
          onPressed: () => getIt<Storage>().shareCSV(),
          child: const Text('Share csv'),
        ),
        TextButton(
          onPressed: () => appBloc.readBooksFromFilePicker(),
          child: const Text('File Picker'),
        ),
      ],
    );
  }
}
