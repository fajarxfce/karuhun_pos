import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToTab extends NavigationEvent {
  final int index;

  const NavigateToTab(this.index);

  @override
  List<Object> get props => [index];
}

// States
abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationChanged extends NavigationState {
  final int index;

  const NavigationChanged(this.index);

  @override
  List<Object> get props => [index];
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationChanged(0)) {
    on<NavigateToTab>((event, emit) {
      emit(NavigationChanged(event.index));
    });
  }
}
