import 'package:flutter/material.dart';
import '../../globalContent.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your current password";
                    }
                    //Optionally: You can check if the entered current password matches the stored password
                    if (value != GlobalConfig.currentPassword) {
                      return "Current password is incorrect";
                    }
                    return null; // No error if provided
                  },
                  onChanged: (value) {
                  },
                ),
                const SizedBox(height: 16),

                // New Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    // Check if the current password field is empty
                    if (GlobalConfig.currentPassword.isEmpty) {
                      return "Please enter your current password first";
                    }

                    // Validate the new password
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    GlobalConfig.newPassword = value; // Store the new password value
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value != GlobalConfig.newPassword) {
                        return "Passwords do not match";
                      }
                    }
                    return null; // No error if empty
                  },
                ),
                const SizedBox(height: 16),

                // Change Password Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password Changed Successfully!')),
                      );
                      GlobalConfig.currentPassword = GlobalConfig.newPassword;
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Change Password", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
