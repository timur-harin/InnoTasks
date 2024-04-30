import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/scheduler.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/network.dart';
import 'package:frontend/models/notification.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];
  List<Notification> notifications = [];
  bool isLoading = false;
  bool sortAscending = true;
  final network = NetworkService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tasks = [];
    notifications = [];
    isLoading = true;
    network.fetchNotifications().then((result) {
      setState(() {
        notifications = result;
      });
    });
    network.fetchTasks().then((result) {
      setState(() {
        tasks = result;
        isLoading = false;
      });
    });
  }

  void showNotification() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();

      if (notifications.isNotEmpty) {
        for (var notification in notifications) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${notification.task_id} - ${notification.message}'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    });
  }

  Future<void> _updateTasks() async {
    setState(() {
      isLoading = true;
    });
    tasks = await network.fetchTasks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  bool _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Sending Data'), duration: Duration(seconds: 1)),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid Data'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  // Example sort function - sorts tasks by deadline
  List<Task> sortTasks(List<Task> tasks) {
    sortAscending = !sortAscending;
    if (sortAscending) {
      tasks.sort((a, b) {
        if (a.deadline == null || b.deadline == null) {
          return 0;
        } else {
          return a.deadline!.compareTo(b.deadline!);
        }
      });
    } else {
      tasks.sort((a, b) {
        if (a.deadline == null || b.deadline == null) {
          return 0;
        } else {
          return b.deadline!.compareTo(a.deadline!);
        }
      });
    }
    return tasks;
  }

  Widget buildTaskItem(Task task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Dismissible(
        key: ValueKey(index),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) async {
          if (task.id != null) {
            await network.deleteTask(task.id!);
          }
        },
        child: ListTile(
          title: Text(task.title,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
              )),
          subtitle: Text(task.description != null ? task.description! : '-'),
          trailing: Text(
            task.deadline != null
                ? (task.deadline!.isAfter(DateTime.now())
                    ? (task.deadline!.difference(DateTime.now()).inDays.abs() ==
                            0
                        ? 'Today'
                        : (task.deadline!
                                    .difference(DateTime.now())
                                    .inDays
                                    .abs() ==
                                1
                            ? 'Tomorrow'
                            : '${task.deadline!.difference(DateTime.now()).inDays} days left '))
                    : (task.deadline!.difference(DateTime.now()).inDays.abs() ==
                            0
                        ? 'Today'
                        : '${task.deadline!.difference(DateTime.now()).inDays.abs()} days ago'))
                : 'No deadline',
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
              color: task.deadline != null
                  ? (task.deadline!.isAfter(DateTime.now())
                      ? (task.deadline!
                                  .difference(DateTime.now())
                                  .inDays
                                  .abs() ==
                              0
                          ? Colors.red
                          : (task.deadline!
                                      .difference(DateTime.now())
                                      .inDays
                                      .abs() ==
                                  1
                              ? Colors.red
                              : Colors.grey))
                      : ((task.deadline!
                                  .difference(DateTime.now())
                                  .inDays
                                  .abs() ==
                              0
                          ? Colors.red
                          : Colors.red)))
                  : Colors.grey,
            ),
          ),
          onTap: () {
            _descriptionController =
                TextEditingController(text: task.description);
            _titleController = TextEditingController(text: task.title);
            _selectedDate = task.deadline;
            bool completed = task.completed;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter task title',
                            fillColor: Colors.grey.shade900,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(36.0),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: _titleController,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter task description',
                            fillColor: Colors.grey.shade900,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(36.0),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade900,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _selectDate(context),
                          child: Text(_selectedDate == null
                              ? 'Pick a deadline date'
                              : 'Deadline: ${_selectedDate!.toLocal()}'
                                  .split(' ')[1]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text('Mark as done: '),
                            Checkbox(
                                value: completed,
                                onChanged: (value) {
                                  setState(() {
                                    completed = value!;
                                  });
                                }),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_submitForm()) {
                              await network.updateTask(
                                task.id!,
                                _titleController.text,
                                _descriptionController.text,
                                _selectedDate,
                                completed,
                              );
                              await _updateTasks();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                          ),
                          child: const Text(
                            'Update Task',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: InkWell(
            child: Icon(
              task.completed ? Icons.check_box : Icons.check_box_outline_blank,
              color: const Color.fromRGBO(95, 82, 238, 1),
            ),
            onTap: () async {
              task = task.copyWith(completed: !task.completed);
              await network.markTaskAsDone(task);
              _updateTasks();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    showNotification();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 239, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _updateTasks;
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.black,
                size: 30,
              ),
            ),
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'logout') {
                  network.logoutUser();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  searchBox(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      InkWell(
                          child: const Icon(Icons.sort),
                          onTap: () {
                            setState(() {
                              tasks = sortTasks(tasks);
                            });
                          })
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return buildTaskItem(tasks[index], index);
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        controller: _titleController,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter task description',
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _selectDate(context),
                        child: Text(_selectedDate == null
                            ? 'Pick a deadline date'
                            : 'Deadline: ${_selectedDate!.toLocal()}'
                                .split(' ')[0]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_submitForm()) {
                            await network.createTask(_titleController.text,
                                _descriptionController.text, _selectedDate!);
                            await _updateTasks();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                        ),
                        child: const Text(
                          'Create Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) async {
    List<Task> results = [];
    if (enteredKeyword.isEmpty) {
      results = await network.fetchTasks();
    } else {
      results = tasks
          .where((item) =>
              item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      tasks = results;
    });
  }
}
