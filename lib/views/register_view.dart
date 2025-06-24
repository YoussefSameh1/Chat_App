// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snackbar.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static String id = 'register_view';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                    'Sign Up',
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
                text: 'Sign Up',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    setState(() {});
                    try {
                      UserCredential user = await registerUser();
                      if (user.user != null) {
                        showSnackbar(context, 'Account created successfully!');
                        Navigator.pushNamed(context, ChatView.id);
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = 'An error occurred';

                      if (e.code == 'weak-password') {
                        errorMessage = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        errorMessage =
                            'An account already exists for that email.';
                      } else if (e.code == 'invalid-email') {
                        errorMessage = 'Please enter a valid email address.';
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
                    'Already have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
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

  Future<UserCredential> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    return user;
  }
}
