import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'home_screen.dart';
import 'sprint_maestro_screen.dart';
import 'opening_screen.dart';

class BodySyncScreen extends StatefulWidget {
  const BodySyncScreen({super.key});

  @override
  State<BodySyncScreen> createState() => _BodySyncScreenState();
}

class _BodySyncScreenState extends State<BodySyncScreen> {
  // BMI data over months (example data)
  final List<Map<String, dynamic>> _bmiData = [
    {'month': 'Jan', 'red': 16.5, 'yellow': 17.0, 'blue': 18.0, 'green': 15.5},
    {'month': 'Feb', 'red': 17.0, 'yellow': 17.5, 'blue': 18.2, 'green': 16.0},
    {'month': 'Mar', 'red': 17.5, 'yellow': 18.0, 'blue': 18.5, 'green': 16.5},
    {'month': 'Apr', 'red': 18.0, 'yellow': 18.2, 'blue': 18.3, 'green': 17.0},
    {'month': 'May', 'red': 18.2, 'yellow': 18.5, 'blue': 18.4, 'green': 17.5},
    {'month': 'Jun', 'red': 18.5, 'yellow': 18.6, 'blue': 18.6, 'green': 18.0},
  ];

  // Calorie data
  final int _consumedCalories = 350;
  final int _targetCalories = 1500;
  final int _fatCalories = 120;
  final int _proteinCalories = 140;
  final int _carbCalories = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008080), // Dark teal background
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Header
              const Center(
                child: Column(
                  children: [
                    Text(
                      'BodySync',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'powered by Cardio Comrade',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Current BMI
              const Center(
                child: Text(
                  'Current BMI: 18.6 (healthy)',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // BMI Tracker Section
              const Text(
                'BMI Tracker',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 250,
                  child: CustomPaint(
                    painter: BMIGraphPainter(_bmiData),
                    child: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Calorie Tracking Section
              const Text(
                'Calorie Tracking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Daily Calories Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 350,
                      child: Row(
                        children: [
                          // Donut Chart
                          Expanded(
                            child: CustomPaint(
                              painter: CalorieDonutPainter(
                                consumed: _consumedCalories,
                                target: _targetCalories,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_consumedCalories',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const Text(
                                      'of',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '$_targetCalories kcal',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Legend
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(
                                const Color(0xFFFFA500), // Yellow-orange
                                'fat',
                              ),
                              const SizedBox(height: 12),
                              _buildLegendItem(
                                const Color(0xFFFF6347), // Reddish-orange
                                'protein',
                              ),
                              const SizedBox(height: 12),
                              _buildLegendItem(
                                const Color(0xFF228B22), // Dark green
                                'carbohydrate',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
            // Refresh button
            Positioned(
              top: 70,
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
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

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
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
            // Home
            _buildNavItem(
              icon: Icons.home,
              isActive: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            // Running Person
            _buildNavItem(
              icon: Icons.directions_run,
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SprintMaestroScreen(),
                  ),
                );
              },
            ),
            // Settings/Filters - Active
            _buildNavItem(
              icon: Icons.tune,
              isActive: true,
              onTap: () {
                // Already on this screen
              },
            ),
            // Profile
            _buildNavItem(
              icon: Icons.person_outline,
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
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
            child: Icon(
              icon,
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

// Custom painter for BMI line graph
class BMIGraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  BMIGraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Vertical grid lines
    for (int i = 0; i <= 5; i++) {
      final x = (size.width / 5) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // X-axis (pointing right)
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      axisPaint,
    );
    // Arrow for X-axis
    canvas.drawLine(
      Offset(size.width - 10, size.height - 25),
      Offset(size.width, size.height - 20),
      axisPaint,
    );
    canvas.drawLine(
      Offset(size.width - 10, size.height - 15),
      Offset(size.width, size.height - 20),
      axisPaint,
    );

    // Y-axis (pointing up)
    canvas.drawLine(
      Offset(20, size.height),
      Offset(20, 0),
      axisPaint,
    );
    // Arrow for Y-axis
    canvas.drawLine(
      Offset(15, 10),
      Offset(20, 0),
      axisPaint,
    );
    canvas.drawLine(
      Offset(25, 10),
      Offset(20, 0),
      axisPaint,
    );

    // Calculate min and max BMI values
    double minBMI = 15.0;
    double maxBMI = 19.0;
    double range = maxBMI - minBMI;

    // Draw lines for each data series
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.lightBlue,
      Colors.green,
    ];

    final keys = ['red', 'yellow', 'blue', 'green'];

    for (int seriesIndex = 0; seriesIndex < keys.length; seriesIndex++) {
      final key = keys[seriesIndex];
      final color = colors[seriesIndex];

      final path = Path();
      bool isFirst = true;

      for (int i = 0; i < data.length; i++) {
        final bmiValue = data[i][key] as double;
        final x = 40 + (i * (size.width - 60) / (data.length - 1));
        final normalizedBMI = (bmiValue - minBMI) / range;
        final y = size.height - 40 - (normalizedBMI * (size.height - 60));

        if (isFirst) {
          path.moveTo(x, y);
          isFirst = false;
        } else {
          path.lineTo(x, y);
        }

        // Draw point
        canvas.drawCircle(
          Offset(x, y),
          4,
          Paint()..color = color,
        );
      }

      // Draw line
      paint.color = color;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BMIGraphPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

// Custom painter for calorie donut chart
class CalorieDonutPainter extends CustomPainter {
  final int consumed;
  final int target;

  CalorieDonutPainter({
    required this.consumed,
    required this.target,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6; // Larger inner circle for thinner ring

    // Draw background circle (light gray)
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;

    canvas.drawCircle(center, radius - (radius - innerRadius) / 2, backgroundPaint);

    // Draw progress arc
    final progress = consumed / target;
    final progressPaint = Paint()
      ..color = const Color(0xFFFF6347) // Match protein indicator color
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    final rect = Rect.fromCircle(center: center, radius: radius - (radius - innerRadius) / 2);

    // Start from bottom (270 degrees)
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start at top (12 o'clock)
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw inner white circle
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(CalorieDonutPainter oldDelegate) {
    return oldDelegate.consumed != consumed || oldDelegate.target != target;
  }
}

