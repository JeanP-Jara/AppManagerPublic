import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portafolio/Alert/AlertShow.dart';
import 'package:portafolio/Routes/Routes.dart';
import 'package:animate_do/animate_do.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  FirebaseAuth auth = FirebaseAuth.instance;

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    print('Nombre de usuario: $username');
    print('Contraseña: $password');

    try{

      UserCredential credential = await auth.signInWithEmailAndPassword(email: username, password: password);
      Navigator.pushReplacementNamed(context, Routes.ACCESS);

    } on FirebaseAuthException catch(e){
      switch (e.code) {
        case "user-not-found":
          showAlertUsers(context, 'Usuario no encontrado');
          print("Usuario no encontrado");
          break;
        case "wrong-password":
          showAlertUsers(context, 'Contraseña incorrecta');
          print("Contraseña incorrecta.");
          break;
        default:
          showAlertUsers(context, 'Error desconocido');
          print("Unkown error.");
      }
    }catch(e){
      showAlertUsers(context, 'Error desconocido');
    }
  }

  void _estadoUserAutenticado(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user != null){
        print('Usuario Autenticado');
        //Navigator.pushReplacementNamed(context, Routes.MAPA);
      }else{
        print('Usuario NO Autenticado');
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _estadoUserAutenticado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background_blanco.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          FadeIn(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Gestor de dispositivos", style: TextStyle(fontSize: 48, color: Colors.blueGrey),),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Nombre de usuario o Correo Electrónico',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Iniciar Sesión'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
