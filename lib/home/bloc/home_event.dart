part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomePressRecordBtn extends HomeEvent {
  const HomePressRecordBtn();

  @override
  List<Object> get props => [];
}

class HomePressPlayBtn extends HomeEvent {
  const HomePressPlayBtn();

  @override
  List<Object> get props => [];
}

class HomeInitPlayer extends HomeEvent {
  const HomeInitPlayer();

  @override
  List<Object> get props => [];
}

class HomeDisposePlayer extends HomeEvent {
  const HomeDisposePlayer();

  @override
  List<Object> get props => [];
}
