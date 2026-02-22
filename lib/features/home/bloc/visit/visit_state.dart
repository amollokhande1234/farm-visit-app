import 'package:feild_visit_app/consts/hive_new_visit_model.dart';

abstract class VisitState {}

class VisitLoading extends VisitState {}

class VisitLoaded extends VisitState {
  List<VisitModel> visits;
  VisitLoaded({required this.visits});
}

class VisitFailure extends VisitState {
  String message;
  VisitFailure({required this.message});
}

class VisitInitial extends VisitState {}
