import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

AudioController audioController = new AudioController();

class AudioController {
  // Initialise players
  static bool musicPlaying;
  static AudioCache cachePlayer = AudioCache(fixedPlayer: audioPlayer);
  static AudioPlayer audioPlayer = AudioPlayer();

  AudioController() {
    // constructor
    playMusic();
  }

  getMusicPlaying() {
    return musicPlaying;
  }

  stopMusic() {
    musicPlaying = false;
    audioPlayer?.stop();
  }

  playMusic() {
    musicPlaying = true;
    cachePlayer.loop('theme_song.mp3');
  }
}
