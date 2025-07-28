import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:rent_a_car_project/Screen/Auth%20%7C%20Profile/ForgotPasswordScreen.dart';
import 'package:rent_a_car_project/Screen/Auth%20%7C%20Profile/NotificationScreen.dart';
import 'package:rent_a_car_project/globalContent.dart';

import '../../carModel/Car.dart';
import '../CarDetailScreen.dart';
import '../Onboarding/OnboardingScreen.dart';
import 'package:badges/badges.dart' as badges;

import 'AboutAppPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Profile',
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .where('isRead', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            int unreadCount = 0;
            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              unreadCount = snapshot.data!.docs.length;
            }

            return IconButton(
              icon: badges.Badge(
                showBadge: unreadCount > 0,
                badgeContent: Text(
                  '$unreadCount',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                child: Icon(Icons.notifications, color: colorScheme.onPrimary),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chat, color: colorScheme.onPrimary),
            onPressed: () {
              // Handle chat icon press if needed
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: GlobalConfig.image != null
                          ? FileImage(GlobalConfig.image!)
                          : const AssetImage("assets/avatar.jpg") as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${GlobalConfig.name}',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      GlobalConfig.email.isNotEmpty ? GlobalConfig.email : GlobalConfig.phoneNumber,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildMyCarSection(colorScheme, textTheme),
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
                              name: GlobalConfig.name,
                              email: GlobalConfig.email,
                              currentImage: GlobalConfig.image,
                            ),
                          ),
                        );

                        if (updatedData != null) {
                          setState(() {
                            GlobalConfig.name = updatedData['name'];
                            GlobalConfig.email = updatedData['email'];
                            GlobalConfig.image = updatedData['image'];
                          });
                        }
                      },
                    ),
                    ProfileOption(
                      icon: Icons.lock,
                      title: 'Forgot Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.info,
                      title: 'About App',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutAppPage()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => OnboardingScreen()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You have signed out successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<Car>> fetchMyCarsStream() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('cars')
        .where('ownerID', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return Car.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  Widget _buildMyCarSection(ColorScheme colorScheme, TextTheme textTheme) {
    return StreamBuilder<List<Car>>(
      stream: fetchMyCarsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading your ads",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        final myCars = snapshot.data ?? [];

        if (myCars.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "You haven't added any cars yet.",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Ads",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CategoriesScreen(collectionPath: 'categories/doc1/categoriesByBrand',
                        //       title: 'Cars by Brand',),
                        //   ),
                        // );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary, // Use primary color for text
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myCars.length,
                    itemBuilder: (context, index) {
                      final car = myCars[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailScreen(car: car),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          margin: EdgeInsets.only(right: index == myCars.length - 1 ? 0 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 120,
                                    height: 100,
                                    color: colorScheme.surfaceVariant,
                                    child: _buildImage(
                                      car.imageUrl.isNotEmpty ? car.imageUrl.first : '',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                car.name.isNotEmpty ? car.name : 'Unnamed Car',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 40,
          ),
        ),
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 40,
          ),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.broken_image,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 40,
        ),
      );
    }
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
  final String name;
  final String email;
  final File? currentImage;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.currentImage,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isEditingEmail = false; // Controls email field editability
  bool _isEditingPhoneNumber = false; // Controls phone number field editability

  Future<void> _updateUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    try {
      // Step 1: Reauthenticate only once based on the current method (email/phone)
      AuthCredential credential;

      if (GlobalConfig.email.isNotEmpty && GlobalConfig.email != user.email) {
        // Email reauthentication
        final currentPassword = await _promptForPassword(context);
        if (currentPassword == null || currentPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password is required to update email.')),
          );
          return;
        }

        credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Reauthenticate once
        await user.reauthenticateWithCredential(credential);

        // Step 2: Update the email if needed
        await user.updateEmail(GlobalConfig.email);
        await user.reload();
      } else if (GlobalConfig.phoneNumber.isNotEmpty && GlobalConfig.phoneNumber != user.phoneNumber) {
        // Phone reauthentication
        final verificationCompleted = (PhoneAuthCredential credential) async {
          await user.reauthenticateWithCredential(credential);
        };
        final verificationFailed = (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        };
        final codeSent = (String verificationId, int? resendToken) async {
          final smsCode = await _promptForSMSCode(context);
          if (smsCode == null || smsCode.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SMS Code is required to update phone number.')),
            );
            return;
          }

          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );

          // Reauthenticate once
          await user.reauthenticateWithCredential(credential);

          // Step 3: Update the phone number after reauthentication
          await user.updatePhoneNumber(credential);
          await user.reload();
        };

        await _auth.verifyPhoneNumber(
          phoneNumber: GlobalConfig.phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }

      // Step 4: Update Firestore document after successful reauthentication
      await _firestore.collection('users').doc(user.uid).update({
        'name': GlobalConfig.name,
        'email': GlobalConfig.email,
        'phoneNumber': GlobalConfig.phoneNumber,
        'avatarUrl': GlobalConfig.image != null
            ? base64Encode(await GlobalConfig.image!.readAsBytes())
            : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<String?> _promptForPassword(BuildContext context) async {
    String? password;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reauthenticate'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Enter your password'),
            onChanged: (value) {
              password = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog without setting password
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, password), // Close dialog and return password
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    return password;
  }

  Future<String?> _promptForSMSCode(BuildContext context) async {
    String? smsCode;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter SMS Code"),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              smsCode = value;
            },
            decoration: const InputDecoration(
              hintText: "Enter the code sent to your phone",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );

    return smsCode;
  }

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
                      backgroundImage: GlobalConfig.image == null
                          ? const AssetImage("assets/avatar.jpg")
                          : FileImage(GlobalConfig.image!) as ImageProvider,
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
                              GlobalConfig.image = File(pickedFile.path);
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

                // Name Field
                TextFormField(
                  initialValue: GlobalConfig.name,
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
                    GlobalConfig.name = value;
                  },
                ),
                const SizedBox(height: 16),

                // Display Email or Phone Number Field
                GlobalConfig.email.isNotEmpty
                    ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: GlobalConfig.email,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: const OutlineInputBorder(),
                          enabled: _isEditingEmail,
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          GlobalConfig.email = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditingEmail = !_isEditingEmail;
                        });
                      },
                      icon: Icon(
                        _isEditingEmail
                            ? Icons.lock_open
                            : Icons.lock_outline,
                        color: _isEditingEmail
                            ? theme.primaryColor
                            : theme.colorScheme.onBackground,
                      ),
                      tooltip: _isEditingEmail
                          ? "Lock Email Field"
                          : "Unlock Email Field",
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: GlobalConfig.phoneNumber,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: const OutlineInputBorder(),
                          enabled: _isEditingPhoneNumber,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^\+?[0-9]{10,15}$')
                                .hasMatch(value)) {
                              return "Please enter a valid phone number";
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          GlobalConfig.phoneNumber = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditingPhoneNumber = !_isEditingPhoneNumber;
                        });
                      },
                      icon: Icon(
                        _isEditingPhoneNumber
                            ? Icons.lock_open
                            : Icons.lock_outline,
                        color: _isEditingPhoneNumber
                            ? theme.primaryColor
                            : theme.colorScheme.onBackground,
                      ),
                      tooltip: _isEditingPhoneNumber
                          ? "Lock Phone Number Field"
                          : "Unlock Phone Number Field",
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _updateUserProfile();
                      Navigator.pop(context); // This pops the screen after saving changes
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

