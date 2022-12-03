import 'package:flutter/material.dart';
import 'package:notes_application/page/dashboard/dashboard.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _screenChangePassword(),
    );
  }
}

class _screenChangePassword extends StatefulWidget {
  const _screenChangePassword({Key? key}) : super(key: key);

  @override
  State<_screenChangePassword> createState() => _screenChangePasswordState();
}

class _screenChangePasswordState extends State<_screenChangePassword> {
  final _formChangeProfile = GlobalKey<FormState>();
  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  final _againPass = TextEditingController();

  static List<Map<String, dynamic>> _acc = [];

  Future<int> _idAccount(String emailSignIn) async {
    //Find the id of the account want to update
    final _accoount = await SQLHelper.getEmail(emailSignIn);
    return _accoount[0]['uid'];
  }

  Future<void> _initValue() async {
    //run first to save the current email, current firstname, current lastname in the List _acc
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    _acc = await SQLHelper.getEmail(email!);
  }

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('Change Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formChangeProfile,
              child: Column(children: [
                const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 30, color: Colors.deepOrange),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current password';
                      } else if (value != _acc[0]['password']) {
                        return 'Current password is not correct';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter current password'),
                    controller: _currentPass,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter new password'),
                    controller: _newPass,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please password again';
                      } else if (value != _newPass.text) {
                        return 'Re-enter wrong password';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter password again'),
                    controller: _againPass,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formChangeProfile.currentState!.validate()) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            var email = pref.getString('email');
                            var id = await _idAccount(email!);
                            //print(id);
                            if (id != null) {
                              await _updateAccount(id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Change password successful')));
                            }
                          }
                        },
                        child: const Text('Change'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Dashboard())),
                        child: const Text('Home'),
                      )
                    ],
                  ),
                )
              ])),
        ));
  }

  Future<void> _updateAccount(int id) async {
    await SQLHelper.updateAccount(Account(
        uid: id,
        email: _acc[0]['email'],
        firstName: _acc[0]['firstName'],
        lastName: _acc[0]['lastName'],
        password: _newPass.text));
  }
}
