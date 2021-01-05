class Exercise {
  int id;
  String name;
  String category;
  String equipment;
  int isUserCreated;

  Exercise({
    this.id,
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.isUserCreated = 0,
  });

  Exercise fromJSON(Map<String, dynamic> exercise) {
    return new Exercise(
      id: exercise['id'] ?? "",
      name: exercise['name'] ?? "",
      category: exercise['category'] ?? "",
      equipment: exercise['equipment'] ?? "",
      isUserCreated: exercise['isUserCreated'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name ?? "",
      'category': category ?? "",
      'equipment': equipment ?? "",
      'isUserCreated': isUserCreated ?? 0,
    };
  }
}
