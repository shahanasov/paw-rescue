import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/presentation/auth/widgets/sign_widgets.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/pages/home/home.dart';
import 'package:paw_catcher_admin/services/data/auth_services.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    List<Widget> widgetsList = [
      Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Create account and choose favorite menu',
        style: TextStyle(
          color: AppTheme.softPink,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Name',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      textfield(
        controller: nameController,
        hint: 'Your Name',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Name cannot be empty';
          }
          return null;
        },
      ),
      Text(
        'Phone Number',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      textfield(
        controller: phoneController,
        hint: 'Your Phone Number',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Phone number cannot be empty';
          }
          final phoneRegex =
              RegExp(r'^\d{10}$'); // Adjust regex based on your requirement
          if (!phoneRegex.hasMatch(value)) {
            return 'Enter a valid phone number';
          }
          return null;
        },
      ),
      Text(
        'Email',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      textfield(
        controller: controller,
        hint: 'Your Email',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Email cannot be empty';
          }
          final emailRegex =
              RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
          if (!emailRegex.hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
      Text(
        'Password',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      passwordfield(
        controller: passwordController,
        ref: ref,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Password cannot be empty';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          // Regex to check at least one letter, one number, and one special character
          final passwordRegex = RegExp(
              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
          if (!passwordRegex.hasMatch(value)) {
            return 'Password must contain letter, number & special character';
          }
          return null;
        },
      ),
      SizedBox(
        height: 10,
      ),
      Center(
        child: buttonforAll(
          onPressed: () async {
            String? errorMessage;
            if (formKey.currentState!.validate()) {
              ref.read(authLoadingProvider.notifier).state = true;

              try {
                errorMessage = await signUp(
                  ref: ref,
                  phoneNumber: phoneController.text.trim(),
                  name: nameController.text.trim(),
                  email: controller.text.trim(),
                  password: passwordController.text.trim(),
                );

                if (errorMessage == null) {
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showErrorDialog(context, errorMessage);
                  }
                }
              } catch (error) {
                log("Error: $error");
                if (context.mounted) {
                  showErrorDialog(
                      context,
                      errorMessage ??
                          "Something went wrong. Please try again.");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Something went wrong. Please try again.'),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                }
              } finally {
                ref.read(authLoadingProvider.notifier).state = false;
              }
            }
          },
          hint: 'Register',
          context: context,
          color: AppTheme.softPink,
        ),
      ),
      optsign(context, false),
    ];
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetsList),
        ),
      ),
      bottomSheet: IgnorePointer(
        child: Container(
          color: AppTheme.backgroundColor,
          height: 80,
          child: Form(
            key: formKey,
            child: Column(
              spacing: 6,
              children: [
                Text('By clicking Register, you agree to our '),
                Text(
                  'Terms and Data Policy.',
                  style: TextStyle(color: AppTheme.softPink),
                )
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
