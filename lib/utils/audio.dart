import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

AudioController audioController = new AudioController();

class AudioController {
  // Initialise players
  static AudioCache cachePlayer = AudioCache(fixedPlayer: audioPlayer);
  static AudioPlayer audioPlayer = AudioPlayer();

  AudioController() {
    // constructor
    playMusic();
  }

  stopMusic() {
    print("Stopping");
    audioPlayer?.stop();
  }

  playMusic() {
    cachePlayer.loop('theme_song.mp3');
  }
}
