class Plant {
  final String id;
  final String scientificName;
  final String commonName;
  final String family;
  final double probability;
  final String imageUrl; // Will be empty (not available in response)
  final List<String> similarImages; // Will be empty (not available in response)
  final String description;

  Plant({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.family,
    required this.probability,
    required this.imageUrl,
    required this.similarImages,
    this.description = '',
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>? ?? {};
    final gbif = json['gbif'] as Map<String, dynamic>? ?? {};

    return Plant(
      id: gbif['id']?.toString() ?? '', // Extract from nested gbif.id
      scientificName: species['scientificNameWithoutAuthor'] ?? '',
      commonName:
          species['commonNames']?.isNotEmpty == true
              ? species['commonNames'][0]
              : species['scientificNameWithoutAuthor'] ?? '',
      family: species['family']?['scientificNameWithoutAuthor'] ?? '',
      probability:
          json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      imageUrl: '', // Not available in the response (query.images is separate)
      similarImages: [], // Not available in the response
      description: '', // Not available in the response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scientificName': scientificName,
      'commonName': commonName,
      'family': family,
      'probability': probability,
      'imageUrl': imageUrl,
      'similarImages': similarImages,
      'description': description,
    };
  }
}
