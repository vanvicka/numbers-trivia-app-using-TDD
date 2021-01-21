import 'package:fisrtflutterapp/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'package:fisrtflutterapp/injection_container.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(fontFamily: 'Orbitron',
        primaryColor: Colors.purple.shade800,
      ),
      home: NumberTriviaPage(),
    );
  }
}


