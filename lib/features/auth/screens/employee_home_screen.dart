import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'video_library_screen.dart';
import 'folder_screen.dart';
import 'notifications_screen.dart';

/// ===============================
/// MODEL (Ready for backend)
/// ===============================
class DashboardData {
  final int totalVisitors;
  final int authorized;
  final int newVisitors;
  final int notAuthorized;
  final List<AlertBarData> alertReport;

  DashboardData({
    required this.totalVisitors,
    required this.authorized,
    required this.newVisitors,
    required this.notAuthorized,
    required this.alertReport,
  });
}

class AlertBarData {
  final String day;
  final int authorized;
  final int notAuthorized;

  AlertBarData({
    required this.day,
    required this.authorized,
    required this.notAuthorized,
  });
}

/// ===============================
/// SERVICE (Replace with real API)
/// ===============================
class DashboardService {
  Future<DashboardData> fetchDashboard() async {
    await Future.delayed(const Duration(seconds: 1));

    return DashboardData(
      totalVisitors: 2326,
      authorized: 1400,
      newVisitors: 600,
      notAuthorized: 326,
      alertReport: [
        AlertBarData(day: "Mon", authorized: 10, notAuthorized: 5),
        AlertBarData(day: "Tue", authorized: 14, notAuthorized: 3),
        AlertBarData(day: "Wed", authorized: 8, notAuthorized: 7),
        AlertBarData(day: "Thu", authorized: 16, notAuthorized: 4),
        AlertBarData(day: "Fri", authorized: 12, notAuthorized: 6),
      ],
    );
  }
}

/// ===============================
/// MAIN PAGE
/// ===============================
class VisitorDashboardPage extends StatefulWidget {
  const VisitorDashboardPage({super.key});

  @override
  State<VisitorDashboardPage> createState() => _VisitorDashboardPageState();
}

class _VisitorDashboardPageState extends State<VisitorDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _DashboardView(),
    VideoLibraryScreen(),
    FolderScreen(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF050B14), // Deep premium dark background
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.2,
            colors: [
              Color(0xFF112240), // Subtle neon glow in corner
              Color(0xFF050B14),
            ],
          ),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: _BottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: DashboardService().fetchDashboard(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        final data = snapshot.data!;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Good Morning,",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Uncle",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFF00E5FF), Color(0xFFD500F9)],
                              ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00E5FF).withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.grey),
                          onPressed: () {
                            // TODO: Add Settings Route
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.red),
                          onPressed: () {
                            context.go('/');
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// VISITOR CARD
                _VisitorCard(data: data),

                const SizedBox(height: 30),

                /// ALERT REPORT
                _AlertReportCard(data: data),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ===============================
/// VISITOR PIE CARD
/// ===============================
class _VisitorCard extends StatelessWidget {
  final DashboardData data;

  const _VisitorCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            "Today",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 50.0)),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: data.authorized.toDouble(),
                        color: const Color(0xFF00E5FF), // Neon Cyan
                        radius: 22,
                        titleStyle: const TextStyle(fontSize: 0),
                      ),
                      PieChartSectionData(
                        value: data.newVisitors.toDouble(),
                        color: const Color(0xFFD500F9), // Neon Purple
                        radius: 22,
                        titleStyle: const TextStyle(fontSize: 0),
                      ),
                      PieChartSectionData(
                        value: data.notAuthorized.toDouble(),
                        color: const Color(0xFFFF1744), // Neon Pink/Red
                        radius: 22,
                        titleStyle: const TextStyle(fontSize: 0),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${data.totalVisitors}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Visitors",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// LEGEND
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: const [
              _LegendItem("Authorized", Color(0xFF00E5FF)),
              _LegendItem("New", Color(0xFFD500F9)),
              _LegendItem("Not Authorized", Color(0xFFFF1744)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// ALERT BAR REPORT
/// ===============================
class _AlertReportCard extends StatelessWidget {
  final DashboardData data;

  const _AlertReportCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alert Report",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFFD500F9), Color(0xFFFF1744)],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 150.0, 50.0)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                barGroups: List.generate(
                  data.alertReport.length,
                  (index) {
                    final item = data.alertReport[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.authorized.toDouble(),
                          width: 8,
                          color: const Color(0xFF00E5FF),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 20,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        BarChartRodData(
                          toY: item.notAuthorized.toDouble(),
                          width: 8,
                          color: const Color(0xFFFF1744),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 20,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// LEGEND ITEM
/// ===============================
class _LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const _LegendItem(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

/// ===============================
/// BOTTOM NAV
/// ===============================
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221).withOpacity(0.85), // Glassy dark
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.video_library, 1),
          _buildNavItem(Icons.folder, 2),
          _buildNavItem(Icons.notifications, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF00E5FF).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
              )
            : const BoxDecoration(),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFF00E5FF)
              : Colors.grey.withOpacity(0.7),
          size: isSelected ? 28 : 24,
          shadows: isSelected
              ? [
                  const Shadow(
                    color: Color(0xFF00E5FF),
                    blurRadius: 15,
                  )
                ]
              : null,
        ),
      ),
    );
  }
}

/// ===============================
/// CARD DECORATION
/// ===============================
BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: const Color(0xFF131B2A).withOpacity(0.7), // Glassmorphic panel
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white.withOpacity(0.08),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 20,
        spreadRadius: -5,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        // Neon glow
        color: const Color(0xFF00E5FF).withOpacity(0.05),
        blurRadius: 40,
        spreadRadius: 1,
      ),
    ],
  );
}
