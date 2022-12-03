import 'package:flutter/material.dart';
import 'package:notes_application/sql/db_helper.dart';
import 'package:notes_application/sql/items.dart';
import 'package:notes_application/widget/navbar.dart';
import 'widget/categories_dropdown.dart';
import 'widget/priorities_dropdown.dart';
import 'widget/status_dropdown.dart';



class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];


class _NotePageState extends State<NotePage> {
  DateTime _date = DateTime(2022,10,26);
  String? _selectedDate = '';
  List<Note> notes = [];
  bool isLoading = true;
  Category? _selectedCategory;
  Priority? _selectedPriority;
  Status? _selectedStatus;

  categoryCallback(selectedCategory){
    setState(() {
      _selectedCategory = selectedCategory;
      print(_selectedCategory?.category);
    });
  }

  priorityCallback(selectedPriority){
    setState(() {
      _selectedPriority = selectedPriority;
      print(_selectedPriority?.priority);
    });
  }

  statusCallback(selectedStatus){
    setState(() {
      _selectedStatus = selectedStatus;
      print(_selectedStatus?.status);
    });
  }

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _refreshNote();
  }

  Future<void> _refreshNote() async {
    final data = await SQLHelper.getAllNotes();

    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  Future<void> _addNote() async {
    await SQLHelper.createNote(Note(
      noteName: _noteController.text,
      category: _selectedCategory?.category,
      priority: _selectedPriority?.priority,
      status: _selectedStatus?.status,
      date: _selectedDate,
    ));
    _refreshNote();
  }

  Future<void> _updateNote(int id) async {
    await SQLHelper.updateNote(Note(
      idNote: id,
      noteName: _noteController.text,
      category: _selectedCategory?.category,
      priority: _selectedPriority?.priority,
      status: _selectedStatus?.status,
      date: _selectedDate,
    ));

    _refreshNote();
  }

  Future<void> _deleteNote(int id) async {
    await SQLHelper.deleteNote(id);

    if(!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully deleted note'))
    );

    _refreshNote();
  }

  void _showForm (int? id) async {
    if(id != null){
      final existingNote = notes.firstWhere((element) => element.idNote == id);
      _noteController.text = existingNote.noteName!;
    }

    showModalBottomSheet(
        context: context,
        elevation: 16,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: 'Note'),
              ),
              const SizedBox(height: 10,),
              FutureBuilder<List<Category>>(
                future: SQLHelper.getAllCategories(),
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? CategoriesDropdown(snapshot.data!, categoryCallback)
                      : const Text('No categories');
                },
              ),
              FutureBuilder<List<Priority>>(
                future: SQLHelper.getAllPriorities(),
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? PrioritiesDropdown(snapshot.data!, priorityCallback)
                      : const Text('No priorities');
                },
              ),
              FutureBuilder<List<Status>>(
                future: SQLHelper.getAllStatus(),
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? StatusDropdown(snapshot.data!, statusCallback)
                      : const Text('No status');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.orange,width: 1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:  [
                      ElevatedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.date_range_outlined, color: Colors.white),
                            Text('Select date'),
                          ],
                        ),
                        onPressed:() async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2200),

                          );
                          if (newDate == null) return;


                          setState(() => _date = newDate);
                          _selectedDate= '${_date.year}/${_date.month}/${_date.day}';
                        },
                      ),
                      Text(
                        '${_date.year}/${_date.month}/${_date.day}',
                        style: TextStyle(fontSize: 25),

                      ),
                      // const SizedBox(height: 10,),

                    ],
                  ),

                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addNote();
                  }

                  if (id != null) {
                    await _updateNote(id);
                  }

                  _noteController.text = '';

                  if(!mounted) return;

                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      drawer: const NavBar(),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
            ? const Text('No Note')
            : buildNotePage(),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showForm(null)
      ),
    );
  }

  Widget buildNotePage() => ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final color = _lightColors[index % _lightColors.length];
        //final time = DateFormat('yyyy-MM-dd hh:mm').format(_categories[index]['createdAt']) as DateTime;
        return Card(
          color: color,
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(
              notes[index].noteName!,
              style: const TextStyle(
                fontSize: 20,

              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${_selectedCategory?.category}'),
                Text('priority: ${_selectedPriority?.priority}'),
                Text('status: ${_selectedStatus?.status}'),
                Text('Date: ${_selectedDate}'),
              ],
            ),
            //subtitle: Text(
            //time.toString(),
            //style: TextStyle(color: Colors.grey.shade700),),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => _showForm(notes[index].idNote),
                      icon: const Icon(Icons.edit)
                  ),
                  IconButton(
                      onPressed: () => _deleteNote(notes[index].idNote!),
                      icon: const Icon(Icons.delete)
                  ),
                ],
              ),
            ),
            // onTap: () async {
            //   await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryDetailPage(categoryId: categories[index].categoryId)));
            // }
          ),
        );
      }
  );
}

