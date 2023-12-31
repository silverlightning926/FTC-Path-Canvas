import 'dart:io';

import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final String directoryPath;

  const EditorScreen({
    Key? key,
    required this.directoryPath,
  }) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final String projectFolderName = "paths";
  final TextEditingController _pathNameController = TextEditingController();
  final GlobalKey<FormState> _pathNameFormKey = GlobalKey<FormState>();
  List<String> currentProjectFiles = [];

  @override
  void initState() {
    super.initState();
    if (!checkIfProjectExists()) {
      createProject();
    } else {
      currentProjectFiles = getProjectFiles();
    }
  }

  bool checkIfProjectExists() {
    final projectFolderPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName";
    return Directory(projectFolderPath).existsSync();
  }

  void createProject() {
    final projectFolderPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName";
    Directory(projectFolderPath).createSync();
  }

  List<String> getProjectFiles() {
    final projectFolderPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName";
    return Directory(projectFolderPath).listSync().map((e) => e.path).toList();
  }

  String getProjectName() {
    final directoryPath = widget.directoryPath;
    return Platform.isWindows
        ? directoryPath.split("\\").last
        : directoryPath.split("/").last;
  }

  bool checkIfPathExists(String pathName) {
    final path =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$pathName.path";
    return File(path).existsSync();
  }

  void createPath(String pathName) {
    final path =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$pathName.path";
    File(path).createSync();
  }

  void renamePath(String oldPathName, String newPathName) {
    final oldPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$oldPathName.path";
    final newPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$newPathName.path";
    File(oldPath).renameSync(newPath);
  }

  void copyPath(String originalPathName, String copyPathName) {
    final originalPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$originalPathName.path";
    final copyPath =
        "${widget.directoryPath}/TeamCode/src/main/java/org/firstinspires/ftc/teamcode/$projectFolderName/$copyPathName.path";
    File(originalPath).copySync(copyPath);
  }

  String extractPathNameFromFilePath(String path) {
    final separator = Platform.isWindows ? "\\" : "/";
    final startIndex = path.lastIndexOf(separator) + 1;
    final endIndex = path.lastIndexOf(".");
    return path.substring(startIndex, endIndex);
  }

  Future<dynamic> showCreateDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Path"),
          content: Form(
            key: _pathNameFormKey,
            child: TextFormField(
              controller: _pathNameController,
              validator: validateNewPath,
              decoration: const InputDecoration(
                labelText: "Path Name",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_pathNameFormKey.currentState!.validate()) {
                  createPath(
                    _pathNameController.text.trim().toLowerCase(),
                  );
                  setState(() {
                    currentProjectFiles = getProjectFiles();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context, String path) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Path"),
          content: const Text("Are you sure you want to delete this path?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                File(path).deleteSync();
                setState(() {
                  currentProjectFiles = getProjectFiles();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showCopyDialog(BuildContext context, String pathName) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Copy Path"),
          content: Form(
            key: _pathNameFormKey,
            child: TextFormField(
              controller: _pathNameController,
              validator: validateNewPath,
              decoration: const InputDecoration(
                labelText: "Path Name",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_pathNameFormKey.currentState!.validate()) {
                  copyPath(
                    pathName,
                    _pathNameController.text.trim().toLowerCase(),
                  );
                  setState(() {
                    currentProjectFiles = getProjectFiles();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Copy"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showRenameDialog(BuildContext context, String pathName) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Rename Path"),
          content: Form(
            key: _pathNameFormKey,
            child: TextFormField(
              controller: _pathNameController,
              validator: validateNewPath,
              decoration: const InputDecoration(
                labelText: "Path Name",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_pathNameFormKey.currentState!.validate()) {
                  renamePath(
                    pathName,
                    _pathNameController.text.trim().toLowerCase(),
                  );
                  setState(() {
                    currentProjectFiles = getProjectFiles();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  String? validateNewPath(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a path name";
    }

    value = value.trim().toLowerCase();

    if (value.contains(RegExp(r'[<>:"/\\|?*]'))) {
      return "Path name cannot contain special characters";
    } else if (value.length > 20) {
      return "Path name cannot be longer than 20 characters";
    } else if (checkIfPathExists(value)) {
      return "A path with that name already exists";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getProjectName(),
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                getProjectName(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("New Path"),
              onTap: () async {
                _pathNameController.clear();
                await showCreateDialog(context);
              },
            ),
            const Divider(),
            for (String path in currentProjectFiles)
              ListTile(
                leading: const Icon(Icons.route_outlined),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem(
                        value: "rename",
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 15.0),
                            SizedBox(width: 10.0),
                            Text("Rename"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "copy",
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 15.0),
                            SizedBox(width: 10.0),
                            Text("Copy"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 15.0),
                            SizedBox(width: 10.0),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (String value) async {
                    String pathName = extractPathNameFromFilePath(path);

                    _pathNameController.text = pathName;

                    if (value == "rename") {
                      await showRenameDialog(context, pathName);
                    } else if (value == "copy") {
                      _pathNameController.text += "_copy";
                      await showCopyDialog(context, pathName);
                    } else if (value == "delete") {
                      await showDeleteDialog(context, path);
                    }
                  },
                ),
                title: Text(extractPathNameFromFilePath(path)),
                onTap: () {
                  setState(() {
                    selectedPathIndex = currentProjectFiles.indexOf(path);
                  });
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
      body: Center(
        child: Text(widget.directoryPath),
      ),
    );
  }
}
