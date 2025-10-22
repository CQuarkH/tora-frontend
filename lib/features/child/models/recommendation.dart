import 'package:flutter/material.dart';

class RecommendationStep {
  final int stepNumber;
  final String title;
  final String? pictogramUrl; // URL del pictograma ARASAAC
  final IconData? fallbackIcon; // Ícono de respaldo si no hay pictograma
  final String description;

  RecommendationStep({
    required this.stepNumber,
    required this.title,
    this.pictogramUrl,
    this.fallbackIcon,
    required this.description,
  });
}

class RecommendationItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final String description;
  final List<RecommendationStep> steps;
  final String successMessage;

  RecommendationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    required this.description,
    required this.steps,
    required this.successMessage,
  });
}

class RecommendationsData {
  static final List<RecommendationItem> allRecommendations = [
    // 1. Cómo actuar en un evento del colegio
    RecommendationItem(
      id: 'evento_escolar',
      title: "Cómo actuar en un evento del colegio",
      subtitle: "Paso a paso",
      icon: Icons.celebration_outlined,
      cardColor: const Color(0xFFFFE6F2),
      iconColor: const Color(0xFFE91E63),
      description:
          "Esta guía te ayudará a sentirte más cómodo y seguro durante los eventos escolares como aniversarios, actos o celebraciones.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Llegar temprano al lugar",
          fallbackIcon: Icons.directions_walk,
          description:
              "Ve temprano con tu familia o profesor. Así puedes conocer el lugar con calma y sentirte más tranquilo.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Saludar a mis compañeros",
          fallbackIcon: Icons.waving_hand,
          description:
              "Puedes saludar con la mano o decir 'hola'. No tienes que hablar mucho si no quieres.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Sentarme en mi lugar",
          fallbackIcon: Icons.event_seat,
          description:
              "Busca tu lugar y siéntate. Está bien sentarte al lado de alguien que conoces y te hace sentir seguro.",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Escuchar con atención",
          fallbackIcon: Icons.hearing,
          description:
              "Si hay mucho ruido, puedes usar tapones o auriculares. Avísale a un adulto si necesitas ayuda.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Tomar un descanso si lo necesito",
          fallbackIcon: Icons.self_improvement,
          description:
              "Si te sientes abrumado, puedes salir un momento a un lugar más tranquilo. Dile a un adulto que necesitas un descanso.",
        ),
      ],
      successMessage:
          "¡Lo hiciste muy bien! Los eventos escolares pueden ser divertidos cuando sabes cómo manejarlos.",
    ),

    // 2. Técnicas de respiración
    RecommendationItem(
      id: 'respiracion',
      title: "Técnicas de respiración",
      subtitle: "Paso a paso",
      icon: Icons.air,
      cardColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF2196F3),
      description:
          "Aprende a respirar de forma que te ayude a calmarte cuando te sientas nervioso, molesto o estresado.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Buscar un lugar tranquilo",
          fallbackIcon: Icons.chair,
          description:
              "Encuentra un lugar donde puedas sentarte cómodamente. Puede ser tu silla, el suelo o tu cama.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Poner mis manos en la pancita",
          fallbackIcon: Icons.front_hand,
          description:
              "Coloca tus manos sobre tu pancita para sentir cómo sube y baja cuando respiras.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Respirar profundo por la nariz",
          fallbackIcon: Icons.arrow_upward,
          description:
              "Inhala lentamente por la nariz contando hasta 4. Siente cómo tu pancita se llena de aire.",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Aguantar el aire un momento",
          fallbackIcon: Icons.pause_circle,
          description:
              "Mantén el aire dentro contando hasta 2. Está bien si no puedes mucho tiempo.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Soltar el aire por la boca",
          fallbackIcon: Icons.arrow_downward,
          description:
              "Suelta el aire lentamente por la boca contando hasta 4, como si soplaras una vela.",
        ),
        RecommendationStep(
          stepNumber: 6,
          title: "Repetir 5 veces",
          fallbackIcon: Icons.repeat,
          description:
              "Hazlo 5 veces seguidas. Cada vez te sentirás más calmado y relajado.",
        ),
      ],
      successMessage:
          "¡Excelente! Ahora sabes una técnica especial para calmarte cuando la necesites.",
    ),

    // 3. Organizar mi mochila
    RecommendationItem(
      id: 'organizar_mochila',
      title: "Organizar mi mochila",
      subtitle: "Paso a paso",
      icon: Icons.backpack_outlined,
      cardColor: const Color(0xFFE8F5E8),
      iconColor: const Color(0xFF4CAF50),
      description:
          "Una mochila ordenada te ayuda a encontrar tus cosas más fácil y sentirte más tranquilo en el colegio.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Vaciar toda la mochila",
          fallbackIcon: Icons.inventory_2_outlined,
          description:
              "Saca todo lo que hay dentro de tu mochila y ponlo sobre una mesa o tu cama.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Separar por categorías",
          fallbackIcon: Icons.category,
          description:
              "Agrupa las cosas similares: libros juntos, lápices juntos, colaciones juntas.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Botar basura",
          fallbackIcon: Icons.delete_outline,
          description:
              "Saca papeles viejos, envoltorios o cosas que ya no necesitas y bótalos.",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Guardar libros y cuadernos",
          fallbackIcon: Icons.menu_book,
          description:
              "Pon los libros y cuadernos en el compartimento grande. Los más pesados van al fondo.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Guardar útiles en estuche",
          fallbackIcon: Icons.draw,
          description:
              "Guarda lápices, gomas y sacapuntas en tu estuche. Así no se pierden.",
        ),
        RecommendationStep(
          stepNumber: 6,
          title: "Revisar que no falte nada",
          fallbackIcon: Icons.checklist,
          description:
              "Revisa tu horario del día siguiente y verifica que tengas todo lo necesario.",
        ),
      ],
      successMessage:
          "¡Perfecto! Tu mochila está lista y organizada para mañana.",
    ),

    // 4. Hablar con compañeros
    RecommendationItem(
      id: 'hablar_companeros',
      title: "Hablar con mis compañeros",
      subtitle: "Paso a paso",
      icon: Icons.groups_outlined,
      cardColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF9C27B0),
      description:
          "Aprende formas fáciles de empezar una conversación y hacer amigos en el colegio.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Acercarme con una sonrisa",
          fallbackIcon: Icons.sentiment_satisfied_alt,
          description:
              "Acércate a un compañero o grupo pequeño con una sonrisa amigable.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Decir 'hola' o saludar",
          fallbackIcon: Icons.waving_hand,
          description:
              "Puedes decir 'hola', '¿cómo estás?' o simplemente levantar la mano para saludar.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Hacer una pregunta simple",
          fallbackIcon: Icons.question_answer,
          description:
              "Pregunta algo fácil como '¿qué estás haciendo?' o '¿te gusta este juego?'",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Escuchar su respuesta",
          fallbackIcon: Icons.hearing,
          description:
              "Mira a la persona y escucha lo que dice. Puedes asentir con la cabeza para mostrar que entiendes.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Compartir algo sobre mí",
          fallbackIcon: Icons.person,
          description:
              "Puedes contar algo que te gusta o que hiciste. Ejemplo: 'A mí también me gusta eso'.",
        ),
        RecommendationStep(
          stepNumber: 6,
          title: "Está bien si no sale perfecto",
          fallbackIcon: Icons.thumb_up,
          description:
              "Si no sabes qué decir, está bien. Puedes intentar otro día. Lo importante es que lo intentaste.",
        ),
      ],
      successMessage:
          "¡Muy bien! Hacer amigos toma tiempo, pero cada intento cuenta.",
    ),

    // 5. Qué hacer en el recreo
    RecommendationItem(
      id: 'recreo',
      title: "Qué hacer en el recreo",
      subtitle: "Paso a paso",
      icon: Icons.sports_soccer,
      cardColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
      description:
          "El recreo puede ser divertido cuando sabes qué hacer y dónde estar. Aquí tienes algunas ideas.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Salir al patio con calma",
          fallbackIcon: Icons.directions_walk,
          description:
              "No hay apuro. Sal cuando te sientas listo, no tienes que correr.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Elegir una actividad",
          fallbackIcon: Icons.toys,
          description:
              "Puedes jugar a la pelota, caminar, leer, dibujar o simplemente observar. Todas son buenas opciones.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Buscar un lugar donde me sienta bien",
          fallbackIcon: Icons.place,
          description:
              "Si hay mucho ruido, busca un lugar más tranquilo. Está bien estar solo si lo prefieres.",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Tomar agua y un snack",
          fallbackIcon: Icons.local_drink,
          description:
              "Aprovecha para tomar agua y comer algo. Te ayudará a tener energía.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Si quiero jugar con otros",
          fallbackIcon: Icons.groups,
          description:
              "Puedes preguntar '¿puedo jugar?' Es normal si a veces dicen que no. Intenta con otro grupo.",
        ),
        RecommendationStep(
          stepNumber: 6,
          title: "Volver a clases cuando suene el timbre",
          fallbackIcon: Icons.notifications,
          description:
              "Cuando escuches el timbre o campana, es hora de volver. Camina tranquilo hacia tu sala.",
        ),
      ],
      successMessage:
          "¡Genial! El recreo es tu tiempo para descansar y hacer lo que te gusta.",
    ),

    // 6. Qué hacer en la sala de clases
    RecommendationItem(
      id: 'sala_clases',
      title: "Qué hacer en la sala de clases",
      subtitle: "Paso a paso",
      icon: Icons.school,
      cardColor: const Color(0xFFE1F5FE),
      iconColor: const Color(0xFF0288D1),
      description:
          "Aprende cómo comportarte en clases para que sea más fácil aprender y sentirte cómodo.",
      steps: [
        RecommendationStep(
          stepNumber: 1,
          title: "Entrar y sentarme en mi puesto",
          fallbackIcon: Icons.event_seat,
          description:
              "Entra con calma y siéntate en tu lugar. Deja tu mochila ordenada al lado o debajo de tu mesa.",
        ),
        RecommendationStep(
          stepNumber: 2,
          title: "Sacar mis materiales",
          fallbackIcon: Icons.folder,
          description:
              "Saca tu cuaderno, estuche y libro si los necesitas. Deja lo demás guardado.",
        ),
        RecommendationStep(
          stepNumber: 3,
          title: "Escuchar al profesor",
          fallbackIcon: Icons.hearing,
          description:
              "Mira al profesor cuando habla. Si no entiendes algo, puedes levantar la mano para preguntar.",
        ),
        RecommendationStep(
          stepNumber: 4,
          title: "Levantar la mano para hablar",
          fallbackIcon: Icons.front_hand,
          description:
              "Si quieres decir algo o hacer una pregunta, levanta tu mano y espera tu turno.",
        ),
        RecommendationStep(
          stepNumber: 5,
          title: "Si necesito un descanso",
          fallbackIcon: Icons.self_improvement,
          description:
              "Si te sientes cansado o abrumado, puedes pedirle al profesor ir al baño o tomar agua.",
        ),
        RecommendationStep(
          stepNumber: 6,
          title: "Guardar todo al terminar",
          fallbackIcon: Icons.inventory,
          description:
              "Al final de la clase, guarda tus cosas en tu mochila y deja tu puesto ordenado.",
        ),
      ],
      successMessage:
          "¡Excelente trabajo! Seguir estos pasos hace que la clase sea más fácil para todos.",
    ),
  ];
}
