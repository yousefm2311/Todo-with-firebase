// ignore_for_file: camel_case_types, unused_local_variable, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  getData() async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
    await userRef.get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        print("------------------------------");
      });
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPassword = true;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  var formState = GlobalKey<FormState>();
  login() async {
    var validation = formState.currentState;
    if (validation!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Toast.show("No user found for that email.",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        } else if (e.code == 'wrong-password') {
          Toast.show("Wrong password provided for that user.",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        }
      }
    }
  }

  var user = FirebaseAuth.instance.currentUser;
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
          child: Form(
            key: formState,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Lottie.asset(
                  'assets/json/register.json',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(
                  height: 25,
                ),
                defaultFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your email';
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
                      return 'please enter your password';
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
                ConditionalBuilder(
                    condition: true,
                    builder: (context) => defaultButton(
                        text: 'Login',
                        onpressed: () async {
                          UserCredential? response = await login();
                          print('---------------------------');
                          if (response != null) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'Home-Screen', (route) => false);
                          }
                        }),
                    fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        )),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InkWell(
                    onTap: () async {
                      UserCredential google = await signInWithGoogle();
                      print(google.user);
                      if (google != null) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'Home-Screen', (route) => false);
                      } else {
                        print('false');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.black54, width: 1.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/json/google.json',
                            width: 50,
                            height: 50,
                          ),
                          const Text(
                            'Sign In with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'Sign-In');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
