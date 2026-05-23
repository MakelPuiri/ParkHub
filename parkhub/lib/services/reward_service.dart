import '../models/parking_spot.dart';

class RewardBadge {
  final String name;
  final String description;
  final int requiredPoints;
  final String emoji;
  final bool unlocked;

  const RewardBadge({
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.emoji,
    required this.unlocked,
  });
}

class RewardService {
  RewardService._internal();

  static final RewardService _instance = RewardService._internal();

  factory RewardService() {
    return _instance;
  }

  int _points = 0;
  int _completedActivities = 0;
  bool _usedEvParking = false;
  final List<String> _recentLocations = [];

  int get points => _points;
  int get completedActivities => _completedActivities;
  bool get usedEvParking => _usedEvParking;
  List<String> get recentLocations => List.unmodifiable(_recentLocations);

  String get currentLevel {
    if (_points >= 300) return 'Level 4: ParkHub Champion';
    if (_points >= 200) return 'Level 3: Parking Pro';
    if (_points >= 100) return 'Level 2: Frequent Parker';
    if (_points >= 50) return 'Level 1: Explorer';
    return 'Starter';
  }

  int get nextLevelPoints {
    if (_points < 50) return 50;
    if (_points < 100) return 100;
    if (_points < 200) return 200;
    if (_points < 300) return 300;
    return 300;
  }

  int get previousLevelPoints {
    if (_points < 50) return 0;
    if (_points < 100) return 50;
    if (_points < 200) return 100;
    if (_points < 300) return 200;
    return 300;
  }

  int get pointsToNextLevel {
    final remaining = nextLevelPoints - _points;
    return remaining < 0 ? 0 : remaining;
  }

  double get levelProgress {
    if (_points >= 300) return 1.0;

    final levelRange = nextLevelPoints - previousLevelPoints;
    final currentProgress = _points - previousLevelPoints;

    if (levelRange <= 0) return 1.0;
    return (currentProgress / levelRange).clamp(0.0, 1.0);
  }

  List<RewardBadge> getBadges() {
    return [
      RewardBadge(
        name: 'Explorer',
        description: 'Earn 50 ParkHub points',
        requiredPoints: 50,
        emoji: '🧭',
        unlocked: _points >= 50,
      ),
      RewardBadge(
        name: 'Frequent Parker',
        description: 'Earn 100 ParkHub points',
        requiredPoints: 100,
        emoji: '🚗',
        unlocked: _points >= 100,
      ),
      RewardBadge(
        name: 'Parking Pro',
        description: 'Earn 200 ParkHub points',
        requiredPoints: 200,
        emoji: '🏆',
        unlocked: _points >= 200,
      ),
      RewardBadge(
        name: 'EV Friendly',
        description: 'Use an EV charging parking spot',
        requiredPoints: 0,
        emoji: '⚡',
        unlocked: _usedEvParking,
      ),
    ];
  }

  int addParkingActivity(ParkingSpot spot, int durationHours) {
    // Base points for completing simulated parking activity.
    int earnedPoints = 25;

    // Small bonus for longer mock bookings.
    earnedPoints += durationHours * 5;

    // Bonus for choosing an EV-enabled car park.
    if (spot.hasEvCharging) {
      earnedPoints += 10;
      _usedEvParking = true;
    }

    _points += earnedPoints;
    _completedActivities++;

    _recentLocations.remove(spot.name);
    _recentLocations.insert(0, spot.name);

    if (_recentLocations.length > 5) {
      _recentLocations.removeLast();
    }

    return earnedPoints;
  }

  List<String> getPersonalisedRecommendations() {
    final recommendations = <String>[];

    if (_usedEvParking) {
      recommendations.add('Try more EV-friendly parking locations with charger availability.');
    }

    if (_completedActivities >= 2) {
      recommendations.add('You often use ParkHub, so we recommend high-availability parking near the city centre.');
    }

    if (_recentLocations.isNotEmpty) {
      recommendations.add('Recently used: ${_recentLocations.first}. Similar nearby parking spots may suit you.');
    }

    if (_points >= 100) {
      recommendations.add('As a Frequent Parker, look for locations with more available spaces and lower peak demand.');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Complete a mock parking activity to unlock personalised parking recommendations.');
      recommendations.add('Save favourite areas and use filters to improve your recommendations.');
    }

    return recommendations;
  }
}