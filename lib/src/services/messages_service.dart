import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/message.dart';

class MessagesService {
  final FirebaseFirestore _firestore;
  MessagesService(this._firestore);

  CollectionReference get _messagesCollection =>
      _firestore.collection('messages');

  Future<List<Message>> getConversation(String convoId) async {
    List<Message> conversation = [];
    QuerySnapshot convoSnapshot =
        await _messagesCollection.doc(convoId).collection(convoId).get();
    convoSnapshot.docs.forEach((messageSnap) =>
        conversation.add(Message.fromSnap(messageSnap.data())));
    return conversation;
  }

  Stream<List<Message>> coffeeShopConversations() async* {
    var conversationsQuery = await _messagesCollection.get();
    var conversationSnapshots = conversationsQuery.docs;

    for (var snapshot in conversationSnapshots) {
      print(snapshot.id);
      List<Message> conversation = await getConversation(snapshot.id);
      yield conversation;
    }
    return;
  }
}
