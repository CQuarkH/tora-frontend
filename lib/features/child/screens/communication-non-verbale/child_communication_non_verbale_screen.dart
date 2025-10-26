import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:tora_frontend/features/child/screens/communication-non-verbale/widgets/category_section.dart';
import 'dart:convert';


class ChildCommunicationNonVerbaleScreen extends HookWidget {
  const ChildCommunicationNonVerbaleScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchCategory(String category) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.11:3000/pictograms/$category'),


    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final filtered = data
          .where((element) => element['imageUrl'] != null)
          .toList();
      return filtered.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar pictogramas de $category');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPhrase = useState<String?>(null);
    final activeIndex = useState<int?>(null);
    final scrollController = useScrollController();

    final categories = [
      {
        'name': '😊 Emociones',
        'key': 'emociones',
        'color': const Color(0xFFFFE8D6),
      },
      {
        'name': '🤸 Acciones',
        'key': 'acciones',
        'color': const Color(0xFFD6EAF8),
      },
      {
        'name': '💬 Sociales',
        'key': 'sociales',
        'color': const Color(0xFFE8DAEF),
      },
      {
        'name': '🌿 Regulación',
        'key': 'regulacion',
        'color': const Color(0xFFD5F5E3),
      },
    ];

    final sectionKeys = {for (final cat in categories) cat['key']: GlobalKey()};

    // 🔹 Cargar solo una vez
    final futureData = useMemoized(() => _loadAll(categories));
    final snapshot = useFuture(futureData);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Barra superior (máximo 3 botones por fila)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final double itemWidth =
                      (maxWidth - 32) / 3; // máximo 3 por fila con margen

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      for (int i = 0; i < categories.length; i++)
                        GestureDetector(
                          onTap: () {
                            activeIndex.value = i;
                            final ctx = sectionKeys[categories[i]['key']]
                                ?.currentContext;
                            if (ctx != null) {
                              Scrollable.ensureVisible(
                                ctx,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: itemWidth, // 🔹 ancho adaptativo
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: activeIndex.value == i
                                  ? (categories[i]['color'] as Color)
                                        .withOpacity(0.85)
                                  : (categories[i]['color'] as Color),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: activeIndex.value == i
                                    ? Colors.orangeAccent
                                    : (categories[i]['color'] as Color),
                                width: 1.5,
                              ),
                              boxShadow: activeIndex.value == i
                                  ? [
                                      BoxShadow(
                                        color: Colors.orangeAccent.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                categories[i]['name'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // 🔹 Contenido
            Expanded(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                  ? Center(child: Text('Error: ${snapshot.error}'))
                  : NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        key: const PageStorageKey('communication_scroll'),
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final cat in categories)
                              if (snapshot.data!.containsKey(cat['key']))
                                CategorySection(
                                  key: sectionKeys[cat['key']],
                                  title: cat['name'] as String,
                                  color: cat['color'] as Color,
                                  items: snapshot.data![cat['key']]!,
                                  selectedPhrase: selectedPhrase,
                                ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadAll(
    List<Map<String, dynamic>> categories,
  ) async {
    final results = await Future.wait(
      categories.map((cat) async {
        final items = await fetchCategory(cat['key'] as String);
        return MapEntry(cat['key'] as String, items);
      }),
    );
    return Map.fromEntries(results);
  }
}
