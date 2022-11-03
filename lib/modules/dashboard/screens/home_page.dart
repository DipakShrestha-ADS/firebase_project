import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userModel = context.read<AuthCubit>().state.userModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          userModel == null ? 'N\A' : userModel.fullName,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
