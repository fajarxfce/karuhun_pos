import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardState {
  final String message;

  const DashboardLoaded({this.message = 'Dashboard loaded successfully'});

  @override
  List<Object?> get props => [message];
}

class ReportClicked extends DashboardState {
  final String reportMessage;
  final DateTime clickedAt;

  const ReportClicked({required this.reportMessage, required this.clickedAt});

  @override
  List<Object?> get props => [reportMessage, clickedAt];
}
