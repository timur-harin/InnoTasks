import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  List<Task> tasks = []; // This list should be filled with actual data
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize your tasks here, for example by loading them from an API
  }

  // Example sort function - sorts tasks by deadline
  void sortTasks() {
    setState(() {
      tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    });
  }

  // Example function to mark a task as done
  void markTaskAsDone(int index) {
    setState(() {
      tasks[index] = tasks[index].copyWith(completed: true);
      // Here you would also want to update the task in your backend or database
    });
  }

  // Build a single task item
  Widget buildTaskItem(Task task, int index) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: sortTasks,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return buildTaskItem(tasks[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to a page to create a new task
        },
      ),
    );
  }
}