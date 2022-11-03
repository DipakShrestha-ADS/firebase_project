import 'package:firebase_project/constants/route_constant.dart';
import 'package:firebase_project/modules/auth/cubit/auth_cubit.dart';
import 'package:firebase_project/services/shared_preferences_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sps = context.read<SharedPreferencesServices>();
    final userData = sps.getUserDetails();
    print('data : $userData');
    Future.delayed(const Duration(seconds: 3), () {
      context.read<AuthCubit>().loginUserUsingSp(data: userData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, authState) {
        if (authState.userModel != null) {
          Navigator.pushNamedAndRemoveUntil(context, RouteConstant.homeRoute, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, RouteConstant.loginRoute, (route) => false);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(
            color: Colors.teal,
            radius: 20,
          ),
        ),
      ),
    );
  }
}
