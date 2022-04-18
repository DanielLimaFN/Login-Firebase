




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namix/Paginas/AuthCheck/Auth_Service.dart';
import 'package:namix/Paginas/Login/LoginScreen.dart';
import 'package:provider/provider.dart';

import '../Home.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

   if(auth.isLoading) {
     return loading();
   } else if(auth.usuario == null) {
     return LoginScreen();
   } else return HomePage();
  }

  loading(){
    try {
      const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),

        ),
      );
    } catch(e) {
      print(e);
    }
  }

}

