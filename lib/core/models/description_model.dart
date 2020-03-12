class DescriptionModel {
  DescriptionModel({
    this.category,
    this.description
  });

  String category;
  String description;

  factory DescriptionModel.fromJson(Map<String, dynamic> json) => DescriptionModel(
    category: json['category'],
    description: json['description']
  );
}