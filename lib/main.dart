import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/constants/route_constant.dart';
import 'package:firebase_project/cubit/image_picker_cubit.dart';
import 'package:firebase_project/modules/auth/cubit/auth_cubit.dart';
import 'package:firebase_project/services/route_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => AuthCubit()),
        BlocProvider(create: (ctx) => ImagePickerCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        onGenerateRoute: myCustomRoutes,
        initialRoute: RouteConstant.loginRoute,
      ),
    );
  }
}
