import 'package:firebase_project/constants/route_constant.dart';
import 'package:firebase_project/modules/auth/screens/login_page.dart';
import 'package:firebase_project/modules/auth/screens/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> routeToPage({
  required BuildContext context,
  required String pageName,
  Object? arg,
}) async {
  return Navigator.pushNamed(context, pageName, arguments: arg);
}

Route<dynamic> myCustomRoutes(RouteSettings routeSettings) {
  final name = routeSettings.name;
  if (name == RouteConstant.loginRoute) {
    return CupertinoPageRoute(
      builder: (ctx) {
        return LoginPage();
      },
    );
  } else if (name == RouteConstant.registerRoute) {
    return CupertinoPageRoute(
      builder: (ctx) {
        return RegisterPage();
      },
    );
  } else {
    return MaterialPageRoute(builder: (ctx) {
      return const Scaffold(
        body: Center(
          child: Text('No Route Found!'),
        ),
      );
    });
  }
}
