import '../../../../consts/hive_new_visit_model.dart';

abstract class AddVisitState {}

class AddVisitInitial extends AddVisitState {}

class AddVisitLoading extends AddVisitState {}

class AddVisitLoaded extends AddVisitState {
  final VisitModel data;

  AddVisitLoaded({required this.data});
}

class AddVisitFailure extends AddVisitState {
  final String message;

  AddVisitFailure({required this.message});
}
