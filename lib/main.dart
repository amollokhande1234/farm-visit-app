import 'package:feild_visit_app/features/auth/screens/login_screen.dart';
import 'package:feild_visit_app/features/home/bloc/add_visit/add_visit_cubit.dart';
import 'package:feild_visit_app/features/home/bloc/location/location_cubit.dart';
import 'package:feild_visit_app/features/home/bloc/visit/visit_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'consts/hive_storage.dart';
import 'core/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VisitCubit()),
        BlocProvider(create: (_) => AddVisitCubit()),
        BlocProvider(create: (_) => LocationCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: AppColors.primary,
        appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade600),
        scaffoldBackgroundColor: AppColors.lightGreen,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
    );
  }
}
