import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'dependencies/dependency_init.dart';
import 'home_screen.dart';
import 'styles/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
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
          return BlocProvider(
            create: (context) => getIt<AppBloc>(),
            child: MaterialApp(
              title: appName,
              theme: lightTheme,
              home: const MyHomePage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
  }
}
