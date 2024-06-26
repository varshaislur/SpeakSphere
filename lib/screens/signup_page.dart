import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speak_sphere/backend_services/auth_services.dart';
import 'package:speak_sphere/screens/login_page.dart';
import 'package:speak_sphere/screens/signup_page.dart';
import 'package:speak_sphere/widgets/helper_widgets.dart';

import '../backend_services/helper_functions.dart';
import '../widgets/custom_text_field.dart';
import 'homepage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool _isLoading=false;
  AuthServices authServices=AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();


  // final AuthServices authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();

  // void ErrorMessage(String errormessage) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(errormessage),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .registerUserWithEmailandPassword(fullnameController.text.toString(), emailController.text.toString(), passwordController.text.toString())
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailController.text.toString());
          await HelperFunctions.saveUserNameSF(fullnameController.text.toString());
          print(HelperFunctions.getUserNameFromSF());
          setState(() {
            _isLoading=false;
          });
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary),
        )
            : Container(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:50),
                        child: Image.asset("assets/images/register_update.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomTextField(
                        icon: Icons.person,
                        controller: fullnameController,
                        isObscure: false,
                        name: "full name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your fullname';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        controller: emailController,
                        isObscure: false,
                        name: "email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        icon: Icons.lock,
                        controller: passwordController,
                        isObscure: true,
                        name: "password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          handleRegister();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // authServices.signInWithGoogle(context: context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              // Image(
                              //   image: AssetImage("assets/images/google_logo.jpg"),
                              //   height: 18.0,
                              //   width: 24,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 24, right: 8),
                                child: Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(fontSize: 18),
                              ),
                              GestureDetector(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color:Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  nextScreenReplace(context, LoginPage());
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
