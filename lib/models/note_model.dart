class NoteModel {
  late int id;
  late String title;
  late String text;
  // late DateTime? createdTime;

  NoteModel(
      {required this.id,
      required this.title,
      required this.text,
      // this.createdTime
      });

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    // createdTime = json['createdTime'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        // 'createdTime': createdTime,
      };
}
