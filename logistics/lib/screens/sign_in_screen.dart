import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/regexpressions.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? errorMsg;
  bool isRememberMeChecked = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFE0E0E0), // Light grey background similar to the image
      appBar: AppBar(
        backgroundColor: Color(0xFF0F0156), // Dark blue app bar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF9500)),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "lib/images/logo.jpeg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome Back',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      endIndent: 10,
                    ),
                  ),
                  Text(
                    'OR LOGIN WITH EMAIL',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      endIndent: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyTextField(
                controller:  emailController,
                hintText:'  Email Address',
                labelText:' Email Address',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon:
                    Icon(CupertinoIcons.mail_solid, color: Color(0xFF0F0156)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: passwordController,
                hintText: ' Password',
                labelText: ' Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                prefixIcon: Icon(CupertinoIcons.lock, color: Color(0xFF0F0156)),
                suffixIcon: IconButton(
                    color: Color(0xFF0F0156),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (!passWordRegExp.hasMatch(value)) {
                    return 'Password enter a valid password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMeChecked,
                      activeColor: Color(0xFF0F0156),
                      checkColor: Colors.white,
                      side: BorderSide(color: Colors.orange),
                      onChanged: (bool? value) {
                        setState(() {
                          isRememberMeChecked = value ?? false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Keep me Logged In',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ]),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0F0156), // Dark blue button
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Sign In', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
