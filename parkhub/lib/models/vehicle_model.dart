class VehicleModel{
    final String id;
    final String plateNumber;
    final String label;
    final String userId;

    VehicleModel({
        required this.id,
        required this.plateNumber,
        required this.label,
        required this.userId
    });

    factory VehicleModel.fromMap(Map<String, dynamic> map, String id) {
        return VehicleModel(
            id: id,
            plateNumber: map['plateNumber'] ?? '',
            label: map['label'] ?? '',
            userId: map['userId'] ?? '',
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'plateNumber': plateNumber,
            'label': label,
            'userId': userId,
        };
    }
}