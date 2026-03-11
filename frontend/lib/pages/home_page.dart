import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../storage/token_storage.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String name = "";
  String email = "";

  void loadProfile() async {

    String? token = await TokenStorage.getToken();

    if (token == null) return;

    final data = await ApiService.profile(token);

    if (data != null) {
      setState(() {
        name = data["name"];
        email = data["email"];
      });
    }
  }

  void logout() async {

    await TokenStorage.deleteToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Name: $name"),
            Text("Email: $email"),

          ],
        ),
      ),
    );
  }
}