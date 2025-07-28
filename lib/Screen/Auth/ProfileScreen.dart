import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:rent_a_car_project/globalContent.dart';
import '../../carModel/Car.dart';
import '../Onboarding/OnboardingScreen.dart';
import 'package:badges/badges.dart' as badges;
import '../car/CarDetailScreen.dart';
import '../chat/ChatList.dart';
import 'AboutAppPage.dart';
import 'ForgotPasswordScreen.dart';
import 'NotificationScreen.dart';

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
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Profile', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        // Notification icon on the top-left
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .where('isRead', isEqualTo: false)  // Filter for unread notifications
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
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
              onPressed: () {
                // Navigate to NotificationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            );
          },
        ),
        // Chat icon on the top-right
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              // Handle chat icon press if needed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen(currentUserId: '03rbxFTW8MNBSvGUlpigSJQ2Oxp1',)),
              );
            },
          ),
        ],
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
                      backgroundImage: GlobalConfig.image != null
                          ? FileImage(GlobalConfig.image!)
                          : const AssetImage("assets/avatar.jpg"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${GlobalConfig.name}', // Display full name
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      GlobalConfig.email.isNotEmpty ? GlobalConfig.email : GlobalConfig.phoneNumber, // Display email if not empty, else phoneNumber
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildmyCarSection(themeColor),
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
                              name: GlobalConfig.name,
                              email: GlobalConfig.email,
                              currentImage: GlobalConfig.image,
                            ),
                          ),
                        );

                        // Update state with new data if available
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
                        // Navigate to Change Password screen
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
                          // Sign out the user from Firebase Auth
                          await FirebaseAuth.instance.signOut();

                          // Navigate to the Onboarding Screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => OnboardingScreen()),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You have signed out successfully!')),
                          );
                        } catch (e) {
                          // Handle error during sign out
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
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID
    return FirebaseFirestore.instance
        .collection('cars')
        .where('ownerID', isEqualTo: userId) // Ensure 'ownerId' exists in Firestore
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return Car.fromFirestore(data, doc.id); // Ensure Car.fromFirestore is implemented correctly
      }).toList();
    });
  }

  Widget _buildmyCarSection(Color themeColor) {
    return StreamBuilder<List<Car>>(
      stream: fetchMyCarsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading your ads",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView( // Added this
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Ads",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'More' button click
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                      ),
                      child: const Text(
                        'More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myCars.length,
                    itemBuilder: (context, index) {
                      final car = myCars[index];
                      return GestureDetector( // Wrap each car card with GestureDetector
                        onTap: () {
                          // Navigate to the CarDetailScreen on tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailScreen(car: car),
                            ),
                          );
                        },
                        child: Container(
                          width: 120, // Fixed width for each car card
                          margin: EdgeInsets.only(right: index == myCars.length - 1 ? 0 : 16), // No margin for the last item
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
                                    color: Colors.grey[200], // Placeholder background
                                    child: _buildImage(
                                      car.imageUrl.isNotEmpty ? car.imageUrl.first : '',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                car.name.isNotEmpty ? car.name : 'Unnamed Car',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
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
              color: Colors.green, // Use theme color
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
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

