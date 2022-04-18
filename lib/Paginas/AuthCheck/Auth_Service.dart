import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthErro implements Exception {
  String message;
  AuthErro(this.message);
}


class AuthService extends ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;




  AuthService(){
    _authCheck();
  }

  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }

  _authCheck(){
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  registar(String nome,String email, String senha, bool study) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
      usuario?.updateDisplayName(nome);
    } on FirebaseAuthException catch (e) {
      if(e.code == 'weak-password'){
        throw AuthErro("Utilize uma senha mais forte");
      } else if (e.code == 'email-already-in-use'){
        throw AuthErro("Este email já esta cadastrado");
      }
    }
  }


  loginwithou(String email, String senha) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        throw AuthErro("Email ou senha incorretos");
      } else if (e.code == 'wong-password'){
        throw AuthErro("Email ou senha incorretos");
      }

      

    }
  }

  logout() async{
    await _auth.signOut();
    _getUser();
  }


}