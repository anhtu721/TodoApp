import 'package:flutter/material.dart';
import 'package:notes_application/page/category/category_screen.dart';
import 'package:notes_application/page/change_password/change_password.dart';
import 'package:notes_application/page/dashboard/dashboard.dart';
import 'package:notes_application/page/edit_profile/edit_profile.dart';
import 'package:notes_application/page/notes/note_screen.dart';
import 'package:notes_application/page/priority/priority_screen.dart';
import 'package:notes_application/page/sign_in/sign_in.dart';

import '../page/status/status_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Notes Management Systems'),
            accountEmail: const Text('123@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Dashboard(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Category'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const CategoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.priority_high),
            title: const Text('Priority'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const PriorityScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.priority_high),
            title: const Text('Status'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const StatusScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Note'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const NotePage(),
                ),
              );
            },
          ),
          const Divider(
            height: 1.5,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Account'),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const EditProfile(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ChangePassword(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SignInPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
