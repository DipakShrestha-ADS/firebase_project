import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_project/cubit/image_picker_cubit.dart';
import 'package:firebase_project/modules/auth/cubit/auth_cubit.dart';
import 'package:firebase_project/modules/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  bool obscure = true;
  final formKey = GlobalKey<FormState>();
  Uint8List? data;
  final imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    'https://www.projectcounter.org/wp-content/uploads/2016/03/icon-register.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Create your Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Wrap(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Center(
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_photo_alternate,
                                color: Colors.teal,
                              ),
                              onPressed: () async {
                                final imageFile = await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                BlocProvider.of<ImagePickerCubit>(context).handlePickedImage(imageFile);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final imageFile = await imagePicker.pickImage(
                                  source: ImageSource.camera,
                                );
                                BlocProvider.of<ImagePickerCubit>(context).handlePickedImage(imageFile);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(builder: (context, ipState) {
                        if (ipState.imageData != null) {
                          return Image.memory(
                            ipState.imageData!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.red,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid Email';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Please enter your password.';
                    }

                    if ((value.length ?? 0 < 8) == true) {
                      return 'Please enter a valid password.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Please enter your password.';
                    }

                    if ((value.length ?? 0 < 8) == true) {
                      return 'Please enter a valid password.';
                    }
                    if (value != passwordController.text) {
                      return 'Password doesn\'t matched!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  //maxLength: 2,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscure,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age.';
                    }

                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Enter your valid number.';
                    }
                    if (age < 18) {
                      return 'Enter age above 18.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Age',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    if (value.length < 10) {
                      return 'Please enter your valid phone number.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  formKey.currentState!.save();
                  if (formKey.currentState!.validate()) {
                    final fullName = fullNameController.text;
                    final email = emailController.text;
                    final password = passwordController.text;
                    final age = ageController.text;
                    final phoneNumber = phoneController.text;
                    final imageState = context.read<ImagePickerCubit>().state;
                    if (imageState.image == null) {
                      BotToast.showText(text: 'Please select your profile picture.');
                      return;
                    }
                    UserModel userModel = UserModel(
                      fullName: fullName,
                      email: email,
                      password: password,
                      age: int.parse(age),
                      phoneNumber: phoneNumber,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    await context.read<AuthCubit>().registerUser(userModel: userModel, context: context);
                  }
                },
                child: const Text('Register'),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
