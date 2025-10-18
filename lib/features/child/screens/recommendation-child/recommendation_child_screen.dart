import 'package:flutter/material.dart';
import '../../../../core/theme/tora_theme.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/recommendation_card.dart';


class ChildRecommendationScreen extends StatefulWidget {
  const ChildRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<ChildRecommendationScreen> createState() => _ChildRecommendationScreenState();
}

class _ChildRecommendationScreenState extends State<ChildRecommendationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecommendationItem> _filteredRecommendations = [];
  
  // Lista de recomendaciones
  final List<RecommendationItem> _allRecommendations = [
    RecommendationItem(
      title: "Cómo actuar en un aniversario",
      subtitle: "Paso a paso",
      icon: Icons.favorite_outline,
      cardColor: const Color(0xFFFFE6F2), // Rosa pastel
      iconColor: const Color(0xFFE91E63),
    ),
    RecommendationItem(
      title: "Técnicas de respiración",
      subtitle: "Paso a paso",
      icon: Icons.air,
      cardColor: const Color(0xFFE3F2FD), // Azul pastel
      iconColor: const Color(0xFF2196F3),
    ),
    RecommendationItem(
      title: "Organizar mi mochila",
      subtitle: "Paso a paso",
      icon: Icons.school_outlined,
      cardColor: const Color(0xFFE8F5E8), // Verde pastel
      iconColor: const Color(0xFF4CAF50),
    ),
    RecommendationItem(
      title: "Hablar con compañeros",
      subtitle: "Paso a paso",
      icon: Icons.groups_outlined,
      cardColor: const Color(0xFFF3E5F5), // Púrpura pastel
      iconColor: const Color(0xFF9C27B0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredRecommendations = _allRecommendations;
  }

  void _filterRecommendations(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredRecommendations = _allRecommendations;
      } else {
        _filteredRecommendations = _allRecommendations
            .where((item) => 
                item.title.toLowerCase().contains(searchText.toLowerCase()) ||
                item.subtitle.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleRecommendationTap(RecommendationItem item) {
    // Mostrar modal bottom sheet usando root navigator para aparecer encima de todo
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      elevation: 10,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true, // Esto hace que aparezca por encima del navbar
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: ToraTheme.pureWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ToraTheme.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Icon and title
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: item.cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.iconColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: ToraTheme.darkText,
                          ),
                        ),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ToraTheme.mediumText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Description
              const Text(
                "Esta guía te ayudará paso a paso a manejar esta situación de manera efectiva y con confianza.",
                style: TextStyle(
                  fontSize: 16,
                  color: ToraTheme.mediumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ToraTheme.lightGray, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ToraTheme.mediumText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                       
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ToraTheme.warmYellow,
                        foregroundColor: ToraTheme.darkText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Comenzar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToraTheme.pureWhite,
     
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SearchBarWidget(
                    controller: _searchController,
                    onChanged: _filterRecommendations,
                    hintText: "Buscar tema...",
                  ),
                ),
                
                // Lista de recomendaciones
                Expanded(
                  child: _filteredRecommendations.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: _filteredRecommendations.length,
                          itemBuilder: (context, index) {
                            final recommendation = _filteredRecommendations[index];
                            return RecommendationCard(
                              title: recommendation.title,
                              subtitle: recommendation.subtitle,
                              icon: recommendation.icon,
                              cardColor: recommendation.cardColor,
                              iconColor: recommendation.iconColor,
                              onTap: () => _handleRecommendationTap(recommendation),
                            );
                          },
                        ),
                ),
              ],
            ),
            
            
          ],
        ),
      ),
      
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: ToraTheme.lightText,
          ),
          const SizedBox(height: 16),
          Text(
            "No se encontraron resultados",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: ToraTheme.mediumText,
            ),
          ),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Modelo para los elementos de recomendación
class RecommendationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;

  RecommendationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
  });
}
