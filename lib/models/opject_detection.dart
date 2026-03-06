class ObjectDetection {
  String? label;
  String? confidence;
  BoundingBox? boundingBox;

  ObjectDetection({this.label, this.confidence, this.boundingBox});

  ObjectDetection.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    confidence = json['confidence'];
    boundingBox = json['bounding_box'] != null
        ? new BoundingBox.fromJson(json['bounding_box'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['confidence'] = this.confidence;
    if (this.boundingBox != null) {
      data['bounding_box'] = this.boundingBox!.toJson();
    }
    return data;
  }
}

class BoundingBox {
  String? x1;
  String? y1;
  String? x2;
  String? y2;

  BoundingBox({this.x1, this.y1, this.x2, this.y2});

  BoundingBox.fromJson(Map<String, dynamic> json) {
    x1 = json['x1'];
    y1 = json['y1'];
    x2 = json['x2'];
    y2 = json['y2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x1'] = this.x1;
    data['y1'] = this.y1;
    data['x2'] = this.x2;
    data['y2'] = this.y2;
    return data;
  }
}
