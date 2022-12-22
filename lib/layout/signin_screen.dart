// ignore_for_file: camel_case_types, avoid_print, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/layout/login_screen.dart';
import 'package:firebase_test/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class SignIn_Screen extends StatefulWidget {
  const SignIn_Screen({super.key});

  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {


  UserCredential? userCredential;
  bool isPassword = true;
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  var formState = GlobalKey<FormState>();
  register() async {
    var validation = formState.currentState;
    if (validation!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Toast.show("Weak Password",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        } else if (e.code == 'email-already-in-use') {
          Toast.show("Email already in use",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formState,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Lottie.asset('assets/json/signup.json',
                    width: 250, height: 250),
                const SizedBox(
                  height: 25.0,
                ),
                defaultFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  text: "Username",
                  type: TextInputType.name,
                  perfix: Icons.person,
                  controller: usernameController,
                ),
                const SizedBox(
                  height: 25,
                ),
                defaultFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  text: "Email",
                  type: TextInputType.emailAddress,
                  perfix: Icons.email,
                  controller: emailController,
                ),
                const SizedBox(
                  height: 25,
                ),
                defaultFormField(
                  text: "Password",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  type: TextInputType.visiblePassword,
                  perfix: Icons.lock,
                  controller: passwordController,
                  suffix: isPassword ? Icons.visibility : Icons.visibility_off,
                  isPassword: isPassword,
                  suffixButton: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                defaultButton(
                    text: 'Sign Up',
                    onpressed: () async {
                      UserCredential response = await register();
                      if (response != null) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'Home-Screen', (route) => false);
                      }
                    }),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'Login-Screen');
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
