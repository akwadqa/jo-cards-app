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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = "qrcode";
    data['text'] = this.text;
    data['width'] = this.width;
    data['height'] = this.height;
    data['position'] = this.position;
    return data;
  }
}

