// lib/features/tora-pet/models/coin.dart
class Coin {
  final String? childId;
  final String? name;
  final int coins;

  const Coin({required this.coins, this.childId, this.name});

  factory Coin.fromJson(Map<String, dynamic> json) {
    final raw = json['coins'];
    final value = switch (raw) {
      int v => v,
      String s => int.tryParse(s) ?? 0,
      _ => 0,
    };
    return Coin(
      coins: value,
      childId: json['childId'] as String?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() => '$coins';
}
