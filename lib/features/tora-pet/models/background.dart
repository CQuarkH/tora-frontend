class Background {
  final String id;
  final String path;
  final String name;

  Background(this.id, this.path, this.name);
}

// Lista de fondos disponibles
final List<Background> availableBackgrounds = [
  Background('none', '', 'Fondo Neutro'),
  Background('school', 'assets/images/backgrounds/school.png', 'Escuela'),
  Background('room', 'assets/images/backgrounds/room.png', 'Habitación'),
  Background('jungle', 'assets/images/backgrounds/jungle.png', 'Selva'),
];