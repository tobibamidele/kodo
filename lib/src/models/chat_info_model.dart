/// This class contains top level info for each chat
/// It is NOT going to be pushed to firebase, purely client-side
class ChatInfo {
  String id;
  bool isLocked;
  bool isArchived;

  ChatInfo({required this.id, this.isLocked = false, this.isArchived = false});

  factory ChatInfo.fromMap(Map<String, dynamic> data) {
    return ChatInfo(
      id: data['id'],
      isLocked: data['isLocked'],
      isArchived: data['isArchived'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'isLocked': isLocked, 'isArchived': isArchived};
  }
}
