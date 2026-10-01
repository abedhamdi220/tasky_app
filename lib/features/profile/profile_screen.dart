import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/features/profile/user_details_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';
import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/custom_svg_picture.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  late String motivationQuote;
  bool isLoading = true;
  String? userImagePath;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      userName = PreferencesManager().getString(StorageKey.username) ?? "Usama Elgendy";
      motivationQuote =
          PreferencesManager().getString(StorageKey.motivationQuote) ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString(StorageKey.userImagePath);

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.white))
        : Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'My Profile',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundImage: userImagePath == null
                                  ? AssetImage(
                                      "assets/images/c2c02c46fb3953f5c181fc6958c9be600a55b220.png",
                                    )
                                  : FileImage(File(userImagePath!)),
                              radius: 60,
                              backgroundColor: Colors.transparent,
                            ),
                            GestureDetector(
                              onTap: () async {
                                showImageSourceDialog(context,(XFile file){
                                  setState(() {
                                    _saveImage(file);
                                    userImagePath=file.path;
                                  });
                                });
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                                child: Icon(Icons.camera_alt, size: 26),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          motivationQuote,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Profile Info',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    onTap: () async {
                      final bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return UserDetailsScreen(
                              userName: userName,
                              motivationQuote: motivationQuote,
                            );
                          },
                        ),
                      );
                      if (result != null && result) _loadUserData();
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text('User Details'),
                    leading: CustomSvgPicture(
                      path: 'assets/images/profile.svg',
                    ),
                    trailing: Icon(Icons.arrow_forward, size: 24),
                  ),
                  Divider(),
                  SizedBox(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Dark Mode'),
                    leading: Icon(Icons.bedtime, size: 24),
                    trailing: ValueListenableBuilder(
                      valueListenable: ThemeController.themeNotifier,
                      builder: (context, value, child) {
                        return Switch(
                          value: value == ThemeMode.dark,
                          onChanged: (bool value) {
                            setState(() {
                              ThemeController.toggleTheme();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 24),
                  ListTile(
                    onTap: () async {
                      PreferencesManager().remove(StorageKey.username);
                      PreferencesManager().remove(StorageKey.motivationQuote);
                      PreferencesManager().remove(StorageKey.tasks);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return WelcomeScreen();
                          },
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text('Log Out'),
                    leading: Icon(Icons.logout),
                    trailing: Icon(Icons.arrow_forward, size: 24),
                  ),
                ],
              ),
            ),
          );
  }
//
  void showImageSourceDialog(
    BuildContext context,
    Function(XFile) selectedImage,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Choose Image Source",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if(image != null){
                  selectedImage(image);
                }

              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text("Camera"),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if(image != null){
                  selectedImage(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.photo_library_outlined),
                  SizedBox(width: 8),
                  Text("Gallery"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveImage(XFile file) async{
    await  PreferencesManager().setString(StorageKey.userImagePath, file.path);
  }
}
