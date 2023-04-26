class PrintRow {
  String ?text;
  int  ?fontSize;
  int ? position;

  PrintRow({this.text, this.fontSize, this.position});

  PrintRow.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    fontSize = json['fontSize'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = "text";
    data['text'] = this.text;
    data['fontSize'] = this.fontSize;
    data['position'] = this.position;
    return data;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = "image";
    data['pathUrl'] = this.pathUrl;
    data['width'] = this.width;
    data['height'] = this.height;
    data['position'] = this.position;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = "walkPaper";
    data['step'] = this.step;
    return data;
  }
}

