import 'package:flutter/material.dart';
import 'package:notes_application/page/dashboard/dashboard.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _screenEditProfile(),
    );
  }
}

class _screenEditProfile extends StatefulWidget {
  const _screenEditProfile({Key? key}) : super(key: key);

  @override
  State<_screenEditProfile> createState() => _screenEditProfileState();
}

class _screenEditProfileState extends State<_screenEditProfile> {
  final _formEditProfile = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();

  static List<Map<String, dynamic>> _acc = [];

  Future<int> _idAccount(String emailSignIn) async {
    //Find the id of the account want to update
    final _accoount = await SQLHelper.getEmail(emailSignIn);
    return _accoount[0]['uid'];
  }

  Future<void> _initValue() async {
    //run first to save the current password in the List _acc
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    _acc = await SQLHelper.getEmail(email!);
    _email.text = email; //show current email on profile edit form
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
          title: const Text('EditProfile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formEditProfile,
              child: Column(children: [
                const Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 40, color: Colors.purpleAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter you first name'),
                    controller: _firstName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter you last name'),
                    controller: _lastName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter your email'),
                    controller: _email,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formEditProfile.currentState!.validate()) {
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
                                          Text('Edit profile successful')));
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
      email: _email.text, //show current email on profile edit form
      firstName: _firstName.text,
      lastName: _lastName.text,
      password: _acc[0]['password'], //retain the password of the edit email
    ));
  }
}
