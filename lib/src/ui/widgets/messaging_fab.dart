import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cortado_admin_ios/src/bloc/auth/auth_bloc.dart';
import 'package:cortado_admin_ios/src/bloc/coffee_shop/coffee_shop_bloc.dart';
import 'package:cortado_admin_ios/src/data/coffee_shop.dart';
import 'package:cortado_admin_ios/src/ui/style.dart';
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final String userId;
  final String peerId;

  FancyFab(
    this.userId,
    this.peerId, {
    this.onPressed,
    this.tooltip,
    this.icon,
  });

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  bool showCancel = false;
  bool unseenMessage = false;
  bool cortadoMessageSent = false;
  double outerMessageBoxWidth = 0;
  double outerMessageBoxHeight = 0;
  double fabOpacity = 1;

  var listMessage;
  String groupChatId;
  String id;
  String peerId;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  expandMessageContainer() {
    isOpened = !isOpened;
    if (isOpened)
      setState(() {
        unseenMessage = false;
        outerMessageBoxWidth = 300;
        outerMessageBoxHeight = 375;
        fabOpacity = 0;
      });
    else {
      setState(() {
        showCancel = false;
        outerMessageBoxWidth = 0;
        outerMessageBoxHeight = 0;
        fabOpacity = 1;
      });
    }
  }

  Widget toggle(bool isFullAdmin) {
    return Visibility(
      child: Container(
        child: AnimatedOpacity(
          opacity: fabOpacity,
          duration: Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  FloatingActionButton(
                      backgroundColor: AppColors.caramel,
                      onPressed: () => expandMessageContainer(),
                      child: Icon(
                        Icons.question_answer,
                        color: AppColors.light,
                      )),
                  Visibility(
                    visible: unseenMessage,
                    child: Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    CoffeeShopState coffeeShopState =
        BlocProvider.of<CoffeeShopBloc>(context).state;

    return Container(
      height: 400,
      width: 350,
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              right: 40,
              child: toggle(authState.user.userType == UserType.superUser)),
          Positioned(
            bottom: 0,
            right: 40,
            child: WillPopScope(
              onWillPop: onBackPress,
              child: Stack(
                children: [
                  AnimatedContainer(
                    curve: Curves.ease,
                    onEnd: () {
                      if (isOpened) {
                        setState(() {
                          showCancel = true;
                        });
                      }
                    },
                    child: Visibility(
                      visible: showCancel,
                      child: Column(
                        children: [
                          buildHeader(),
                          buildListMessage(
                              authState.user.userType == UserType.superUser),
                          buildInput(
                              authState.user.userType == UserType.superUser,
                              coffeeShopState.coffeeShop)
                        ],
                      ),
                    ),
                    color: AppColors.caramel,
                    height: outerMessageBoxHeight,
                    width: outerMessageBoxWidth,
                    duration: Duration(milliseconds: 1000),
                  ),
                  Positioned(
                    top: -5,
                    right: 0,
                    child: Visibility(
                        visible: showCancel,
                        child: IconButton(
                            icon: Icon(Icons.cancel, color: AppColors.dark),
                            onPressed: () => expandMessageContainer())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.light,
          border: Border.all(color: AppColors.dark, width: 1)),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      width: 350,
      height: 40,
      child: Text("Cortado Chat Box", style: TextStyles.kDefaultDarkTextStyle),
    );
  }

  Widget buildInput(bool isFullAdmin, CoffeeShop coffeeShop) {
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
                            textEditingController.text, coffeeShop)
                        : (_) => onSendMessage(
                            textEditingController.text, coffeeShop),
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
              color: AppColors.light,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await onSendMessage(textEditingController.text, coffeeShop);
                },
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
          color: AppColors.light,
          border: Border.all(color: AppColors.dark, width: 1)),
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

  onSendMessage(String content, CoffeeShop coffeeShop) {
    print(content);
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

      if (!cortadoMessageSent) {
        sendCortadoMessage();
        setState(() {
          cortadoMessageSent = true;
        });
      }

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

  sendCortadoMessage() {
    var subDocumentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now()
            .add(Duration(seconds: 1))
            .millisecondsSinceEpoch
            .toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        subDocumentReference,
        {
          'idFrom': peerId,
          'idTo': id,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content':
              "A Cortado rep will respond to your message as soon as possible. Hold tight!",
        },
      );
    });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget buildListMessage(bool isFullAdmin) {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.light)))
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
                color: AppColors.light,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
          Material(
            child: Image.asset(
              'images/coffee_shop.png',
              width: 35.0,
              height: 35.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
            clipBehavior: Clip.hardEdge,
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
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'images/coffee_bean.png',
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.black,
                                ),
                              ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
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
                      color: AppColors.cream,
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
                          color: AppColors.light,
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
