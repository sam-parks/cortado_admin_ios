import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/ui/widgets/latte_loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBox extends StatefulWidget {
  ChatBox({Key key, this.coffeeShopId, this.peerId, this.customerName})
      : super(key: key);
  final String coffeeShopId;
  final String peerId;
  final String customerName;

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  var listMessage;
  String groupChatId;
  String id;
  String peerId;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    id = widget.coffeeShopId;
    peerId = widget.peerId;

    groupChatId = '';
    determineGroupChatId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 350,
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Container(
          child: Column(
            children: [
              buildHeader(widget.customerName),
              buildListMessage(),
              buildInput()
            ],
          ),
          color: AppColors.light,
        ),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                autofocus: true,
                onSubmitted: textEditingController.text.isEmpty
                    ? (_) {}
                    : (_) => onSendMessage(textEditingController.text),
                style: TextStyles.kDefaultSmallDarkTextStyle,
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                      fontFamily: kFontFamilyNormal,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
                color: AppColors.dark,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200], width: 0.5)),
        color: AppColors.light,
      ),
    );
  }

  determineGroupChatId() async {
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    setState(() {});
  }

  void onSendMessage(String content, [CoffeeShop coffeeShop]) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('coffee_shops')
          .doc(widget.coffeeShopId)
          .collection('messages')
          .doc(groupChatId);

      var subDocumentReference = FirebaseFirestore.instance
          .collection('coffee_shops')
          .doc(widget.coffeeShopId)
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        if (coffeeShop != null) {
          transaction.set(
            documentReference,
            {'id': groupChatId, 'coffeeShopId': coffeeShop.id},
          );
        }

        transaction.set(
          subDocumentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Flushbar(
        icon: Icon(
          Icons.error_outline,
          color: AppColors.light,
        ),
        message: 'Nothing to send',
        duration: Duration(seconds: 3),
        isDismissible: true,
        flushbarStyle: FlushbarStyle.FLOATING,
        backgroundColor: AppColors.dark,
      )..show(context);
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: LatteLoader())
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('coffee_shops')
                  .doc(widget.coffeeShopId)
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: LatteLoader());
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildHeader(String customerName) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      color: AppColors.dark,
      width: 350,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(customerName, style: TextStyles.kDefaultLightTextStyle),
          GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.cancel,
                color: AppColors.cream,
              ))
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
            child: Text(
              document.data()['content'],
              style: TextStyle(color: AppColors.light),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: AppColors.caramel,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),

          isLastMessageRight(index)
              ? Material(
                  child: Image.asset(
                    'images/latte.png',
                    width: 35.0,
                    height: 35.0,
                    color: AppColors.caramel,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
              : Container(width: 35.0),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: Image.asset(
                          'images/latte.png',
                          width: 35.0,
                          height: 35.0,
                          color: AppColors.caramel,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: AppColors.caramel,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document.data()['timestamp']))),
                      style: TextStyle(
                          color: AppColors.caramel,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }
}
