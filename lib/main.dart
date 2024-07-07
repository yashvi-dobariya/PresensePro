import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:presencepro/view/home_screen.dart';
import 'package:presencepro/common/utils/size_config.dart';
import 'common/utils/colour.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
  );

  @override
  Widget build(BuildContext context) {
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
          home: const HomeScreen(),
        );
      },
    );
  }
}
