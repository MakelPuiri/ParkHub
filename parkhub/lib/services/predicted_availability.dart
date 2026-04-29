class PredictedAvailability {
  final String lotId;
  final DateTime timestamp;
  final int predictedAvailableSpots;
  final int totalSpaces;
  final List<PeakTime> peakTimes;
  final List<PeakTime> offPeakTimes;

  
  PredictedAvailability({
    required this.lotId,
    required this.timestamp,
    required this.predictedAvailableSpots,
    required this.totalSpaces,
    required this.peakTimes,
    required this.offPeakTimes,
  });

 int get availabilityPercentage {
    return totalSpaces > 0 
    ? ((predictedAvailableSpots / totalSpaces) * 100).round() : 0;
 }

  factory PredictedAvailability.fromJson(Map<String, dynamic> json) {
    return PredictedAvailability(
      lotId: json['lotId'],
      timestamp: DateTime.parse(json['timestamp']),
      predictedAvailableSpots: json['predictedAvailableSpots'],
      totalSpaces: json['totalSpaces'],
      peakTimes: (json['peakTimes'] as List? ?? [])
          .map((e) => PeakTime.fromJson(e))
          .toList(),
      offPeakTimes: (json['offPeakTimes'] as List? ?? [])
          .map((e) => PeakTime.fromJson(e))
          .toList(),
    );
  }
}

class PeakTime {
  final String day;
  final String startTime;
  final String endTime;

  PeakTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory PeakTime.fromJson(Map<String, dynamic> json) {
    return PeakTime(
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}