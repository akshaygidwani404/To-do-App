import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/helpers/database_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/add_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  // final Task task;
  // final Function updateTaskList;
  // HomeScreen{this.updateTaskList, this.task});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Task>> _taskList;

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  // _delete() {
  //   setState(() {
  //     DatabaseHelper.instance.deleteTask(task.id);
  //     _updateTaskList();
  //   });
  // }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 18,
                  decoration: task.status == '0'
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              _dateFormatter.format(task.date),
              style: TextStyle(
                  fontSize: 15,
                  decoration: task.status == '0'
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  value: task.status == '1' ? true : false,
                  onChanged: (value) {
                    task.status = value ? '1' : '0';
                    DatabaseHelper.instance.updateTask(task);
                    _updateTaskList();
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                IconButton(
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      // setState(() {
                      DatabaseHelper.instance.deleteTask(task);
                      _updateTaskList();
                      // });
                    }),
              ],
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTask(
                          task: task,
                          updateTaskList: _updateTaskList,
                        ))),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTask(
                        updateTaskList: _updateTaskList,
                      )));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<int>(
                icon: Icon(
                  Icons.more_vert,
                  size: 30,
                  color: Colors.black87,
                ),
                // itemBuilder: (BuildContext context) {
                //   List<String> choices = <String>[
                //     "Contact",
                //     "Other Apps"
                //   ];

                //   return choices.map((String choice) {
                //     return PopupMenuItem<String>(
                //       child: Text(choice),
                //       value: choice,
                //     );
                //   }).toList();
                // },
// https://www.warmodroid.xyz/tutorial/flutter/popup-menu-in-flutter/
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Contact'),
                          // SizedBox(width: 2),
                          Icon(Icons.info_outline, color: Colors.grey[600]),
                        ],
                      )),
                  PopupMenuItem(
                      value: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Other Apps'),
                          // SizedBox(width: 2),
                          Icon(Icons.mobile_screen_share,
                              color: Colors.grey[600]),
                        ],
                      )),
                ],

                onSelected: (value) {
                  if (value == 1) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => SimpleDialog(
                        // title: const Text('Dialog Title'),
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              child: Text("AG",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            title: Text(
                              'Akshay Gidwani',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "akagidwani@gmail.com",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Container(
                              height: 1,
                              // width: double.maxFinite - 10,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => _launchLinkedin(),
                                  child: FaIcon(FontAwesomeIcons.linkedinIn)),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey,
                              ),
                              InkWell(
                                  onTap: () => _launchGithub(),
                                  child: FaIcon(FontAwesomeIcons.github)),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey,
                              ),
                              InkWell(
                                  onTap: () => _launchInstagram(),
                                  child: FaIcon(FontAwesomeIcons.instagram)),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey,
                              ),
                              InkWell(
                                  onTap: () => _launchEmail(),
                                  child: FaIcon(FontAwesomeIcons.envelope)),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == '1')
                .toList()
                .length;

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Lobster'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          ' $completedTaskCount of ${snapshot.data.length} completed',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                }
                return _buildTask(snapshot.data[i - 1]);
              },
            );
          }),
    );
  }
}

const instagramUrl = "https://www.instagram.com/akagidwani/";
const linkedinUrl = "https://www.linkedin.com/in/akshay-g-581b75149/";
const githubUrl = "https://github.com/akshaygidwani404";
const emailId = "akagidwani@gmail.com";

_launchInstagram() async {
  if (await canLaunch(instagramUrl)) {
    await launch(instagramUrl);
  } else {
    throw 'Could not launch Instagram';
  }
}

_launchGithub() async {
  if (await canLaunch(githubUrl)) {
    await launch(githubUrl);
  } else {
    throw 'Could not launch Github';
  }
}

_launchLinkedin() async {
  if (await canLaunch(linkedinUrl)) {
    await launch(linkedinUrl);
  } else {
    throw 'Could not launch Linkedin';
  }
}

_launchEmail() async {
  // Android and iOS
  const uri = 'mailto:$emailId';
  // const uri = 'mailto:$emailId?subject=Greetings&body=Hello%20World';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch Email';
  }
}

/*

                      IconButton(
                        icon: Icon(Icons.info),
                        iconSize: 30,
                        onPressed: () {
                                                  },
                      ),
                      
*/
/*
void choiceAction(String choice) {
  if (choice == 'About') {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        // title: const Text('Dialog Title'),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text("AG", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            title: Text(
              'Akshay Gidwani',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "akagidwani@gmail.com",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 1,
              // width: double.maxFinite - 10,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () => _launchLinkedin(),
                  child: FaIcon(FontAwesomeIcons.linkedinIn)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchGithub(),
                  child: FaIcon(FontAwesomeIcons.github)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchInstagram(),
                  child: FaIcon(FontAwesomeIcons.instagram)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchEmail(),
                  child: FaIcon(FontAwesomeIcons.envelope)),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  } else if (choice == 'Contact') {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        // title: const Text('Dialog Title'),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text("AG", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            title: Text(
              'Akshay Gidwani',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "akagidwani@gmail.com",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              height: 1,
              // width: double.maxFinite - 10,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () => _launchLinkedin(),
                  child: FaIcon(FontAwesomeIcons.linkedinIn)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchGithub(),
                  child: FaIcon(FontAwesomeIcons.github)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchInstagram(),
                  child: FaIcon(FontAwesomeIcons.instagram)),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () => _launchEmail(),
                  child: FaIcon(FontAwesomeIcons.envelope)),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
*/
