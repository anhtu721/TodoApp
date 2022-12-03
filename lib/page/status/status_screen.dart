import 'package:flutter/material.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/widget/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Status'),
      ),
      body: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {

  List<Map<String, dynamic>> _journalStatuses = [];
  bool _isLoading = true;
  bool isChecked =  true;
  String? _email = '';
  List<Map<String, dynamic>> _journalNotes = [];

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getStatuses();

    final dataNote = await SQLHelper.getNotes();

    SharedPreferences pref= await SharedPreferences.getInstance();

    setState(() {
      _journalStatuses = data;

      _journalNotes = dataNote;

      _isLoading = false;

      _email = pref.getString('email')??"";
      isChecked = pref.getBool('remember')?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _statusController = TextEditingController();

  void _showForm(int? idStatus) async {
    if (idStatus != null) {
      // id == null -> create
      // id != null -> update
      final existingJournal =
          _journalStatuses.firstWhere((element) => element['idStatus'] == idStatus);
      _statusController.text = existingJournal['status'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 240,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(hintText: 'Status'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (idStatus == null) {
                  await _addStatus();
                }

                if (idStatus != null) {
                  await _updateStatus(idStatus);
                }

                _statusController.text = '';

                if (!mounted) return;

                Navigator.of(context).pop();
              },
              child: Text(idStatus == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  //Insert
  Future<void> _addStatus() async {
    await SQLHelper.createStatus(Status(
      status: _statusController.text,
      email: _email,
    ));
    _refreshJournals();
  }

  //Update
  Future<void> _updateStatus(int idStatus) async {
    await SQLHelper.createStatus(Status(
      idStatus: idStatus,
      status: _statusController.text,
      email: _email,
    ));
    _refreshJournals();
  }

  //Delete
  Future<void> _deleteStatus(int idStatus) async {
    var result = _journalStatuses.firstWhere((element) => element['idStatus'] == idStatus);

    var contain = _journalNotes
        .where((element) => element['status'] == result['status'] && element['email']== result[_email]);

    if (contain.isEmpty) {
      await SQLHelper.deleteStatus(idStatus);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deleted a journal')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('ko dc xoa')));
    }

    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journalStatuses.length,
              itemBuilder: (context, index) => Card(
                    color: Colors.orange[200],
                    margin: const EdgeInsets.all(15),
                    child: _journalStatuses[index]['email'] == _email ? ListTile(
                      title: Text(_journalStatuses[index]['status']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    _showForm(_journalStatuses[index]['idStatus']),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () => _deleteStatus(
                                    _journalStatuses[index]['idStatus']),
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    ):null,
                  )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
      // drawer: Drawer(
      //   // Add a ListView to the drawer. This ensures the user can scroll
      //   // through the options in the drawer if there isn't enough vertical
      //   // space to fit everything.
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const UserAccountsDrawerHeader(
      //         decoration: BoxDecoration(color: Colors.teal),
      //         accountName: Text(
      //           "Pinkesh Darji",
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         accountEmail: Text(
      //           "pinkesh.earth@gmail.com",
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         currentAccountPicture: CircleAvatar(
      //           radius: 50.0,
      //           backgroundImage: NetworkImage(
      //               'https://i.pinimg.com/474x/0c/eb/c3/0cebc3e2a01fe5abcff9f68e9d2a06e4.jpg'),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Home'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => _dashboard));
      //           // Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.category),
      //         title: const Text('Category'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => _category));
      //           // Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.priority_high),
      //         title: const Text('Priority'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => _priority));
      //           // Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.expand),
      //         title: const Text('Status'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.note),
      //         title: const Text('Note'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //       const Divider(),
      //       const ListTile(
      //           title: Opacity(
      //         opacity: 0.5,
      //         child: Text("Account"),
      //       )),
      //       ListTile(
      //         leading: const Icon(Icons.edit),
      //         title: const Text('Edit Profile'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.key),
      //         title: const Text('Change Password'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
