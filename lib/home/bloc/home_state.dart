part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final bool isRecording;
  final bool isPlaying;
  final bool isRecordingAvailable;
  final bool isAudioPermissionGranted;

  const HomeState(this.isRecording, this.isPlaying,
      this.isAudioPermissionGranted, this.isRecordingAvailable);

  @override
  List<Object> get props => [isRecording, isPlaying];
}

class HomeInitial extends HomeState {
  HomeInitial(bool isRecording, bool isPlaying, bool isAudioPermissionGranted,
      bool isRecordingAvailable)
      : super(isRecording, isPlaying, isAudioPermissionGranted,
            isRecordingAvailable);
}

class HomeRecording extends HomeState {
  HomeRecording(bool isRecording, bool isPlaying, bool isAudioPermissionGranted,
      bool isRecordingAvailable)
      : super(isRecording, isPlaying, isAudioPermissionGranted,
            isRecordingAvailable);

  @override
  List<Object> get props => [isRecording];
}

class HomeIdle extends HomeState {
  HomeIdle(bool isRecording, bool isPlaying, bool isAudioPermissionGranted,
      bool isRecordingAvailable)
      : super(isRecording, isPlaying, isAudioPermissionGranted,
            isRecordingAvailable);

  @override
  List<Object> get props => [isRecording];
}

class HomePlaying extends HomeState {
  HomePlaying(bool isRecording, bool isPlaying, bool isAudioPermissionGranted,
      bool isRecordingAvailable)
      : super(isRecording, isPlaying, isAudioPermissionGranted,
            isRecordingAvailable);

  @override
  List<Object> get props => [isRecording];
}

class HomeAudioPermissionError extends HomeState {
  HomeAudioPermissionError(bool isRecording, bool isPlaying,
      bool isAudioPermissionGranted, bool isRecordingAvailable)
      : super(isRecording, isPlaying, isAudioPermissionGranted,
            isRecordingAvailable);
}
