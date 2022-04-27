import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'AuthCheck/Auth_Service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Logado com sucesso email verificado: ${context.read<AuthService>().usuario?.emailVerified}'));
  }
}
