import 'package:flutter/material.dart';
import 'package:to_do_app/ui_design/home/edit_task_screen.dart';
import 'package:to_do_app/ui_design/home/home_screen.dart';
import 'package:to_do_app/ui_design/my_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ToDO Application",
      routes: {
        HomeScreen.routeName:(_)=> HomeScreen(),
        EditScreen.RouteName:(_)=>EditScreen(),
      },
      initialRoute: HomeScreen.routeName,
      theme:MyTheme.lightTheme,
    );
  }
}
