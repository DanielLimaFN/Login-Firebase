
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:namix/NamixCore.dart';
import 'package:namix/Paginas/AuthCheck/Auth_Service.dart';
import 'package:provider/provider.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int _state = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Cores.Fundo,
        body: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (_) => EmpresaHome(),),);
                  },
                  child: const Text(
                    'Login',
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(color: Colors.white, fontSize: 28,fontFamily: 'OpenSans', letterSpacing: 0.1),
                  ),
                ),
                const SizedBox(height: 6,),
                const Text(
                  'Entre com seu email e senha para realizar o login em nossa plataforma',
                  textAlign: TextAlign.start,
                  style:
                      TextStyle(color: Cores.CorDeDestaque, fontSize: 14, fontFamily: 'OpenSans'),
                ),
                const SizedBox(
                  height: 30,
                ),
                _buildTextField(emailController, Icons.email, 'Email', false),
                const SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Senha', true),
                const SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                        if(checkLogin(emailController, passwordController)){
                          setState(() {
                            if (_state == 0) {
                              animateButton();
                              loginFireBase();
                            }
                          });

                        }


                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  color: Cores.CorDeDestaque,
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Cores.ConstrasteComfundo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),


                      ),
                      child: IconButton(
                        onPressed: () async {
                        },
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          color: Cores.CorDeDestaque,
                        ),
                        padding: const EdgeInsets.all(12),
                        iconSize: 30.0,
                      ),
                    ),
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Cores.ConstrasteComfundo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),


                      ),
                      child: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          FontAwesomeIcons.facebook,
                          color: Cores.CorDeDestaque,
                        ),
                        padding: const EdgeInsets.all(12),
                        iconSize: 30.0,
                      ),
                    ),
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Cores.ConstrasteComfundo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),


                      ),
                      child: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          FontAwesomeIcons.twitter,
                          color: Cores.CorDeDestaque,
                        ),
                        padding: const EdgeInsets.all(12),
                        iconSize: 30.0,
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  <Widget>[

                      const Text('Não possui uma conta?', style: TextStyle(color: Cores.Formularios, fontSize: 16)),
                      TextButton(
                        onPressed: () { Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),);},
                          child: const Text('Cadastre-se', style: TextStyle(color: Cores.CorDeDestaque, fontSize: 16)
                      ),),
                    ],
                  ),

                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }


  static final validCharacters = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

  checkLogin(TextEditingController email, TextEditingController senha) {


    if (email.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Digite um email valido")));
      return false;
    }
    if (senha.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Digite sua senha")));
      return false;
    }


    if (!EmailCheck().isValidEmail(email.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email invalido")));
      return false;
    }
    return true;
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }

  _buildFooterLogo() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[

        Image.asset(
          'assets/img/logo.png',
          height: 40,
        ),
        const Text('  SST | Central',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
            )),
      ],
    );
  loginFireBase() async {
    try{
      await context.read<AuthService>().loginwithou(emailController.text, passwordController.text);
    } on AuthErro catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }



  _buildTextField(TextEditingController controller, IconData icon,
      String labelText, bool pass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
          color: Cores.ConstrasteComfundo,
          //border: Border.all(color: Cores.CorDeDestaque),
          borderRadius: BorderRadius.all(Radius.circular(17.0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: pass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white24, fontFamily: 'OpenSans',),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
}
