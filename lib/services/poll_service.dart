import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_time_poll_app/models/poll.dart';

class PollService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'polls';

  Stream<List<Poll>> getPolls() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Poll.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<Poll> getPoll(String pollId) {
    return _firestore.collection(_collection).doc(pollId).snapshots().map((doc) {
      return Poll.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<void> createPoll(String title, List<String> options) async {
    final votes = List<int>.filled(options.length, 0);

    await _firestore.collection(_collection).add({
      'title': title,
      'options': options,
      'votes': votes,
    });
  }

  Future<void> vote(String pollId, int optionIndex) async {
    final docRef = _firestore.collection(_collection).doc(pollId);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception('Poll does not exist!');
      }

      final poll = Poll.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
      final updatedVotes = List<int>.from(poll.votes);
      updatedVotes[optionIndex] = updatedVotes[optionIndex] + 1;

      transaction.update(docRef, {'votes': updatedVotes});
    });
  }
}