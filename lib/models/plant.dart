import 'package:plantyze/models/plant_image.dart';
import 'package:plantyze/models/taxonomic_data.dart';

/// Enhanced Plant model that fully supports PlantNet API response structure
class Plant {
  // Core identification data
  final double score; // Confidence score from API (0.0 to 1.0)
  
  // Species information
  final String scientificNameWithoutAuthor;
  final String? scientificNameAuthorship;
  final List<String> commonNames;
  final Genus? genus;
  final Family family;
  
  // External database references
  final GbifData? gbif;
  final PowoData? powo;
  final IucnData? iucn;
  
  // Images associated with this plant
  final List<PlantImage> images;
  
  // Additional metadata
  final String? wiki; // Wikipedia link if available
  
  Plant({
    required this.score,
    required this.scientificNameWithoutAuthor,
    this.scientificNameAuthorship,
    required this.commonNames,
    this.genus,
    required this.family,
    this.gbif,
    this.powo,
    this.iucn,
    required this.images,
    this.wiki,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>? ?? {};
    
    // Parse common names
    List<String> commonNames = [];
    if (species['commonNames'] != null) {
      final names = species['commonNames'] as List<dynamic>?;
      commonNames = names?.map((name) => name.toString()).toList() ?? [];
    }
    
    // Parse images
    List<PlantImage> images = [];
    if (json['images'] != null) {
      final imageList = json['images'] as List<dynamic>?;
      images = imageList?.map((img) => PlantImage.fromJson(img as Map<String, dynamic>)).toList() ?? [];
    }
    
    return Plant(
      score: json['score'] != null ? (json['score'] as num).toDouble() : 0.0,
      scientificNameWithoutAuthor: species['scientificNameWithoutAuthor']?.toString() ?? '',
      scientificNameAuthorship: species['scientificNameAuthorship']?.toString(),
      commonNames: commonNames,
      genus: species['genus'] != null ? Genus.fromJson(species['genus'] as Map<String, dynamic>) : null,
      family: species['family'] != null ? Family.fromJson(species['family'] as Map<String, dynamic>) : const Family(scientificNameWithoutAuthor: ''),
      gbif: json['gbif'] != null ? GbifData.fromJson(json['gbif'] as Map<String, dynamic>) : null,
      powo: json['powo'] != null ? PowoData.fromJson(json['powo'] as Map<String, dynamic>) : null,
      iucn: json['iucn'] != null ? IucnData.fromJson(json['iucn'] as Map<String, dynamic>) : null,
      images: images,
      wiki: json['wiki']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'species': {
        'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
        if (scientificNameAuthorship != null) 'scientificNameAuthorship': scientificNameAuthorship,
        'commonNames': commonNames,
        if (genus != null) 'genus': genus!.toJson(),
        'family': family.toJson(),
      },
      if (gbif != null) 'gbif': gbif!.toJson(),
      if (powo != null) 'powo': powo!.toJson(),
      if (iucn != null) 'iucn': iucn!.toJson(),
      'images': images.map((img) => img.toJson()).toList(),
      if (wiki != null) 'wiki': wiki,
    };
  }
  
  // Convenience getters for backward compatibility and UI
  
  /// Returns the primary common name or scientific name if no common names
  String get commonName {
    return commonNames.isNotEmpty ? commonNames.first : scientificNameWithoutAuthor;
  }
  
  /// Returns the scientific name (same as scientificNameWithoutAuthor for compatibility)
  String get scientificName => scientificNameWithoutAuthor;
  
  /// Returns the family name for backward compatibility
  String get familyName => family.scientificNameWithoutAuthor;
  
  /// Returns the probability (same as score for backward compatibility)
  double get probability => score;
  
  /// Returns the primary image URL or empty string
  String get imageUrl {
    return images.isNotEmpty ? images.first.url : '';
  }
  
  /// Returns list of additional image URLs
  List<String> get similarImages {
    return images.skip(1).map((img) => img.url).toList();
  }
  
  /// Returns a unique identifier for this plant
  String get id {
    return gbif?.id ?? powo?.id ?? iucn?.id ?? scientificNameWithoutAuthor.hashCode.toString();
  }
  
  /// Returns a description based on available data
  String get description {
    List<String> parts = [];
    
    if (iucn != null && iucn!.category != null) {
      parts.add('Conservation status: ${iucn!.conservationStatus}');
    }
    
    if (genus != null) {
      parts.add('Genus: ${genus!.scientificNameWithoutAuthor}');
    }
    
    parts.add('Family: ${family.scientificNameWithoutAuthor}');
    
    if (parts.isEmpty) {
      return 'No additional information available.';
    }
    
    return parts.join('\n');
  }
  
  @override
  String toString() {
    return 'Plant(scientificName: $scientificNameWithoutAuthor, commonName: $commonName, score: $score)';
  }
}
