import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/components/avatar_image.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/user_data_document_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamSubscription? _userDataSubscription;
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userDataSubscription = UserDataDocumentManager.instance.startListening(
      documentId: AuthManager.instance.uid,
      observer: () {
        setState(() {
          nameController.text = UserDataDocumentManager.instance.displayName;
          print("Display name ${UserDataDocumentManager.instance.displayName}");
          print("Image URL ${UserDataDocumentManager.instance.imageUrl}");
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    UserDataDocumentManager.instance.stopListening(_userDataSubscription);
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = UserDataDocumentManager.instance.imageUrl;

    // TODO: If a new image has been uploaded use it instead!

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                AvatarImage(imageUrl: imageUrl),
                const SizedBox(
                  height: 4.0,
                ),
                UploadButton(
                  // Start here next time:
                  // From https://github.com/firebase/FirebaseUI-Flutter/blob/main/docs/firebase-ui-storage/upload-button.md
                  // and https://firebase.google.com/docs/storage/flutter/upload-files#add_file_metadata
                  // extensions: ["jpg", "png", "jpeg"],
                  // mimeTypes: ["image/jpeg", "image/png"],
                  // metadata: SettableMetadata(contentType: "image/jpeg"),
                  onError: (e, s) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  ),
                  onUploadComplete: (ref) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Upload complete: ${ref.fullPath}"),
                    ),
                  ),
                  variant: ButtonVariant.outlined,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Display Name",
                    hintText: "Enter a display name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please add a display name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Everything is Valid!
                          UserDataDocumentManager.instance
                              .update(displayName: nameController.text);
                          Navigator.of(context).pop();
                        } else {
                          // Something is wrong
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Add a display name"),
                          //   ),
                          // );
                        }
                      },
                      child: const Text("Save and Close"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
