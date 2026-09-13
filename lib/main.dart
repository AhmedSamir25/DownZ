import 'package:downz/logic/cubits/file_download_cubit.dart';
import 'package:downz/logic/download/dio_download_file.dart';
import 'package:downz/view/download/download_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FileDownloadCubit(DioDownloadFile()),
      child: MaterialApp(
        title: 'Downz',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const DownloadView(),
      ),
    );
  }
}
