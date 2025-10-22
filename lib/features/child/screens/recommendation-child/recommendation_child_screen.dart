import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/child/models/recommendation.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/recommendation_card.dart';
import 'recommendation_detail_screen.dart';

class ChildRecommendationScreen extends StatefulWidget {
  const ChildRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<ChildRecommendationScreen> createState() =>
      _ChildRecommendationScreenState();
}

class _ChildRecommendationScreenState extends State<ChildRecommendationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecommendationItem> _filteredRecommendations = [];

  @override
  void initState() {
    super.initState();
    _filteredRecommendations = RecommendationsData.allRecommendations;
  }

  void _filterRecommendations(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredRecommendations = RecommendationsData.allRecommendations;
      } else {
        _filteredRecommendations = RecommendationsData.allRecommendations
            .where(
              (item) =>
                  item.title.toLowerCase().contains(searchText.toLowerCase()) ||
                  item.subtitle.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  void _handleRecommendationTap(RecommendationItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationDetailScreen(recommendation: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToraTheme.pureWhite,
      body: SafeArea(
        child: Column(
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
                      padding: const EdgeInsets.only(bottom: 20),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: ToraTheme.lightText),
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
