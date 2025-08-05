import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final bool refresh;

  const LoadDashboardData({this.refresh = false});

  @override
  List<Object> get props => [refresh];
}

class NavigateToReport extends DashboardEvent {
  const NavigateToReport();

  @override
  List<Object> get props => [];
}
