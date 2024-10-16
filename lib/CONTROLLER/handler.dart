import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class MozAudioHandler extends BaseAudioHandler {
  final AudioPlayer mplayer = AudioPlayer();
  final ConcatenatingAudioSource mplaylist =
      ConcatenatingAudioSource(children: []);

  MozAudioHandler() {
    _loadEmptyPlaylist();
    _listenToPlayerStateChanges();
  }

  void _loadEmptyPlaylist() async {
    try {
      await mplayer.setAudioSource(mplaylist);
    } catch (e) {
      print("Error loading playlist: $e");
    }
  }

  void _listenToPlayerStateChanges() {
    mplayer.playbackEventStream.listen((event) {
      final playing = mplayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[mplayer.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[mplayer.loopMode]!,
        shuffleMode: (mplayer.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: mplayer.position,
        bufferedPosition: mplayer.bufferedPosition,
        speed: mplayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSources = mediaItems.map(_createAudioSource);
    mplaylist.addAll(audioSources.toList());
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    mplayer.seek(Duration.zero, index: index);
  }

  @override
  Future<void> play() => mplayer.play();

  @override
  Future<void> pause() => mplayer.pause();

  @override
  Future<void> stop() async {
    await mplayer.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => mplayer.seek(position);

  @override
  Future<void> skipToNext() => mplayer.seekToNext();

  @override
  Future<void> skipToPrevious() => mplayer.seekToPrevious();

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['uri'] as String),
      tag: mediaItem,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        mplayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        mplayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        mplayer.setLoopMode(LoopMode.all);
        break;
      case AudioServiceRepeatMode.group:
        mplayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    mplayer.setShuffleModeEnabled(shuffleMode != AudioServiceShuffleMode.none);
    if (shuffleMode == AudioServiceShuffleMode.all) {
      await mplayer.shuffle();
    }
  }
}

Future<void> initAudioService() async {
  await AudioService.init(
    builder: () => MozAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'in.sanju.mozmusic.audio',
      androidNotificationChannelName: 'Audio Service',
      androidNotificationOngoing: true,
      // androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      // androidNotificationChannelName: 'Moz Audio playback',
      // androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      preloadArtwork: true,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      // notificationColor:  Color.fromARGB(255, 169, 142, 174),
      androidStopForegroundOnPause: true,
    ),
  );
}
