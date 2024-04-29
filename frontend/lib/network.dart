import 'dart:convert';
import 'package:frontend/models/notification.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  final String baseUrl = 'http://localhost:8000';

  Future<User> registerUser(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/users/auth?email=$email&password=$password'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var user = User.fromJson(jsonDecode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', '${user.id}_${user.token}');
      prefs.setString('email', email);
      return user;
    } else {
      throw Exception(response.body);
    }
  }

  Future<User> loginUser(String email, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/users/login?email=$email&password=$password'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var user = User.fromJson(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', '${user.id}_${user.token}');
      prefs.setString('email', email);

      return user;
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
  }

  Future<List<Task>> fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('$baseUrl/tasks/${prefs.getString('token')}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final tasks = (List<Task>.from(
          jsonDecode(response.body).map((x) => Task.fromJson(x))));
      return tasks;
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> createTask(
      String title, String description, DateTime deadline) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(
          '$baseUrl/tasks/${prefs.getString('token')}?title=$title&description=$description&deadline=${deadline.toIso8601String()}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Task created successfully');
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> deleteTask(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id/${prefs.getString('token')}'),
    );

    if (response.statusCode == 200) {
      print('Task deleted successfully');
    } else {
      throw Exception(response.body);
    }
  }

  Future<Task> getTask(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('$baseUrl/tasks/$id/${prefs.getString('token')}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final task = Task.fromJson(jsonDecode(response.body));
      return task;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Task> updateTask(int id, String title, String description,
      DateTime deadline, bool completed) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id/${prefs.getString('token')}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final task = Task.fromJson(jsonDecode(response.body));
      return task;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Notification>> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('$baseUrl/notifications/${prefs.getString('token')}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final notifications = (jsonDecode(response.body) as List<Notification>);
      return notifications;
    } else {
      throw Exception(response.body);
    }
  }
}
