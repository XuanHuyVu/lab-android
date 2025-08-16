import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// Biến toàn cục giữ audioHandler
late AudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.musicplayer.channel',
      androidNotificationChannelName: 'Music Player',
      androidNotificationOngoing: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intent_service',
      debugShowCheckedModeBanner: false,
      home: MusicScreen(audioHandler: _audioHandler),
    );
  }
}

class MusicScreen extends StatelessWidget {
  final AudioHandler audioHandler;
  const MusicScreen({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intent_service")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/music_bg.jpg', fit: BoxFit.cover),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_circle, size: 50, color: Colors.blue),
                onPressed: () {
                  audioHandler.play();
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.stop_circle, size: 50, color: Colors.blue),
                onPressed: () async {
                  await audioHandler.stop();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Audio Handler quản lý phát nhạc nền
class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        playing: _player.playing,
      ));
    });
  }

  @override
  Future<void> play() async {
    await _player.setAsset('assets/sample.mp3');
    await _player.play();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }
}
