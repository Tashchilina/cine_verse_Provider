import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Конкретная ошибка авторизации
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Другие возможные ошибки
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}