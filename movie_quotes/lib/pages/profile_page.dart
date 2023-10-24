import 'dart:async';

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

  @override
  void initState() {
    _userDataSubscription = UserDataDocumentManager.instance.startListening(
      documentId: AuthManager.instance.uid,
      observer: () {
        setState(() {
          // Later... update the nameController.text
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              AvatarImage(imageUrl: UserDataDocumentManager.instance.imageUrl),
            ],
          ),
        ));
  }
}
