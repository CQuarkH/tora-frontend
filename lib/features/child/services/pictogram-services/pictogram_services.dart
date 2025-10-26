import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchEmociones() async {
  final response = await http.get(Uri.parse('http://localhost:3000/pictograms/emociones'));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
   
    return data.map((e) => e as Map<String, dynamic>).toList();
  } else {
    throw Exception('Error al cargar pictogramas: ${response.statusCode}');
  }
}
