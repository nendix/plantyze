class Plant {
  final String id;
  final String scientificName;
  final String commonName;
  final String family;
  final double probability;
  final String imageUrl;
  final List<String> similarImages;
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
    List<String> similarImagesUrls = [];
    if (json['images'] != null) {
      similarImagesUrls =
          (json['images'] as List<dynamic>)
              .map((img) => img['url'].toString())
              .toList();
    }

    return Plant(
      id: json['gbif']?.toString() ?? '',
      scientificName: json['scientificName'] ?? '',
      commonName:
          json['commonNames']?.isNotEmpty == true
              ? json['commonNames'][0]
              : json['scientificName'] ?? '',
      family:
          json['family'] != null ? json['family']['scientificName'] ?? '' : '',
      probability:
          json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      imageUrl:
          json['images']?.isNotEmpty == true ? json['images'][0]['url'] : '',
      similarImages: similarImagesUrls,
      description: json['description'] ?? '',
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
