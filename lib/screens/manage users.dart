import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String gender;

  User({required this.id, required this.name, required this.email, required this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<User> users = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("http://10.0.2.2/flutter_api/get_users.php"));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        users = data.map((u) => User.fromJson(u)).toList();
      });
    } else {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load users')));
    }
  }

  Future<void> addUser(String name, String email, String gender) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/flutter_api/add_user.php"),
      body: json.encode({"name": name, "email": email, "gender": gender}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user')));
    }
  }

  Future<void> updateUser(int id, String name, String email, String gender) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/flutter_api/update_user.php"),
      body: json.encode({"id": id, "name": name, "email": email, "gender": gender}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user')));
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/flutter_api/delete_user.php"),
      body: json.encode({"id": id}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void showUserDialog({User? user}) {
    final nameCtrl = TextEditingController(text: user?.name);
    final emailCtrl = TextEditingController(text: user?.email);
    String gender = user?.gender ?? 'F';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Add User' : 'Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            DropdownButton<String>(
              value: gender,
              items: [
                DropdownMenuItem(value: 'F', child: Row(children: [Icon(Icons.female, color: Colors.pink), SizedBox(width: 6), Text('Female')])),
                DropdownMenuItem(value: 'M', child: Row(children: [Icon(Icons.male, color: Colors.blue), SizedBox(width: 6), Text('Male')])),
              ],
              onChanged: (val) => setState(() => gender = val ?? 'F'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              user == null
                  ? addUser(nameCtrl.text, emailCtrl.text, gender)
                  : updateUser(user.id, nameCtrl.text, emailCtrl.text, gender);
              Navigator.pop(context);
            },
            child: Text(user == null ? 'Add' : 'Update'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((u) =>
        u.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();

    final girlCount = users.where((u) => u.gender == 'F').length;
    final boyCount = users.where((u) => u.gender == 'M').length;
    final total = girlCount + boyCount;
    final girlPercent = total == 0 ? 0.0 : girlCount / total;
    final boyPercent = total == 0 ? 0.0 : boyCount / total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => showUserDialog()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 10.0,
                  percent: girlPercent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.female, color: Colors.pink, size: 30),
                      Text("${(girlPercent * 100).toStringAsFixed(1)}%"),
                    ],
                  ),
                  progressColor: Colors.pink,
                  backgroundColor: Colors.pink.shade100,
                  animation: true,
                ),
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 10.0,
                  percent: boyPercent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.male, color: Colors.blue, size: 30),
                      Text("${(boyPercent * 100).toStringAsFixed(1)}%"),
                    ],
                  ),
                  progressColor: Colors.blue,
                  backgroundColor: Colors.blue.shade100,
                  animation: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(
                      user.gender == 'F' ? Icons.female : Icons.male,
                      color: user.gender == 'F' ? Colors.pink : Colors.blue,
                    ),
                    title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${user.email} - ${user.gender == 'F' ? 'Female' : 'Male'}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteUser(user.id),
                    ),
                    onTap: () => showUserDialog(user: user),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
