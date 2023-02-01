import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

// Want to sign up, get user => Account (appwrite.dart)
// Want to access user related  data => model.Account (model.dart)

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appWriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  // Sign up function
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  });

  // Login function
  // When user signup it will return session
  FutureEither<model.Session> login({
    required String email,
    required String password,
  });

  // Get user funcation
  Future<model.Account?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({
    required Account account,
  }) : _account = account;

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        // To generate unique id
        userId: ID.unique(),
        email: email,
        password: password,
      );
      // returns the created account
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        // returns the failure message
        Failure(
          e.message ?? 'Some unexpected error occurred',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      // returns the failure message
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<model.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      // To login you need to call createEmailSesion call
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(
        e.message ?? 'Something went wrong while login',
        stackTrace,
      ));
    }
  }
}
