import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  HomeBloc() : super(HomeInitial(false, false, false, false)) {
    on<HomeInitPlayer>((event, emit) async {
      bool isPermissionAllowed = await getAudioPermission();

      if (isPermissionAllowed) {
        await _mPlayer!.openPlayer().then((value) {
          _mPlayerIsInited = true;
        });

        await openTheRecorder().then((value) {
          _mRecorderIsInited = true;
        });
      }

      emit(HomeIdle(false, state.isPlaying, isPermissionAllowed, false));
    });

    on<HomeDisposePlayer>((event, emit) {
      _mPlayer!.closePlayer();
      _mPlayer = null;

      _mRecorder!.closeRecorder();
      _mRecorder = null;
    });

    on<HomePressRecordBtn>((event, emit) {
      print('dafi');
      if (!state.isAudioPermissionGranted) {
        add(const HomeInitPlayer());
      } else {
        if (state.isRecording) {
          stopRecorder();
          emit(HomeIdle(false, state.isPlaying, state.isAudioPermissionGranted,
              state.isRecordingAvailable));
        } else {
          record();
          emit(HomeRecording(
              true, state.isPlaying, state.isAudioPermissionGranted, true));
        }
      }
    });

    on<HomePressPlayBtn>((event, emit) async {
      if (state.isRecordingAvailable) {
        if (state.isPlaying) {
          stopPlayer();
          emit(HomeIdle(state.isRecording, false,
              state.isAudioPermissionGranted, state.isRecordingAvailable));
        } else {
          play();
          emit(HomePlaying(state.isRecording, true,
              state.isAudioPermissionGranted, state.isRecordingAvailable));
        }
      }
    });
  }

  Future<bool> getAudioPermission() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> openTheRecorder() async {
    await _mRecorder!.openRecorder();

    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }

    final session = await AudioSession.instance;

    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: AudioSource.microphone,
    )
        .then((value) {
      // emit something
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      _mplaybackReady = true;
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              // emit something
            })
        .then((value) {
      emit(HomeIdle(state.isRecording, false, state.isAudioPermissionGranted,
          state.isRecordingAvailable));
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      // emit something
    });
  }

// ----------------------------- UI --------------------------------------------

  Function? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  Function? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }
}
