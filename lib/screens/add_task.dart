import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/helpers/database_helper.dart';

class AddTask extends StatefulWidget {
  final Task task;
  final Function updateTaskList;
  AddTask({this.updateTaskList, this.task});
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  DateTime date = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  _handleDatePicker() async {
    final DateTime _date = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_date != date && _date != null) {
      setState(() {
        date = _date;
      });
    }
    _dateController.text = _dateFormatter.format(date);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Task task = Task(title: title, date: date);
      if (widget.task == null) {
        task.status = '0';
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    if (widget.task != null) {
      title = widget.task.title;
      date = widget.task.date;
    }
    _dateController.text = _dateFormatter.format(date);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.task == null ? "Add Task" : "Update Task",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                labelText: "Title",
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            validator: (input) => input.trim().isEmpty
                                ? "Please enter a title"
                                : null,
                            onSaved: (input) => title = input,
                            initialValue: title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                labelText: "Date",
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                                onPressed: _submit,
                                child: Text(
                                    widget.task == null ? "Add" : "Update",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
