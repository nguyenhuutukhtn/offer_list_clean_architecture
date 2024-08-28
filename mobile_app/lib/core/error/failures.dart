import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network failure']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failure']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure']) : super(message);
}

class PurchaseFailure extends Failure {
  const PurchaseFailure([String message = 'Purchase failure']) : super(message);
}