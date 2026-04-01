import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sprint_maestro_screen.dart';
import 'bodysync_screen.dart';
import 'opening_screen.dart';


enum ImageSource { camera, gallery }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedImagePath; 

  Future<void> _pickImage() async {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exercise Photo'),
        content: const Text('Choose a photo source to track your physical activity.'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _handleImageSource(ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _handleImageSource(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageSource(ImageSource source) async {
    try {
      // Simulate loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Loading image...'),
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

   
      
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey[800],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.menu,
                        color: Colors.grey[800],
                        size: 24,
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Recent Exercises Section
                        _buildRecentExercisesSection(),
                        const SizedBox(height: 40),
                        // Top Cardio Exercises Section
                        _buildTopCardioExercisesSection(),
                        const SizedBox(height: 100), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Refresh button
            Positioned(
              top: 60,
              right: 16,
              child: Semantics(
                label: 'Refresh',
                hint: 'Return to opening screen',
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Haptic feedback
                      HapticFeedback.lightImpact();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OpeningScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800]!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey[800]!,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.grey[800],
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildRecentExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'small steps, big gains',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'view most recent exercises',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Blank white card
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
                // Display selected image if available
                if (_selectedImagePath != null)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                // 
                Positioned(
                  top: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedImagePath != null
                              ? Icons.edit
                              : Icons.add_photo_alternate,
                          color: Colors.grey[800],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCardioExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'push your limits, find your strength',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Text(
                'top cardio exercises',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.yellow[700],
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'aerobic exercise is superior in calorie loss',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 24) / 3; 
            final cardHeight = cardWidth * 1.2; 
            
            return Column(
              children: [
                // Row 1
                Row(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(0),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(1),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(2),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Row 2
                Row(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(3),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(4),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildExerciseCard(5),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCard(int index) {
    final exercises = [
      {
        'title': '30km swimming',
        'icon': Icons.pool,
        'color': Colors.blue,
        'imageColor': Colors.blue[300],
      },
      {
        'title': '60 minutes of rowing',
        'icon': Icons.rowing,
        'color': Colors.brown,
        'imageColor': Colors.brown[300],
      },
      {
        'title': '10km walking',
        'icon': Icons.directions_walk,
        'color': Colors.green,
        'imageColor': Colors.green[300],
      },
      {
        'title': '2 Hour HIIT Running',
        'icon': Icons.directions_run,
        'color': Colors.red,
        'imageColor': Colors.red[300],
      },
      {
        'title': '100 x 5 jumping rope',
        'icon': Icons.fitness_center,
        'color': Colors.orange,
        'imageColor': Colors.orange[300],
      },
      {
        'title': '1 hour of cycling',
        'icon': Icons.directions_bike,
        'color': Colors.cyan,
        'imageColor': Colors.cyan[300],
      },
    ];

    final exercise = exercises[index];

    return Tooltip(
      message: 'Tap to view details about ${exercise['title']}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Haptic feedback
            HapticFeedback.selectionClick();
            // Show exercise details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${exercise['title']} - Exercise details coming soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image placeholder
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: exercise['imageColor'] as Color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                exercise['icon'] as IconData,
                color: exercise['color'] as Color,
                size: 40,
              ),
            )
          ),
          // Title
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Center(
                child: Text(
                  exercise['title'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home - Active (orange rounded square)
            Semantics(
              label: 'Home',
              hint: 'Currently on home screen',
              selected: true,
              child: _buildNavItem(
                icon: Icons.home,
                isActive: true,
                onTap: () {
                  // Already on home
                },
              ),
            ),
            // Running Person
            Semantics(
              label: 'Sprint Maestro',
              hint: 'Navigate to running routes screen',
              button: true,
              child: _buildNavItem(
                icon: Icons.directions_run,
                isActive: false,
                onTap: () {
                  // Haptic feedback for navigation
                  HapticFeedback.selectionClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SprintMaestroScreen(),
                    ),
                  );
                },
              ),
            ),
            // Settings/Filters
            Semantics(
              label: 'BodySync',
              hint: 'Navigate to BMI and calorie tracking screen',
              button: true,
              child: _buildNavItem(
                icon: Icons.tune,
                isActive: false,
                onTap: () {
                  // Haptic feedback for navigation
                  HapticFeedback.selectionClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BodySyncScreen(),
                    ),
                  );
                },
              ),
            ),
            // Profile
            Semantics(
              label: 'Profile',
              hint: 'Navigate to profile screen',
              button: true,
              child: _buildNavItem(
                icon: Icons.person_outline,
                isActive: false,
                onTap: () {
                  // Haptic feedback for navigation
                  HapticFeedback.selectionClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    if (isActive) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800), // Orange
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}

// Placeholder screens for navigation
class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text('Exercises'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Exercises Screen'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
