

import 'package:flutter/material.dart';
import 'package:portafolio/Pages/Access.dart';
import 'package:portafolio/Pages/Home.dart';
import 'package:portafolio/Pages/Login.dart';
import 'package:portafolio/Routes/Routes.dart';

Map<String, Widget Function(BuildContext)> appRoutes(){
  return{
    Routes.HOME:(_) => const HomePage(),
    Routes.ACCESS:(_) => const Access(),
    Routes.LOGIN:(_) => const Login()
  };
}