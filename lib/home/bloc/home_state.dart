part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final bool isRecording;

  const HomeState(this.isRecording);

  @override
  List<Object> get props => [isRecording];
}

class HomeInitial extends HomeState {
  const HomeInitial(bool isRecording) : super(isRecording);
}

class HomeRecording extends HomeState {
  const HomeRecording(bool isRecording) : super(isRecording);

  @override
  List<Object> get props => [isRecording];
}

class HomeDoneRecording extends HomeState {
  const HomeDoneRecording(bool isRecording) : super(isRecording);

  @override
  List<Object> get props => [isRecording];
}
