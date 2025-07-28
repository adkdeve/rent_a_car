import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_a_car_project/globalContent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/HomeScreenContent.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;  // Add loading flag

  Future<void> _signInWithEmailPassword() async {
    GlobalConfig.email = _emailController.text.trim();
    GlobalConfig.currentPassword = _passwordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;  // Set loading to true when sign-in starts
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: GlobalConfig.email,
        password: GlobalConfig.currentPassword,
      );

      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          // Retrieve user data from Firestore
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          GlobalConfig.name = userData['name']; // Store name in GlobalConfig or use as needed

          String? avatarBase64 = userData['avatarUrl']; // Fetch base64 data from Firestore
          if (avatarBase64 != null && avatarBase64.isNotEmpty) {
            // Convert the base64 string to an image
            GlobalConfig.image = await _convertBase64ToFile(avatarBase64);
          }

          // Save data to shared preferences
          await _saveUserDataToLocalStorage(GlobalConfig.name, GlobalConfig.email, GlobalConfig.currentPassword, GlobalConfig.image);

          // Navigate to the home screen on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Prompt the user to verify their email
          await _showVerificationDialog(user);
        }
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _showError('The email address is invalid.');
          break;
        case 'user-not-found':
          _showError('No user found with this email.');
          break;
        case 'wrong-password':
          _showError('The password is incorrect.');
          break;
        default:
          _showError(e.message ?? 'An unexpected error occurred.');
      }
    } finally {
      setState(() {
        _isLoading = false;  // Set loading to false after the sign-in process
      });
    }
  }

  // Convert base64 string to a File (image)
  Future<File?> _convertBase64ToFile(String base64String) async {
    try {
      // Decode the base64 string to bytes
      final bytes = base64Decode(base64String);

      // Get the temporary directory of the device
      final directory = await Directory.systemTemp.createTemp();

      // Create a new file in the directory
      final file = File('${directory.path}/avatar.png');

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print("Error converting base64 to file: $e");
      return null;
    }
  }

  // Save user data to shared preferences
  Future<void> _saveUserDataToLocalStorage(String name, String email, String currentPassword, File? avatar) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('currentPassword', currentPassword);

    if (avatar != null) {
      // Save the avatar file path or use the base64 string
      prefs.setString('avatarPath', avatar.path);
    }
  }

  Future<void> _showVerificationDialog(User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verify Your Email'),
          content: const Text(
            'Your email is not verified. Please check your inbox for a verification link. If you didn’t receive the email, click "Resend".',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await user.sendEmailVerification();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification email sent.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send verification email: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Resend'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  // Title Section
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to continue',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Form Section
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, color: theme.primaryColor),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password should be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        _signInWithEmailPassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Forgot Password Option
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Divider with "OR"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: theme.dividerColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: theme.colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: theme.dividerColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Sign Up Option
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Don’t have an account? Sign up",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black54, // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
