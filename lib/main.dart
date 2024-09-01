import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portafolio/Routes/Pages.dart';
import 'package:portafolio/Routes/Routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*return ChangeNotifierProvider(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );*/
    return const MaterialAppWithTheme();
}
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({super.key});
  @override
  Widget build(BuildContext context) {
    //ThemeChanger theme = Provider.of(context);
    return MaterialApp(
      title: 'Administrador',
      //theme: theme.getThemeData(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        //brightness: Brightness.light,
        useMaterial3: true,
      ),
      initialRoute: Routes.LOGIN,
      routes: appRoutes(),

    );
  }
}
