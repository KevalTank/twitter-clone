import 'package:twitter_clone/core/failure.dart';
import 'package:fpdart/fpdart.dart';

// Defining custom data types which can retun two types of data

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = Future<void>;
