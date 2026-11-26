class PrintRow {
  final String text;
  final int fontSize;
  final int position;
  final bool bold;

  PrintRow({
    required this.text,
    required this.fontSize,
    required this.position,
    this.bold = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": "text",
      "text": text,
      "fontSize": fontSize,
      "position": position,
      "bold": bold,
    };
  }
}

class PrintImage {
  String ?pathUrl;
  int ? width;
  int ? height;
  int ? position;

  PrintImage({this.pathUrl, this.width, this.height, this.position});

  PrintImage.fromJson(Map<String, dynamic> json) {
    pathUrl = json['pathUrl'];
    width = json['width'];
    height = json['height'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = "image";
    data['pathUrl'] = pathUrl;
    data['width'] = width;
    data['height'] = height;
    data['position'] = position;
    return data;
  }
}

class WalkPaper {
  int ?step;

  WalkPaper({this.step});

  WalkPaper.fromJson(Map<String, dynamic> json) {
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = "walkPaper";
    data['step'] = step;
    return data;
  }
}

