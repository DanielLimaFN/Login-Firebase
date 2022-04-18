import 'package:flutter/material.dart';
import 'package:namix/Paginas/AuthCheck/Auth_Service.dart';
import 'package:provider/provider.dart';
import 'NamixCore.dart';
import 'Paginas/AuthCheck/AuthCheck.dart';

void main() async {
  await initConfig();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Cores.Fundo,
          primaryColor: Cores.ConstrasteComfundo,
          cardColor: Cores.ConstrasteComfundo,

        ),
        home: const AuthCheck(),
      ),
    ),
  );
}
