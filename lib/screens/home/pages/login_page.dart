import 'package:debook/screens/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/../database/db_helper_login.dart';
import '/../controller/session_manager.dart';
import 'register_page.dart';
import 'show_registered_user.dart';

class LoginPage extends StatefulWidget {
  static const nameRoute = '/loginpage';
  // LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final SessionManager sessionManager = SessionManager();

  void _login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    List<Map<String, dynamic>> user =
        await dbHelper.getUserByUsername(username);
    if (user.isNotEmpty &&
        user[0]['password'] == dbHelper.hashPassword(password)) {
      await _saveSession(username);
      Navigator.pushReplacementNamed(context, BottomNavBar.nameRoute);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text('Username atau Password Salah'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveSession(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _goToShowRegisteredUsersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowRegisteredUsersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 27, 109, 69),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _goToRegisterPage,
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(78, 255, 255, 85),
            ),
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: _goToShowRegisteredUsersPage,
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(78, 255, 255, 85),
            ),
            child: Text(
              'Show Users',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 27, 109, 69),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _login(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(78, 255, 255, 85),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
