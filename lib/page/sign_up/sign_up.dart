import 'package:flutter/material.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/page/sign_in/sign_in.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Management System'),
      ),
      body: const SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _formKeySignUp = GlobalKey<FormState>();

  // ignore: unused_field
  List<Map<String, dynamic>> _list = [];
  // ignore: prefer_typing_uninitialized_variables
  var accountHelper;

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    accountHelper = SQLHelper();
  }

  @override
  void initState() {

    super.initState();
    _refreshAccount();
  }

  Future<void> _refreshAccount() async {
    final data = await SQLHelper.getAccounts();
    setState(() {
      _list = data;
    });
  }

  Future<void> _addUser() async {
    await SQLHelper.createAccount(
      Account(
        email: _emailTextController.text,
        password: _passwordTextController.text,
        firstName: _firstNameTextController.text,
        lastName: _lastNameTextController.text,
      ),
    );
    _refreshAccount();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
      child: Form(
      key: _formKeySignUp,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text('Sign Up Form'),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _firstNameTextController,
                  decoration: const InputDecoration(
                    hintText: 'First name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name.';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _lastNameTextController,
                  decoration: const InputDecoration(
                    hintText: 'Last name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name.';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                  controller: _confirmPasswordTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != _passwordTextController.text) {
                      return 'Confirm password is wrong';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKeySignUp.currentState!.validate()) {
                        _addUser();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Sign Up successful')));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInPage()),
                            (route) => false);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignInPage())),
                    child: const Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
