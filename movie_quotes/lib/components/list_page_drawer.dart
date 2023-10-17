import 'package:flutter/material.dart';
import 'package:movie_quotes/managers/auth_manager.dart';

class ListPageDrawer extends StatelessWidget {
  final void Function() showOnlyMineCallback;
  final void Function() showAllCallback;

  const ListPageDrawer({
    super.key,
    required this.showOnlyMineCallback,
    required this.showAllCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Text(
              "Movie Quotes",
              style: TextStyle(color: Colors.white, fontSize: 28.0),
            ),
          ),
          ListTile(
            title: Text("Show only my quotes"),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.of(context).pop();
              showOnlyMineCallback();
            },
          ),
          ListTile(
            title: Text("Show all quotes"),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.of(context).pop();
              showAllCallback();
            },
          ),
          const Spacer(),
          const Divider(
            thickness: 2.0,
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              AuthManager.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
