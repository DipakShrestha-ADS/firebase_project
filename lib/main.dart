import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/constants/route_constant.dart';
import 'package:firebase_project/cubit/image_picker_cubit.dart';
import 'package:firebase_project/modules/auth/cubit/auth_cubit.dart';
import 'package:firebase_project/services/route_services.dart';
import 'package:firebase_project/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final spInstance = await SharedPreferences.getInstance();
  runApp(MyApp(
    sp: spInstance,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.sp}) : super(key: key);
  final SharedPreferences sp;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferencesServices sps;
  @override
  void initState() {
    sps = SharedPreferencesServices(widget.sp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx) => sps),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AuthCubit(sps: sps)),
          BlocProvider(create: (ctx) => ImagePickerCubit()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          onGenerateRoute: myCustomRoutes,
          initialRoute: RouteConstant.splashRoute,
        ),
      ),
    );
  }
}
