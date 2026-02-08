class MemeFile {
  final int? id;
  final String path;
  final String displayName;
  final String type;
  final bool isRecent;

  MemeFile({
    this.id,
    required this.path,
    required this.displayName,
    required this.type,
    required this.isRecent,
  });

  MemeFile copyWith({
    int? id,
    String? path,
    String? displayName,
    String? type,
    bool? isRecent,
  }) {
    return MemeFile(
      id: id ?? this.id,
      path: path ?? this.path,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      isRecent: isRecent ?? this.isRecent,
    );
  }

  factory MemeFile.fromMap(Map<String, dynamic> json) {
    return MemeFile(
      id: json["id"],
      path: json["path"],
      displayName: json["displayName"],
      type: json["type"],
      isRecent: json["isRecent"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["path"] = path;
    data["displayName"] = displayName;
    data["type"] = type;
    data["isRecent"] = isRecent ? 1 : 0;
    return data;
  }
}
