class PrintQRCode {
  String ?text;
  int ? width;
  int ? height;
  int ? position;

  PrintQRCode({this.text, this.width, this.height, this.position});

  PrintQRCode.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    width = json['width'];
    height = json['height'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = "qrcode";
    data['text'] = text;
    data['width'] = width;
    data['height'] = height;
    data['position'] = position;
    return data;
  }
}

