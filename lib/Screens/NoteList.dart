import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Models/Note.dart';
import 'package:todo_list/Screens/NoteDetails.dart';
import 'package:todo_list/Utils/Database_Helpers.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note-Keeper',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      // backgroundColor: Colors.deepPurpleAccent[100],
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Note",
        onPressed: () {
          navigateToNoteDetails(Note('', '', '', 2), 'Add Note');
        },
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4.0,
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[index].priorities),
              child: getPriorityIcon(noteList[index].priorities),
            ),
            title: Text(
              noteList[index].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(noteList[index].date),
            trailing: GestureDetector(
              onTap: (){
                _delete(context, noteList[index]);
              },
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              navigateToNoteDetails(noteList[index], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void navigateToNoteDetails(Note note, String title) async{
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetails(note: note,title: title)));
    if(result == true){
      updateListView();
    }
  }
}
