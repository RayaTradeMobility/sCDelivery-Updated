// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:RayaExpressDriver/API/API.dart';
import 'package:RayaExpressDriver/Models/TasksModel.dart';
import 'package:flutter/material.dart';

import 'MenuScreen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen(
      {super.key,
      required this.driverUsername,
      required this.dUserID,
      required this.driverID});

  final String driverUsername, dUserID;
  final int driverID;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Future<bool> _onBackPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MenuScreen(
        driverUsername: widget.driverUsername,
        dUserID: widget.dUserID,
        driverID: widget.driverID,
      );
    }));
    return Future.value(true);
  }

  API api = API();
  late Future<TasksModel> tasks;

  @override
  void initState() {
    super.initState();
    tasks = api.getTasksList(widget.driverID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<TasksModel>(
              future: tasks,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.tasksDriverVMs != null) {
                  for (var s in snapshot.data!.tasksDriverVMs!) {
                    return Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'رقم الاوردر :',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text(
                                    s.oOracleNumber!,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'AWB :',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text(
                                    s.oAWBUnique!,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasData &&
                    snapshot.data!.tasksDriverVMs == null) {
                  return const Center(child: Text("No Data to show"));
                } else if (snapshot.hasError) {
                  return Text(
                      '${snapshot.error}' "You don't have data in this time");
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
