import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/layout/home_screen.dart';
import 'package:firebase_test/layout/login_screen.dart';
import 'package:firebase_test/layout/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

bool? isLogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App With Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin == false ? 'Login-Screen' : 'Home-Screen',
      routes: {
        'Login-Screen': (context) => const Login_Screen(),
        'Sign-In': (context) => const SignIn_Screen(),
        'Home-Screen': (context) => const Home_Screen(),
      },
    );
  }
}
