import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/auth/MainPage.dart';
import 'package:instagram/data/firebase_service/auth.dart';
import 'package:instagram/data/firebase_service/dialogue.dart';
import 'package:instagram/data/firebase_service/util.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  FocusNode email_F = FocusNode();
  FocusNode password_F = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: 96.w, height: 100.h),
              Center(
                child: Image.asset('images/logo.jpg'),
              ),
              SizedBox(
                height: 120.h,
              ),
              TextFields(email, Icons.email, 'Email', email_F),
              SizedBox(
                height: 15.h,
              ),
              TextFields(password, Icons.lock, 'Password', password_F,
                  obscureText: true),
              SizedBox(
                height: 10.h,
              ),
              Forgot(),
              SizedBox(
                height: 10.h,
              ),
              login(),
              SizedBox(
                height: 10.h,
              ),
              Have()
            ],
          ),
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have account?",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          GestureDetector(
              onTap: widget.show,
              child: Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ))
        ],
      ),
    );
  }

  Padding Forgot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        'Forget your password',
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget login() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication()
                .Login(email: email.text, password: password.text);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          } on exceptions catch (e) {
            dialogueBuilder(context, e.messages);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'login',
            style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget TextFields(TextEditingController controller, IconData icon,
      String type, FocusNode focusNode,
      {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: TextField(
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: type,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            )),
      ),
    );
  }
}
