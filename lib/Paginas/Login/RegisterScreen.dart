import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namix/NamixCore.dart';
import 'package:provider/provider.dart';
import '../AuthCheck/Auth_Service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  bool _switchValue = false;
  int _state = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Cores.Fundo,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
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
                      'Cria sua conta',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.1),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Crie sua conta para ter acesso completo a todas as funcionalidades e recursos disponiveis no app.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Cores.CorDeDestaque,
                        fontSize: 14,
                        fontFamily: 'OpenSans'),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  _buildTextField(
                      nameController, Icons.account_circle, 'Nome', false),
                  const SizedBox(height: 15),
                  _buildTextField(EmailController, Icons.email, 'Email', false),
                  const SizedBox(height: 15),
                  _buildTextField(
                      passwordController, Icons.lock, 'Senha', true),
                  const SizedBox(height: 15),
                  _buildTextField(passwordConfirmController, Icons.lock,
                      'Confirme sua senha', true),
                  const SizedBox(height: 30),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    height: 50,
                    onPressed: () {

                      if(checkRegister(nameController,EmailController,passwordController,passwordConfirmController)){
                        setState(() {
                          if (_state == 0) {
                            animateButton();
                            register();
                          }
                        });
                      }


                    },
                    color: Cores.CorDeDestaque,
                    child: setUpButtonChild(),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 35),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildFooterLogo(),
                  )
                ],
              ),
            ),
          ),
        ));
  }


  Widget setUpButtonChild() {
    if (_state == 0) {
      return const Text('Criar conta',
          style: TextStyle(color: Colors.white, fontSize: 16));
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
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

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
  }

  register() async {
    try {
      await context.read<AuthService>().registar(nameController.text,
          EmailController.text, passwordController.text, _switchValue);
    } on AuthErro catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  static final validCharacters = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

  checkRegister(TextEditingController nome, TextEditingController email,
      TextEditingController senha, TextEditingController senhaconfirm) {

    if (nome.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Digite o seu nome completo")));
      return false;
    }
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
    if (senhaconfirm.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Confirme sua senha")));
      return false;
    }
    if (senha.text != senhaconfirm.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("As senhas não conferem")));
      return false;
    }
    if (senha.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("A Senha deve ter no minimo 8 caracteres")));
      return false;
    }
    if (senha.text == "12345678") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Essa senha não pode ser utilizada")));
      return false;
    }
    if (senha.text.contains("123")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Essa senha não pode ser utilizada, por ser muito facil de advinhar")));
      return false;
    }
    if (!validCharacters.hasMatch(nome.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("nome invalido")));
      return false;
    }
    if (!EmailCheck().isValidEmail(email.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email invalido")));
      return false;
    }
    return true;
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
            labelStyle: const TextStyle(
              color: Colors.white24,
              fontFamily: 'OpenSans',
            ),
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
