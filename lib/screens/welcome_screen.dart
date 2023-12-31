import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:ftc_path_canvas/screens/editor_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? directoryPath;

  bool checkIfProjectIsValid(String directoryPath) {
    // Check if directoryPath is a valid FTC project
    List<String> requiredDirectories = [
      "TeamCode",
      "TeamCode/src/main/java/org/firstinspires/ftc/teamcode",
    ];

    for (String requiredDirectory in requiredDirectories) {
      if (!Directory("$directoryPath/$requiredDirectory").existsSync()) {
        return false;
      }
    }

    return true;
  }

  Future<void> showAlertDialog({
    required String title,
    required String content,
    required String confirmButtonText,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FTC Path Canvas",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Welcome to FTC Path Canvas! To get started, open an FTC project.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String? result = await getDirectoryPath(
                  confirmButtonText: "Open FTC Project",
                );

                if (result != null) {
                  setState(() {
                    directoryPath = result;
                  });
                }
              },
              child: Text(
                "${directoryPath == null ? "Select An" : "Change"} FTC Project",
              ),
            ),
            const SizedBox(height: 16.0),
            Visibility(
              visible: directoryPath != null,
              child: ElevatedButton(
                onPressed: () {
                  if (checkIfProjectIsValid(directoryPath!)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EditorScreen(
                            directoryPath: directoryPath!,
                          );
                        },
                      ),
                    );
                  } else {
                    showAlertDialog(
                      title: "Invalid FTC Project",
                      content:
                          "The selected directory is not a valid FTC project.",
                      confirmButtonText: "OK",
                    );
                  }
                },
                child: const Text("Continue"),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              directoryPath ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
