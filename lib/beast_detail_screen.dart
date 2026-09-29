import 'package:flutter/material.dart';

class BeastDetailScreen extends StatefulWidget {
  final Map<String, dynamic> beast;

  const BeastDetailScreen({
    super.key,
    required this.beast,
  });

  @override
  State<BeastDetailScreen> createState() => _BeastDetailScreenState();
}

class _BeastDetailScreenState extends State<BeastDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? '${widget.beast['name']} added to favorites!'
                        : '${widget.beast['name']} removed from favorites!',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(
                      (widget.beast['color'].r * 255.0).round().clamp(0, 255),
                      (widget.beast['color'].g * 255.0).round().clamp(0, 255),
                      (widget.beast['color'].b * 255.0).round().clamp(0, 255),
                      0.8,
                    ),
                    Color.fromRGBO(
                      (widget.beast['color'].r * 255.0).round().clamp(0, 255),
                      (widget.beast['color'].g * 255.0).round().clamp(0, 255),
                      (widget.beast['color'].b * 255.0).round().clamp(0, 255),
                      0.4,
                    ),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(
                          (widget.beast['color'].r * 255.0).round().clamp(0, 255),
                          (widget.beast['color'].g * 255.0).round().clamp(0, 255),
                          (widget.beast['color'].b * 255.0).round().clamp(0, 255),
                          0.5,
                        ),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pets,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Beast Info Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.beast['name'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Type & Rarity Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            (widget.beast['color'].r * 255.0).round().clamp(0, 255),
                            (widget.beast['color'].g * 255.0).round().clamp(0, 255),
                            (widget.beast['color'].b * 255.0).round().clamp(0, 255),
                            0.2,
                          ),
                          border: Border.all(color: widget.beast['color']),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.beast['type'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: widget.beast['color'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            (_getRarityColor(widget.beast['rarity']).r * 255.0).round().clamp(0, 255),
                            (_getRarityColor(widget.beast['rarity']).g * 255.0).round().clamp(0, 255),
                            (_getRarityColor(widget.beast['rarity']).b * 255.0).round().clamp(0, 255),
                            0.2,
                          ),
                          border: Border.all(
                            color: _getRarityColor(widget.beast['rarity']),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.beast['rarity'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getRarityColor(widget.beast['rarity']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildStatCard('Level', '${widget.beast['level']}',
                          Colors.deepPurple),
                      _buildStatCard('HP', '${widget.beast['level'] * 3}',
                          Colors.red),
                      _buildStatCard('Attack', '${widget.beast['level'] * 2}',
                          Colors.orange),
                      _buildStatCard('Defense', '${widget.beast['level']}',
                          Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // About Section
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'An amazing ${widget.beast['type']}-type beast with incredible power and unique abilities. '
                    'Perfect for trainers looking for a strong and reliable companion.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Abilities Section
                  const Text(
                    'Abilities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAbilityChip('Power Strike'),
                  const SizedBox(height: 8),
                  _buildAbilityChip('Element Shield'),
                  const SizedBox(height: 8),
                  _buildAbilityChip('Ultimate Blast'),
                  const SizedBox(height: 24),

                  // Moves Section
                  const Text(
                    'Moves',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildMoveCard('Fire Ball', 85)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMoveCard('Inferno', 110)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildMoveCard('Blaze', 75)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMoveCard('Ember', 40)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Caught ${widget.beast['name']}!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.catching_pokemon),
                          label: const Text('Catch'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Shared ${widget.beast['name']}!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          (color.r * 255.0).round().clamp(0, 255),
          (color.g * 255.0).round().clamp(0, 255),
          (color.b * 255.0).round().clamp(0, 255),
          0.1,
        ),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilityChip(String ability) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(103, 58, 183, 0.1),
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flash_on,
            size: 16,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 8),
          Text(
            ability,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveCard(String moveName, int power) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          (widget.beast['color'].r * 255.0).round().clamp(0, 255),
          (widget.beast['color'].g * 255.0).round().clamp(0, 255),
          (widget.beast['color'].b * 255.0).round().clamp(0, 255),
          0.1,
        ),
        border: Border.all(color: widget.beast['color']),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            moveName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'PWR: $power',
            style: TextStyle(
              fontSize: 10,
              color: widget.beast['color'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return Colors.grey;
      case 'Rare':
        return Colors.blue;
      case 'Epic':
        return Colors.purple;
      case 'Legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
