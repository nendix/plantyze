/// GBIF (Global Biodiversity Information Facility) data
class GbifData {
  final String id;
  final String? scientificName;
  final String? rank;
  
  const GbifData({
    required this.id,
    this.scientificName,
    this.rank,
  });
  
  factory GbifData.fromJson(Map<String, dynamic> json) {
    return GbifData(
      id: json['id']?.toString() ?? '',
      scientificName: json['scientificName']?.toString(),
      rank: json['rank']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (scientificName != null) 'scientificName': scientificName,
      if (rank != null) 'rank': rank,
    };
  }
}

/// POWO (Plants of the World Online) data
class PowoData {
  final String id;
  final String? scientificName;
  final String? rank;
  
  const PowoData({
    required this.id,
    this.scientificName,
    this.rank,
  });
  
  factory PowoData.fromJson(Map<String, dynamic> json) {
    return PowoData(
      id: json['id']?.toString() ?? '',
      scientificName: json['scientificName']?.toString(),
      rank: json['rank']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (scientificName != null) 'scientificName': scientificName,
      if (rank != null) 'rank': rank,
    };
  }
}

/// IUCN (International Union for Conservation of Nature) conservation status data
class IucnData {
  final String id;
  final String? category; // e.g., "LC" (Least Concern), "EN" (Endangered), etc.
  final String? scientificName;
  
  const IucnData({
    required this.id,
    this.category,
    this.scientificName,
  });
  
  factory IucnData.fromJson(Map<String, dynamic> json) {
    return IucnData(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString(),
      scientificName: json['scientificName']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (category != null) 'category': category,
      if (scientificName != null) 'scientificName': scientificName,
    };
  }
  
  /// Returns user-friendly conservation status description
  String get conservationStatus {
    switch (category?.toUpperCase()) {
      case 'LC':
        return 'Least Concern';
      case 'NT':
        return 'Near Threatened';
      case 'VU':
        return 'Vulnerable';
      case 'EN':
        return 'Endangered';
      case 'CR':
        return 'Critically Endangered';
      case 'EW':
        return 'Extinct in the Wild';
      case 'EX':
        return 'Extinct';
      case 'DD':
        return 'Data Deficient';
      case 'NE':
        return 'Not Evaluated';
      default:
        return category ?? 'Unknown';
    }
  }
  
  /// Returns true if the species is threatened (VU, EN, CR)
  bool get isThreatened {
    return ['VU', 'EN', 'CR'].contains(category?.toUpperCase());
  }
}

/// Family taxonomic information
class Family {
  final String scientificNameWithoutAuthor;
  final String? scientificNameAuthorship;
  
  const Family({
    required this.scientificNameWithoutAuthor,
    this.scientificNameAuthorship,
  });
  
  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      scientificNameWithoutAuthor: json['scientificNameWithoutAuthor']?.toString() ?? '',
      scientificNameAuthorship: json['scientificNameAuthorship']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
      if (scientificNameAuthorship != null) 'scientificNameAuthorship': scientificNameAuthorship,
    };
  }
}

/// Genus taxonomic information
class Genus {
  final String scientificNameWithoutAuthor;
  final String? scientificNameAuthorship;
  
  const Genus({
    required this.scientificNameWithoutAuthor,
    this.scientificNameAuthorship,
  });
  
  factory Genus.fromJson(Map<String, dynamic> json) {
    return Genus(
      scientificNameWithoutAuthor: json['scientificNameWithoutAuthor']?.toString() ?? '',
      scientificNameAuthorship: json['scientificNameAuthorship']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'scientificNameWithoutAuthor': scientificNameWithoutAuthor,
      if (scientificNameAuthorship != null) 'scientificNameAuthorship': scientificNameAuthorship,
    };
  }
}