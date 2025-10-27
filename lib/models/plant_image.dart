/// Represents an image associated with a plant identification result
class PlantImage {
  final String url;
  final String? author;
  final String? license;
  final DateTime? date;
  final String? citation;
  
  const PlantImage({
    required this.url,
    this.author,
    this.license,
    this.date,
    this.citation,
  });
  
  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      url: json['url']?.toString() ?? '',
      author: json['author']?.toString(),
      license: json['license']?.toString(),
      date: json['date'] != null 
          ? DateTime.tryParse(json['date'].toString()) 
          : null,
      citation: json['citation']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (author != null) 'author': author,
      if (license != null) 'license': license,
      if (date != null) 'date': date!.toIso8601String(),
      if (citation != null) 'citation': citation,
    };
  }
  
  @override
  String toString() {
    return 'PlantImage(url: $url, author: $author)';
  }
}