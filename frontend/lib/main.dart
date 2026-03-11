import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'storage/token_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<Widget> checkLogin() async {
    String? token = await TokenStorage.getToken();

    if (token != null) {
      return HomePage();
    }

    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Auth",
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}