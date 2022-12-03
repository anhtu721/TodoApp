import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/page/dashboard/dashboard.dart';
import 'package:notes_application/page/sign_up/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Management Systems'),
      ),
      body: const SignInForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SignUpPage())),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isChecked = false;
  final _formKeySignIn = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String displayEmail = "";

  Future<void> initValue() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isChecked =  pref.getBool('key') ?? false;
      if(isChecked){
        _emailTextController.text = pref.getString('email') ?? "";
        _passwordTextController.text = pref.getString('password') ?? "";
      }
    });

  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  Future<List<Map<String, dynamic>>> _loginAction(Account account) async {
    final data = await SQLHelper.checkAccount(account);
    return data;
  }
  void setRemember(bool flag) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (flag) {
      pref.setString('email', _emailTextController.text);
      pref.setString('password', _passwordTextController.text);
    }
    else {
      pref.setString('email', _emailTextController.text);
      pref.setString('password', _passwordTextController.text);
      //await pref.clear();
    }
    pref.setBool('key', flag);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeySignIn,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Note Management System'),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString(
                          'displayEmail', _emailTextController.text);
                      var account = Account(
                          email: _emailTextController.text,
                          password: _passwordTextController.text);
                      List<Map<String, dynamic>> data =
                          await _loginAction(account);
                      if (data.isEmpty && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Failed')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Successful')));
                            setRemember(isChecked);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Dashboard()),
                            (route) => false);
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
