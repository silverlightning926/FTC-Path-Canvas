import 'dart:io';

import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final String directoryPath;

  const EditorScreen({
    super.key,
    required this.directoryPath,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String projectFolderName = "paths";

  bool checkIfProjectExists() {
    return Directory(
            "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName")
        .existsSync();
  }

  Future<void> createProject() async {
    Directory(
            "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName")
        .createSync();
  }

  @override
  void initState() {
    super.initState();

    if (!checkIfProjectExists()) {
      createProject();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.directoryPath),
      ),
    );
  }
}
