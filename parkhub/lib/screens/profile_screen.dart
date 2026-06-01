import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../themes/theme_controller.dart';
import '../services/reward_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RewardService _rewardService = RewardService();

  late VoidCallback _themeListener;

  @override
  void initState() {
    super.initState();

    _themeListener = () {
      setState(() {});
    };

    themeNotifier.addListener(_themeListener);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewards = _rewardService;
    final badges = rewards.getBadges();
    final recommendations = rewards.getPersonalisedRecommendations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('user@email.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            _buildProfileOptions(),
            const SizedBox(height: 18),

            _buildRewardsDashboard(rewards),
            const SizedBox(height: 18),

            _buildBadgeGrid(badges),
            const SizedBox(height: 18),

            _buildRecommendations(recommendations),
            const SizedBox(height: 18),

            _buildLogoutButton(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildProfileOptions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: _sectionDecoration(),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('My Vehicles'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.vehicles);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Booking History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ValueListenableBuilder(
            valueListenable: themeNotifier,
            builder: (context, ThemeMode currentMode, child) {
              final bool isDark = currentMode == ThemeMode.dark;
              return ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    themeNotifier.value = value
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsDashboard(RewardService rewards) {
    final progress = rewards.levelProgress;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A7F4B), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A7F4B).withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stars_rounded, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'ParkHub Rewards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '${rewards.points} points',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rewards.currentLevel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rewards.pointsToNextLevel == 0
                ? 'Highest reward level reached'
                : '${rewards.pointsToNextLevel} points until next level',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(List<RewardBadge> badges) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _sectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievement Badges',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final badge = badges[index];

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: badge.unlocked ? 1.0 : 0.45,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: badge.unlocked
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.green.shade900.withOpacity(0.25)
                              : Colors.green.shade50)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(16),

                    boxShadow: badge.unlocked
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.3),
                              blurRadius: 18,
                              spreadRadius: 1.5,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],

                    border: Border.all(
                      color: badge.unlocked
                          ? Colors.green.shade200
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          badge.emoji,
                          style: TextStyle(
                            fontSize: 42,
                            shadows: badge.unlocked
                                ? [
                                    const Shadow(
                                      blurRadius: 10,
                                      color: Colors.greenAccent,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),

                      const SizedBox(height: 6), 

                      Center(
                        child: Text(
                          badge.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: badge.unlocked
                                ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.greenAccent
                                      : Colors.green.shade900)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 2),

                      Center(
                        child: Text(
                          badge.unlocked ? 'Unlocked' : badge.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: badge.unlocked
                                ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(List<String> recommendations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _sectionDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text(
                'Personalised Recommendations',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Based on your mock ParkHub activity and preferences.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          ...recommendations.map(
            (recommendation) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey.shade900
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.recommend_rounded,
                    size: 18,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.blue.shade900,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: _sectionDecoration(),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Logout', style: TextStyle(color: Colors.red)),
        onTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
      ),
    );
  }

  BoxDecoration _sectionDecoration() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,

      borderRadius: BorderRadius.circular(20),

      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.4)
              : Colors.black.withOpacity(0.06),

          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
