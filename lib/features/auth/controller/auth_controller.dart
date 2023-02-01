import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: authAPI);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;

  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  Future<model.Account?> currentUser() {
    return _authAPI.currentUserAccount();
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Here state means bool which is provided on StateNotifier
    state = true;
    final result = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    result.fold(
      (l) {
        showSnackBar(l.message, context);
      },
      (r) {
        showSnackBar('Account has been created! Please login', context);
        Navigator.of(context).push(LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    // Here state means bool which is provided on StateNotifier
    final result = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    result.fold(
      (l) {
        showSnackBar(l.message, context);
      },
      (r) {
        Navigator.of(context).push(HomeView.route());
      },
    );
  }
}
