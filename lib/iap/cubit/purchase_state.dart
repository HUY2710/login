import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PurchaseState extends Equatable {}

class PurchaseLoading extends PurchaseState {
  @override
  List<Object?> get props => [];
}

class PurchasePending extends PurchaseState {
  @override
  List<Object?> get props => [];
}

class PurchaseSuccess<T> extends PurchaseState {
  PurchaseSuccess(this.data);

  final T? data;

  @override
  List<Object?> get props => [data];
}

class PurchaseError extends PurchaseState {
  PurchaseError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
