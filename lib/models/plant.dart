class Plant {
  final String scientificName;
  final List<String> commonNames;
  final String family;
  final double score;
  final List<String> images;

  Plant({
    required this.scientificName,
    required this.commonNames,
    required this.family,
    required this.score,
    required this.images,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>? ?? {};

    List<String> commonNames = [];
    if (species['commonNames'] != null) {
      final names = species['commonNames'] as List<dynamic>?;
      commonNames = names?.map((name) => name.toString()).toList() ?? [];
    }

    List<String> images = [];
    if (json['images'] != null) {
      final imageList = json['images'] as List<dynamic>?;
      images = imageList?.map((img) => img['url']?.toString() ?? '').where((url) => url.isNotEmpty).toList() ?? [];
    }

    final familyData = species['family'] as Map<String, dynamic>?;
    final familyName = familyData?['scientificNameWithoutAuthor']?.toString() ?? '';

    return Plant(
      scientificName: species['scientificNameWithoutAuthor']?.toString() ?? '',
      commonNames: commonNames,
      family: familyName,
      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'species': {
        'scientificNameWithoutAuthor': scientificName,
        'commonNames': commonNames,
        'family': {
          'scientificNameWithoutAuthor': family,
        },
      },
      'images': images.map((url) => {'url': url}).toList(),
    };
  }

  String get commonName {
    return commonNames.isNotEmpty ? commonNames.first : scientificName;
  }

  double get probability => score;

  String get imageUrl {
    return images.isNotEmpty ? images.first : '';
  }

  List<String> get similarImages {
    return images.skip(1).toList();
  }

  String get id {
    return scientificName.hashCode.toString();
  }

  String get description {
    return 'Family: $family';
  }

  @override
  String toString() {
    return 'Plant(scientificName: $scientificName, commonName: $commonName, score: $score)';
  }
}
