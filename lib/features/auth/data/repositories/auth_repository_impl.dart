import 'package:cine_verse/core/errors/failures.dart';
import 'package:cine_verse/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cine_verse/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'auth_repository_impl.dart' as remoteDatasource;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, UserModel>> signInWithEmail (String email, String password) async {
    try {
      final credential = await remoteDatasource.signInWithEmail(email, password);
      return Right(UserModel.fromFirebase(credential.user!));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final credential = await remoteDatasource.signInWithGoogle();
      return Right(UserModel.fromFirebase(credential.user!));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDatasource.signOut();
  }
}
