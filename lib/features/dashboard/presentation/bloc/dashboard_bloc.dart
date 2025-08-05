import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karuhun_pos/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:karuhun_pos/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<NavigateToReport>(_onNavigateToReport);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const DashboardLoaded(message: 'Dashboard berhasil dimuat!'));
  }

  Future<void> _onNavigateToReport(
    NavigateToReport event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      ReportClicked(
        reportMessage:
            'Report card diklik! Fitur laporan akan segera tersedia.',
        clickedAt: DateTime.now(),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));
    emit(const DashboardLoaded(message: 'Kembali ke dashboard'));
  }
}
