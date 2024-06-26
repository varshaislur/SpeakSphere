import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speak_sphere/backend_services/auth_services.dart';
import 'package:speak_sphere/backend_services/database_services.dart';
import 'package:speak_sphere/screens/homepage.dart';
import 'package:speak_sphere/screens/signup_page.dart';
import 'package:speak_sphere/widgets/helper_widgets.dart';

import '../backend_services/helper_functions.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthServices authService = AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
  bool _isLoading = false;
  void handlelogin() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.loginWithUserNameandPassword(emailController.text.toString(),passwordController.text.toString()).then((value) async {
        if (value==true){
          QuerySnapshot snapshot =
              await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(emailController.text.toString());
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailController.text.toString());
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          print(HelperFunctions.getUserNameFromSF());
          setState(() {
            _isLoading=false;
          });

          nextScreenReplace(context, HomePage());
          setState(() {
            _isLoading=false;
          });

        }else {
          showSnackbar(context,Colors.orange,value);
          setState(() {
            _isLoading=false;
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
                      child: Image.asset("assets/images/login_update.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        handlelogin();
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
                              "Sign In",
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
                              "Don't have an account?",
                              style: TextStyle(fontSize: 18),
                            ),
                            GestureDetector(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                nextScreenReplace(context, SignUpPage());
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


