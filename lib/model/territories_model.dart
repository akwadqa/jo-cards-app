class TerritoriesModel {
  final List<Message>? message;

  TerritoriesModel({
    this.message,
  });

  TerritoriesModel.fromJson(Map<String, dynamic> json)
    : message = (json['message'] as List?)?.map((dynamic e) => Message.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'message' : message?.map((e) => e.toJson()).toList()
  };
}

class Message {
  final String? name;

  Message({
    this.name,
  });

  Message.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name
  };
}