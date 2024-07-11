import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:presencepro/Register.dart';
import 'common/utils/colour.dart';
import 'common/utils/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
  }

  final defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
  );

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context)  {
    SizeConfig().init(context);
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppConst.white,
            colorScheme: lightColorScheme ?? defaultLightColorScheme,
            useMaterial3: true,
          ),
          home: Register(),
        );
      },
    );
  }
}
