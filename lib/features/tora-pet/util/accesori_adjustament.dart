class HatAdjustment {
  final double widthPercentage;
  final double leftPercentage;
  final double topPercentage;

  HatAdjustment({
    required this.widthPercentage,
    required this.leftPercentage,
    required this.topPercentage,
  });
}

// Clase de ajuste para Lentes
class GlassesAdjustment {
  final double widthPercentage;
  final double leftPercentage;
  final double topPercentage;

  GlassesAdjustment({
    required this.widthPercentage,
    required this.leftPercentage,
    required this.topPercentage,
  });
}




// Ajustes específicos por sombrero
final Map<String, HatAdjustment> hatAdjustments = {
  'pirata': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'santa': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'andaluz': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'sombrero_de_paja': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.04,
  ),
  'sombrero_de_copa': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.08,
  ),
};



// Ajustes específicos para los lentes
final Map<String, GlassesAdjustment> glassesAdjustments = {
  'negros': GlassesAdjustment(
    widthPercentage: 0.35,
    leftPercentage: 0.325,
    topPercentage: 0.19,
  ),
};