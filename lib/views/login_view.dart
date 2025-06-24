// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snackbar.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/register_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String id = 'login_view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? email, password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Spacer(flex: 2),
              Image.asset(kLogo),
              Text(
                'Scholar Chat',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'pacifico',
                ),
              ),
              Spacer(flex: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              CustomTextField(
                hintText: 'Email',
                onChanged: (value) {
                  email = value;
                },
              ),
              CustomTextField(
                hintText: 'Password',
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              Spacer(),
              CustomButton(
                text: 'Sign In',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    setState(() {});
                    try {
                      UserCredential user = await loginUser();
                      if (user.user != null) {
                        showSnackbar(context, 'Login successful');
                        Navigator.pushNamed(
                          context,
                          ChatView.id,
                          arguments: email,
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = 'An error occurred';
                      if (e.code == 'user-not-found') {
                        errorMessage = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        errorMessage = 'Wrong password.';
                      }
                      showSnackbar(context, errorMessage);
                    }
                    isLoading = false;
                    setState(() {});
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterView.id);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xffC9E8E7)),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    return user;
  }
}
