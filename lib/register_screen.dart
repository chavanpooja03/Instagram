import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/auth.dart';
import 'package:instagram/data/firebase_service/dialogue.dart';
import 'package:instagram/data/firebase_service/util.dart';
import 'package:instagram/auth/MainPage.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback show;
  const SignUpScreen(this.show, {Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final bio = TextEditingController();
  final confirmPassword = TextEditingController();

  FocusNode email_F = FocusNode();
  FocusNode password_F = FocusNode();
  FocusNode username_F = FocusNode();
  FocusNode bio_F = FocusNode();
  FocusNode confirmpassword_F = FocusNode();

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
                height: 10.h,
              ),
              Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: Container(
                      color: Colors.grey,
                      child: Image.asset('images/person.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextFields(email, Icons.email, 'Email', email_F),
              SizedBox(
                height: 15.h,
              ),
              TextFields(username, Icons.person, 'username', username_F),
              SizedBox(
                height: 10.h,
              ),
              TextFields(bio, Icons.abc, 'Bio', bio_F),
              SizedBox(
                height: 10.h,
              ),
              TextFields(password, Icons.lock, 'Password', password_F),
              SizedBox(
                height: 10.h,
              ),
              TextFields(confirmPassword, Icons.lock, 'Confirm Password',
                  confirmpassword_F),
              SignUp(),
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
                'Login',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ))
        ],
      ),
    );
  }

  Widget SignUp() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().SignUp(
              email: email.text,
              password: password.text,
              Confirmpassword: password.text,
              username: username.text,
              bio: bio.text,
            );
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
            'SignUp',
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
      String type, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: TextField(
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
        controller: controller,
        focusNode: focusNode,
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
