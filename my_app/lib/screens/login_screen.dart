import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/agent_home_screen.dart';
import 'package:my_app/screens/sales_home_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? passwordController;
  TextEditingController? emailController;
  String selectedField = 'Salesperson';
  List<String> fields = ['Salesperson', 'Agent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedField,
                onChanged: (newValue) {
                  setState(() {
                    selectedField = newValue!;
                  });
                },
                items: fields.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: () async {
                  await login;
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      ' SignUp',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController!.text, password: passwordController!.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        selectedField == 'Salesperson'
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SalesHomeScreen(),
                ),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AgentHomeScreen(),
                ),
              );
      }
    }
  }
}
