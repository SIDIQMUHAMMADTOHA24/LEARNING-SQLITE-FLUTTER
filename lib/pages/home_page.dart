import 'package:crud_sqlite/models/task_model.dart';
import 'package:crud_sqlite/services/database_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataBaseService _dataBaseService = DataBaseService.instance;

  String? _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _taskList(),
      floatingActionButton: _addTaskButton(),
    );
  }

  //MARK: ADD TASK
  Widget _addTaskButton() {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("ADD TASK"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _task = value;
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_task == null || _task == '') return;
                          _dataBaseService.addTask(_task!);

                          setState(() {
                            _task = null;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text("Done"))
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add));
  }

  //MARK: GET TASK
  Widget _taskList() {
    return FutureBuilder(
      future: _dataBaseService.getTask(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            TaskModel data = snapshot.data![index];

            return ListTile(
              onLongPress: () {
                setState(() {
                  //MARK: DELETE TASK
                  _dataBaseService.deleteTask(data.id);
                });
              },
              title: Text('id: ${data.id}'),
              subtitle: Text('content: ${data.content}'),
              trailing: Checkbox(
                value: data.status == 1,
                onChanged: (value) {
                  setState(() {
                    //MARK: UPDATE TASK
                    _dataBaseService.updateTaskStatus(
                        data.id, value == true ? 1 : 0);
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
