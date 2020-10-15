import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatefulWidget {
  ChatBox(
      {Key key, this.userId, this.peerId, this.coffeeShopName, this.adminName})
      : super(key: key);
  final String userId;
  final String peerId;
  final String coffeeShopName;
  final String adminName;
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
    id = widget.userId;
    peerId = widget.peerId;

    groupChatId = '';
    determineGroupChatId();
  }

  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthBloc>(context).state;
    return Container(
      height: 400,
      width: 350,
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  buildHeader(widget.coffeeShopName, widget.adminName),
                  buildListMessage(
                      authState.user.userType == UserType.superUser),
                  buildInput(authState.user.userType == UserType.superUser)
                ],
              ),
              color: AppColors.light,
            ),
            Positioned(
              top: -5,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.cancel, color: AppColors.dark),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(bool isFullAdmin) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onSubmitted: textEditingController.text.isEmpty
                    ? (_) {}
                    : isFullAdmin
                        ? (_) => onSendMessage(
                              textEditingController.text,
                            )
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

      var documentReference =
          FirebaseFirestore.instance.collection('messages').doc(groupChatId);

      var subDocumentReference = FirebaseFirestore.instance
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

  Widget buildListMessage(bool isFullAdmin) {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.caramel)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.caramel)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(
                        index, snapshot.data.documents[index], isFullAdmin),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildHeader(String coffeeShopName, String adminName) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      color: AppColors.dark,
      width: 350,
      height: 40,
      child: Text(adminName + " from " + coffeeShopName,
          style: TextStyles.kDefaultLightTextStyle),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document, bool isFullAdmin) {
    if (document.data()['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
            child: Text(
              document.data()['content'],
              style: TextStyle(color: AppColors.dark),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: AppColors.caramel,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
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
                        child: isFullAdmin
                            ? Image.asset(
                                'images/coffee_shop.png',
                                width: 35.0,
                                height: 35.0,
                                fit: BoxFit.fitWidth,
                              )
                            : Image.asset(
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
