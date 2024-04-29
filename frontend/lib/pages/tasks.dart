import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/network.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  List<Task> tasks = []; // This list should be filled with actual data
  bool isLoading = false;
  final network = NetworkService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
    isLoading = true;
    network.fetchTasks().then((result) {
      setState(() {
        tasks = result;
        isLoading = false;
      });
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
  void sortTasks() {
    // setState(() {
    //   tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    // });
  }

  // Example function to mark a task as done
  void markTaskAsDone(int index) {}

  // Build a single task item
  Widget buildTaskItem(Task task, int index) {
    return Dismissible(
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
        title: Text(task.title),
        subtitle: Text(task.description ?? ''),
        trailing: IconButton(
          icon: Icon(Icons.check_circle,
              color: task.completed ? Colors.green : Colors.grey),
          onPressed: () {
            markTaskAsDone(index);
          },
        ),
        onTap: () {
          // Navigate to an edit page or show a dialog to edit the task
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: sortTasks,
          ),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                network.logoutUser();
                Navigator.pushReplacementNamed(context, '/login');
              })
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return buildTaskItem(tasks[index], index);
              },
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
                        onPressed: () => _selectDate(context),
                        child: Text(_selectedDate == null
                            ? 'Pick a deadline date'
                            : 'Deadline: ${_selectedDate!.toLocal()}'
                                .split(' ')[0]), // Format the date as you need
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_submitForm()) {
                            await network.createTask(_titleController.text,
                                _descriptionController.text, _selectedDate!);
                            await _updateTasks();
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
}
