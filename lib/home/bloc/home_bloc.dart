import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial(false)) {
    on<HomePressRecordBtn>((event, emit) {
      if (state.isRecording) {
        emit(HomeDoneRecording(false));
      } else {
        emit(HomeRecording(true));
      }
    });
  }
}
