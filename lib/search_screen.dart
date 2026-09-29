import 'package:flutter/material.dart';
import 'song.dart';
import 'song_card.dart';
import 'l10n/app_localizations.dart';
import 'audio_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = 'All';

  final List<String> categories = [
    'All',
    'Top Hits',
    'Aura',
  ];

  final List<Song> songs = Song.sampleSongs;

  List<Song> get filteredSongs {
    final query = _searchController.text.toLowerCase();
    return songs.where((song) {
      final matchesQuery = song.title.toLowerCase().contains(query) || song.artist.toLowerCase().contains(query);
      final matchesCategory = _activeCategory == 'All' ||
          song.source.toLowerCase() == _activeCategory.toLowerCase() ||
          song.title.toLowerCase().contains(_activeCategory.toLowerCase()) ||
          song.artist.toLowerCase().contains(_activeCategory.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.tune, color: Colors.white70),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  final hasText = value.text.isNotEmpty;
                  return TextField(
                    key: const ValueKey('searchTextField'),
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF23232E),
                      hintText: 'Search Aura Beast songs',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      suffixIcon: hasText
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70),
                              onPressed: () {
                                _searchController.clear();
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = category == _activeCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    backgroundColor: const Color(0xFF1E1E28),
                    selectedColor: Colors.deepPurple.shade400,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _activeCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredSongs.isEmpty
                  ? Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredSongs.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        final song = filteredSongs[index];
                        return SongCard(
                          title: song.title,
                          artist: song.artist,
                          duration: '${song.duration.inMinutes}:${song.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                          artworkUrl: song.artwork,
                          isPlaying: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SongDetailScreen(song: song),
                              ),
                            );
                          },
                          onPlayPause: () {
                            audioService.playAsset(
                              asset: song.audioAsset,
                              title: song.title,
                              artist: song.artist,
                              artwork: song.artwork,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
