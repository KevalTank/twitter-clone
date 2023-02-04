import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userAPI: userAPI);
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid: uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
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
      (r) async {
        UserModel user = UserModel(
          email: email,
          name: getNameFromEmailId(emailId: email),
          followers: const [],
          folowing: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final savedUser = await _userAPI.saveUserData(user);
        savedUser.fold(
          (l) {
            showSnackBar(l.message, context);
          },
          (r) {
            showSnackBar('Account has been created! Please login', context);
            Navigator.of(context).push(LoginView.route());
          },
        );
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

  Future<UserModel> getUserData({required String uid}) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
