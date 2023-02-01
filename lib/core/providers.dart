import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';

// Provider that connects with the appwrite

final appWriteProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppWriteConstatnts.endPoint)
      .setProject(AppWriteConstatnts.projectId)
      .setSelfSigned(status: true);
});

final appWriteAccountProvider = Provider((ref) {
  final client = ref.watch(appWriteProvider);
  return Account(client);
});
