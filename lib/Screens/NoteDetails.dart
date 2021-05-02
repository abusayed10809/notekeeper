import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Models/Note.dart';
import 'package:todo_list/Utils/Database_Helpers.dart';

class NoteDetails extends StatefulWidget {
  final String title;
  final Note note;
  NoteDetails({this.note, this.title});

  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.note, this.title);
}

class _NoteDetailsState extends State<NoteDetails> {

  String title;
  Note note;
  _NoteDetailsState(this.note, this.title);

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  static var _priorities = ['High', 'Low'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    _titleController.text = note.title;
    _descriptionController.text = note.description;

    return WillPopScope(

      // ignore: missing_return
      onWillPop: (){
        moveToLastScreen();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),

        body: ListView(
          children: [

            Padding(
              padding: EdgeInsets.all(width*0.05),
              child: ListTile(
                title: DropdownButton(
                  items: _priorities.map((dropdownStringItem){
                    return DropdownMenuItem(
                      value: dropdownStringItem,
                      child: Text(
                        dropdownStringItem
                      ),
                    );
                  }).toList(),
                  value: getPriorityAsString(note.priorities),
                  onChanged: (value){
                    setState(() {
                      print(value);
                      updatePriorityAsInt(value);
                    });
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(width*0.05),
              child: TextField(
                controller: _titleController,
                onChanged: (value){
                  print(value);
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width*0.01),
                  )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(width*0.05),
              child: TextField(
                controller: _descriptionController,
                onChanged: (value){
                  print(value);
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width*0.01),
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(width*0.05),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: RaisedButton(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      color: Colors.deepPurple,
                      onPressed: (){
                        _save();
                      },
                    ),
                  ),

                  Expanded(flex: 1,child: Container(),),

                  Expanded(
                    flex: 5,
                    child: RaisedButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      color: Colors.deepPurple,
                      onPressed: (){
                        _delete();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priorities = 1;
        break;
      case 'Low':
        note.priorities = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'High'
        break;
      case 2:
        priority = _priorities[1];  // 'Low'
        break;
    }
    return priority;
  }

  void updateTitle(){
    note.title = _titleController.text;
  }

  void updateDescription(){
    note.description = _descriptionController.text;
  }

  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // AlertDialog alertDialog = AlertDialog(
    //   title: Text(title),
    //   content: Text(message),
    // );
    // showDialog(
    //     context: context,
    //     builder: (_) => alertDialog
    // );
  }


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
