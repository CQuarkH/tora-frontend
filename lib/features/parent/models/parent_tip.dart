import 'package:flutter/material.dart';

class ParentTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? actionText;
  final String category;

  const ParentTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.actionText,
    required this.category,
  });
}

class ParentTipsData {
  static const List<ParentTip> tips = [
    ParentTip(
      title: 'Tu bienestar también importa',
      description:
          'Cuidar de un hijo con necesidades educativas diversas puede ser demandante. Recuerda que tu bienestar emocional es fundamental para poder apoyarlo. No es egoísta dedicar tiempo para ti: es necesario.',
      icon: Icons.favorite,
      color: Color(0xFFE91E63),
      actionText: 'Dedica al menos 15 minutos diarios para ti',
      category: 'autocuidado',
    ),
    ParentTip(
      title: 'Buscar apoyo profesional está bien',
      description:
          'Asistir a terapia psicológica no es signo de debilidad, es un acto de valentía y amor hacia ti y tu familia. Un profesional puede ayudarte a procesar emociones y desarrollar estrategias de afrontamiento.',
      icon: Icons.psychology,
      color: Color(0xFF9C27B0),
      actionText: 'Considera agendar una cita con un profesional',
      category: 'apoyo',
    ),
    ParentTip(
      title: 'Está bien sentirse abrumado',
      description:
          'Sentir tristeza, frustración o agotamiento es completamente normal. Estas emociones no te hacen mal padre o madre. Permítete sentirlas sin juzgarte, y recuerda que los días difíciles no duran para siempre.',
      icon: Icons.cloud,
      color: Color(0xFF607D8B),
      actionText: 'Valida tus emociones, no las reprimas',
      category: 'emocional',
    ),
    ParentTip(
      title: 'El estrés no es culpa de tu hijo',
      description:
          'Cuando te sientas desbordado, recuerda que tu hijo no es el problema. Si necesitas un momento, está bien decir "necesito un minuto" y respirar. Nunca descargues tu frustración con él.',
      icon: Icons.warning_amber,
      color: Color(0xFFFF9800),
      actionText: 'Pausa, respira, y regresa cuando estés más calmado',
      category: 'manejo',
    ),
    ParentTip(
      title: 'Celebra los pequeños logros',
      description:
          'Cada avance, por pequeño que parezca, es un gran paso. Reconoce y celebra estos momentos: refuerzan el progreso y te recuerdan que todo esfuerzo vale la pena.',
      icon: Icons.celebration,
      color: Color(0xFFFFC107),
      actionText: 'Lleva un registro de los logros semanales',
      category: 'motivacion',
    ),
    ParentTip(
      title: 'No estás solo en esto',
      description:
          'Conecta con otros padres que viven situaciones similares. Compartir experiencias, dudas y estrategias puede ser invaluable. Hay comunidades y grupos de apoyo que entienden lo que vives.',
      icon: Icons.groups,
      color: Color(0xFF03A9F4),
      actionText: 'Busca grupos de apoyo en tu comunidad',
      category: 'comunidad',
    ),
    ParentTip(
      title: 'La perfección no existe',
      description:
          'No necesitas ser el padre o madre perfecto. Habrá días buenos y días difíciles. Lo importante es estar presente, seguir intentando y mostrarle a tu hijo que lo amas incondicionalmente.',
      icon: Icons.auto_awesome,
      color: Color(0xFF00BCD4),
      actionText: 'Sé amable contigo mismo, estás haciendo lo mejor que puedes',
      category: 'autocuidado',
    ),
    ParentTip(
      title: 'Establece límites saludables',
      description:
          'Está bien decir "no" a veces. No puedes estar disponible 24/7 para todos. Establecer límites te ayuda a prevenir el agotamiento y te permite ser más presente cuando realmente importa.',
      icon: Icons.shield,
      color: Color(0xFF4CAF50),
      actionText: 'Define momentos del día que son solo para ti',
      category: 'autocuidado',
    ),
    ParentTip(
      title: 'Pide ayuda cuando la necesites',
      description:
          'No tienes que hacerlo todo solo. Pedir ayuda a familiares, amigos o profesionales no es fracasar, es ser inteligente. Delegar tareas te permite recargar energías.',
      icon: Icons.pan_tool,
      color: Color(0xFF8BC34A),
      actionText: 'Identifica 2-3 personas en quienes puedas apoyarte',
      category: 'apoyo',
    ),
    ParentTip(
      title: 'Duerme lo suficiente',
      description:
          'El descanso no es un lujo, es una necesidad. La falta de sueño afecta tu estado de ánimo, paciencia y capacidad de tomar decisiones. Prioriza tu descanso tanto como sea posible.',
      icon: Icons.bedtime,
      color: Color(0xFF673AB7),
      actionText: 'Intenta mantener una rutina de sueño regular',
      category: 'autocuidado',
    ),
    ParentTip(
      title: 'La comunicación con tu pareja es clave',
      description:
          'Si tienes pareja, mantengan espacios de diálogo sobre cómo se sienten y cómo pueden apoyarse mutuamente. Trabajar en equipo fortalece la relación y el apoyo a su hijo.',
      icon: Icons.forum,
      color: Color(0xFFE91E63),
      actionText: 'Agenda tiempo de calidad con tu pareja semanalmente',
      category: 'familia',
    ),
    ParentTip(
      title: 'Confía en el proceso',
      description:
          'El progreso no siempre es lineal. Habrá avances y retrocesos, y eso es parte del proceso. Mantén la fe en tu hijo y en ti mismo. Cada día es una nueva oportunidad.',
      icon: Icons.trending_up,
      color: Color(0xFF009688),
      actionText: 'Reflexiona semanalmente sobre los avances logrados',
      category: 'motivacion',
    ),
  ];

  // Método para filtrar consejos por categoría si se necesita
  static List<ParentTip> getTipsByCategory(String category) {
    return tips.where((tip) => tip.category == category).toList();
  }

  // Método para obtener un consejo aleatorio
  static ParentTip getRandomTip() {
    return tips[DateTime.now().millisecondsSinceEpoch % tips.length];
  }
}
