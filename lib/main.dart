import 'package:books/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'dependencies/dependency_init.dart';
import 'home_screen.dart';
import 'styles/themes.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await getIt<DBHelper>().call(booksT);
  runApp(const MyApp());
}

const String appName = 'Abdelsalam books';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return BlocProvider(
            create: (context) => getIt<AppBloc>(),
            child: MaterialApp(
              title: appName,
              theme: lightTheme,
              useInheritedMediaQuery: true,
              home: const MyHomePage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
  }
}
