import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import '../../core/services/preferences_manager.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({
    super.key,
    required this.userName,
    required this.motivationQuote,
  });

  final String userName;
  final String? motivationQuote;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final TextEditingController userNameController;
  late final TextEditingController motivationQuoteController;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    userNameController = TextEditingController(text: widget.userName);
    motivationQuoteController = TextEditingController(
      text: widget.motivationQuote,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("User Details")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomTextFormField(
                      controller: userNameController,
                      hintText: 'Usama Elgendy',
                      title: 'User Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter User Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      controller: motivationQuoteController,
                      hintText: 'One task at a time. One step closer.',
                      title: 'Motivation Quote',
                      maxLine: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Motivation Quote";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      PreferencesManager().setString(
                        'userName',
                        userNameController.value.text,
                      );
                      PreferencesManager().setString(
                        'motivation_quote',
                        motivationQuoteController.value.text,
                      );
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
