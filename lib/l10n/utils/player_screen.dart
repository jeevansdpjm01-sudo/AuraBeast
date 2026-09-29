import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../audio_service.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = false;
  bool isFavorite = false;
  bool shuffle = false;
  bool repeat = false;

  double progress = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Now Playing"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                "assets/images/album.jpg",
                height: 320,
                width: 320,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Mazhaiyin Isai",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "AuraBeast",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                )

              ],
            ),

            const SizedBox(height: 25),

            Slider(
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              value: progress,
              max: 100,
              onChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text("1:15",
                      style: TextStyle(color: Colors.white70)),
                  Text("3:45",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 30),

                    Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await audioService.skipToPrevious();
                  },
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  child: StreamBuilder<PlayerState>(
                    stream: audioService.playerStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;

                      return IconButton(
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () async {
                          if (playing) {
                            await audioService.pause();
                          } else {
                            await audioService.play();
                          }
                        },
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await audioService.skipToNext();
                  },
                ),
              ],
            ),

            const Spacer(),

            const Text(
              "High Quality • AuraBeast",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 15),

          ],
        ),
      ),
    );
  }
}