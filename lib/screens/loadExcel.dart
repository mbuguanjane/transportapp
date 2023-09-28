import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class LoadExcel extends StatelessWidget {
  LoadExcel({super.key});
  String? filePath;
  void _pickleFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    print(result.files.first.path);
    filePath = result.files.first.path!;
    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);

    for (var element in fields.skip(1)) {
      print(element);
    }
  }

  Future getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
      print("Fail file upload");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //getPdfAndUpload();
          _pickleFile();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
