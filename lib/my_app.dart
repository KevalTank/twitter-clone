import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/view/sign_up_view.dart';
import 'package:twitter_clone/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const SignUpView(),
    );
  }
}
