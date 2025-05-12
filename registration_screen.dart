import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/registration_controller.dart';
import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegistrationController _controller = RegistrationController();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('First Name', style: TextStyle(fontSize: 16)),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'First Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your first name' : null,
              ),
              const SizedBox(height: 10),

              const Text('Last Name', style: TextStyle(fontSize: 16)),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Last Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your last name' : null,
              ),
              const SizedBox(height: 10),

              const Text('Email', style: TextStyle(fontSize: 16)),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              const Text('Password', style: TextStyle(fontSize: 16)),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 10),

              const Text('Confirm Password', style: TextStyle(fontSize: 16)),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please confirm your password';
                  if (value != password) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserModel user = UserModel(
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                      password: password,
                      confirmPassword: confirmPassword,
                    );

                    String? validationMessage = _controller.validateUser(user);
                    if (validationMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(validationMessage)),
                      );
                    } else {
                      try {
                        // تسجيل المستخدم في Firebase Auth
                        UserCredential userCredential =
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // إضافة بيانات المستخدم في Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .set({
                          'firstName': firstName,
                          'lastName': lastName,
                          'email': email,
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration successful')),
                          );

                          // الانتقال إلى صفحة تسجيل الدخول
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'Registration failed';
                        if (e.code == 'email-already-in-use') {
                          errorMessage = 'Email is already in use';
                        } else if (e.code == 'weak-password') {
                          errorMessage = 'Password is too weak';
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      }
                    }
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
