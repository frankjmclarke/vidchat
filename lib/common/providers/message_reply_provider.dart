import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidchat/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.isMe, this.messageEnum);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
/*
 defines a data model (MessageReply) and a state provider (messageReplyProvider)
 that can be used in a Flutter application for managing and accessing the state
 of MessageReply objects across different parts of the app
 */
