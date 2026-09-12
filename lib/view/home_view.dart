import 'package:downz/logic/cubit/file_download_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final urlEditingController =  TextEditingController() ;
    return BlocConsumer<FileDownloadCubit, FileDownloadState>(
      listener: (context, state) {
        if (state is FileDownloadErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(state.message))
          );
          print("--------");
          print(state.message);
          print("000000");
        }
      },
      builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            TextField(
              controller: urlEditingController,
            ),
            SizedBox(height: 50,),
            MaterialButton(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Download"
                    , style: TextStyle(
                      color: Colors.white,
                    ),),),
              ),
              onPressed: () {
                print("try: ${urlEditingController.toString()} ");
                context.read<FileDownloadCubit>().downloadFile(url: urlEditingController.text.trim());            },)
          ],
        ),
      );
    },);
  }
}
