class Exercise {
  final String name;
  final String category;
  final String equipment;
  final bool isCompound;
  final bool isUserCreated;
  final String id;

  Exercise({
    this.name = "",
    this.category = "",
    this.equipment = "",
    this.isCompound = false,
    this.isUserCreated = false,
    this.id = "",
  });

  Map<String, dynamic> toJSON() {
    if (id == "") {
      return {
        "name": name,
        "category": category,
        "equipment": equipment,
        "isCompound": isCompound,
        "isUserCreated": isUserCreated,
      };
    } else {
      return {
        "exercise_id": id,
        "name": name,
        "category": category,
        "equipment": equipment,
        "isCompound": isCompound,
        "isUserCreated": isUserCreated,
      };
    }
  }
}
