import 'package:flutter/material.dart';
import 'screens/opening_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardio Comrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        
        textTheme: const TextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
      ),
      home: const OpeningScreen(),
      
      builder: (context, child) {
        return MediaQuery(
          
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(1.0, 2.0)),
          ),
          child: child!,
        );
      },
    );
  }
}
