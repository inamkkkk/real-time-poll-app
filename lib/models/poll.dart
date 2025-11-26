class Poll {
  final String id;
  final String title;
  final List<String> options;
  final List<int> votes;

  Poll({
    required this.id,
    required this.title,
    required this.options,
    required this.votes,
  });

  factory Poll.fromJson(Map<String, dynamic> json, String id) {
    return Poll(
      id: id,
      title: json['title'],
      options: List<String>.from(json['options']),
      votes: List<int>.from(json['votes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'options': options,
      'votes': votes,
    };
  }
}