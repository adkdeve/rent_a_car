import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:rent_a_car_project/globalContent.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const  Center(child: Text('Profile', style: TextStyle(color: Colors.white),)),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header with avatar and name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: image != null
                          ? FileImage(image!)
                          : const AssetImage("assets/avatar.jpg"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$fName $lName', // Display full name
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email, // Display email
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Profile options and actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProfileOption(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: () async {
                        final updatedData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              firstName: fName,
                              lastName: lName,
                              email: email,
                              currentImage: image,
                            ),
                          ),
                        );

                        // Update state with new data if available
                        if (updatedData != null) {
                          setState(() {
                            fName = updatedData['firstName'];
                            lName = updatedData['lastName'];
                            email = updatedData['email'];
                            image = updatedData['image'];
                          });
                        }
                      },
                    ),
                    ProfileOption(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        // Navigate to Change Password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.settings,
                      title: 'Account Settings',
                      onTap: () {
                        // Navigate to Account Settings screen
                      },
                    ),
                    ProfileOption(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        // Navigate to Notifications settings
                      },
                    ),
                    ProfileOption(
                      icon: Icons.info,
                      title: 'About App',
                      onTap: () {
                        // Show About App information
                      },
                    ),
                    ProfileOption(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () {
                        // Handle sign-out
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Retrieve the current theme

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor), // Primary color icon
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final File? currentImage;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.currentImage,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Edit Profile",style: TextStyle(color: Colors.white)
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share,color: Colors.white),
            onPressed: () {
              // Implement share functionality here
            },
          ),
        ],
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with a blurred background effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: image == null
                          ? const AssetImage("assets/avatar.jpg")
                          : FileImage(image!) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image from the gallery
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                          if (pickedFile != null) {
                            setState(() {
                              image = File(pickedFile.path);
                            });
                          } else {
                            print('No image selected.');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // First Name Field
                TextFormField(
                  initialValue: fName,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    fName = value;
                  },
                ),
                const SizedBox(height: 16),

                // Last Name Field
                TextFormField(
                  initialValue: lName,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    lName = value;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // Adjusted validation to handle empty and format
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number Field
                TextFormField(
                  initialValue: phoneNumber,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                        return "Please enter a valid phone number";
                      }
                    }
                    return null; // No error if empty
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save changes: Only save fields that are not empty
                      if (fName.isNotEmpty || lName.isNotEmpty || email.isNotEmpty || phoneNumber.isNotEmpty || nPassword.isNotEmpty) {
                        // Implement save functionality
                        // Here you can send updated data to your backend or local storage
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Updated!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No changes detected.')),
                        );
                      }
                    }
                    if (_formKey.currentState!.validate()) {
                      // Return updated data
                      Navigator.pop(context, {
                        'firstName': fName,
                        'lastName': lName,
                        'email': email,
                        'image': image,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
                    if (value != currentPassword) {
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
                    if (currentPassword.isEmpty) {
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
                    nPassword = value; // Store the new password value
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
                      if (value != nPassword) {
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
                      currentPassword = nPassword;
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