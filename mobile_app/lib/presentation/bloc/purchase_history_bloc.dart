import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_app/core/error/failures.dart';
import '../../domain/entities/purchase_history.dart';
import '../../domain/usecases/get_purchase_history.dart';

// Events
abstract class PurchaseHistoryEvent extends Equatable {
  const PurchaseHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetPurchaseHistoryEvent extends PurchaseHistoryEvent {
  final String userId;

  const GetPurchaseHistoryEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

// States
abstract class PurchaseHistoryState extends Equatable {
  const PurchaseHistoryState();
  
  @override
  List<Object> get props => [];
}

class PurchaseHistoryInitial extends PurchaseHistoryState {}

class PurchaseHistoryLoading extends PurchaseHistoryState {}

class PurchaseHistoryLoaded extends PurchaseHistoryState {
  final List<PurchaseHistory> purchaseHistory;

  const PurchaseHistoryLoaded(this.purchaseHistory);

  @override
  List<Object> get props => [purchaseHistory];
}

class PurchaseHistoryError extends PurchaseHistoryState {
  final String message;

  const PurchaseHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class PurchaseHistoryBloc extends Bloc<PurchaseHistoryEvent, PurchaseHistoryState> {
  final GetPurchaseHistory getPurchaseHistory;

  PurchaseHistoryBloc({required this.getPurchaseHistory}) : super(PurchaseHistoryInitial()) {
    on<GetPurchaseHistoryEvent>(_onGetPurchaseHistory);
  }

  void _onGetPurchaseHistory(GetPurchaseHistoryEvent event, Emitter<PurchaseHistoryState> emit) async {
    emit(PurchaseHistoryLoading());
    final result = await getPurchaseHistory(event.userId);
    emit(result.fold(
      (failure) => PurchaseHistoryError(_mapFailureToMessage(failure)),
      (purchaseHistory) => PurchaseHistoryLoaded(purchaseHistory),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Couldn\'t connect to the server. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network settings.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}