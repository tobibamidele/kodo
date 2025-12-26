enum StoryType { text, audio, video }

class Story {
  final String userId; // User who posted the story
  final String username;
  final String pfpUrl;
  final StoryType type;
  final String? text; // If a text story
  final String? mediaUrl; // For media based stories
  final DateTime createdAt;

  Story({
    required this.userId,
    required this.username,
    required this.type,
    required this.pfpUrl,
    this.text,
    this.mediaUrl,
    required this.createdAt,
  });

  factory Story.fromMap(Map<String, dynamic> data) {
    return Story(
      userId: data['userId'],
      username: data['username'],
      type: data['type'],
      pfpUrl: data['pfpUrl'],
      text: data['text'],
      mediaUrl: data['mediaUrl'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'type': type.name,
      'pfpUrl': pfpUrl,
      'text': text,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
