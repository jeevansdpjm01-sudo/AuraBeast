import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
        elevation: 0,
        title: const Text(
          "Your Library",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          _libraryTile(
            Icons.favorite,
            Colors.red,
            "Liked Songs",
            "25 Songs",
          ),

          _libraryTile(
            Icons.download,
            Colors.green,
            "Downloads",
            "10 Songs",
          ),

          _libraryTile(
            Icons.history,
            Colors.orange,
            "Recently Played",
            "Recently Listened",
          ),

          const SizedBox(height: 25),

          const Text(
            "Playlists",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _playlistCard(
            "Tamil Hits",
            "120 Songs",
            "assets/images/album.jpg",
          ),

          _playlistCard(
            "Love Songs",
            "80 Songs",
            "assets/images/album.jpg",
          ),

          _playlistCard(
            "Workout Mix",
            "55 Songs",
            "assets/images/album.jpg",
          ),

          const SizedBox(height: 25),

          const Text(
            "Artists",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _artistTile("A.R. Rahman"),
          _artistTile("Anirudh"),
          _artistTile("Yuvan Shankar Raja"),
          _artistTile("Harris Jayaraj"),

          const SizedBox(height: 25),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Create Playlist"),
            ),
          ),

          const SizedBox(height: 30),

        ],
      ),
    );
  }

  Widget _libraryTile(
      IconData icon,
      Color color,
      String title,
      String subtitle,
      ) {
    return Card(
      color: Colors.grey.shade900,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 18,
        ),
      ),
    );
  }

  Widget _playlistCard(
      String title,
      String songs,
      String image,
      ) {
    return Card(
      color: Colors.grey.shade900,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            image,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          songs,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.play_circle_fill,
          color: Colors.green,
          size: 32,
        ),
      ),
    );
  }

  Widget _artistTile(String artist) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        artist,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 18,
      ),
    );
  }
}