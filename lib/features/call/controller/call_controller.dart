import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vidchat/features/auth/controller/auth_controller.dart';
import 'package:vidchat/features/call/repository/call_repository.dart';
import 'package:vidchat/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;//used to interact with the Firestore database to perform CRUD operations related to calls.
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
  // stream of DocumentSnapshot representing the call data from the Firestore
  // database. It is used to listen for incoming call requests or updates.

  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePic, bool isGroupChat) {
    // makes a call by creating two Call objects, one for the sender and one for
    // the receiver, and passing them to the callRepository to initiate the call
    // in the Firestore database. It takes the BuildContext of the UI,
    // receiver's name, receiver's UID, receiver's profile picture, and a
    // boolean flag indicating if it's a group chat as parameters.
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(senderCallData, context, recieverCallData);
      } else {
        callRepository.makeCall(senderCallData, context, recieverCallData);
      }
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}
/*
 uses the Firebase Cloud Firestore and Firebase Authentication packages to
 implement a call functionality. It defines a CallController class that acts as
 a bridge between the UI and the Firebase Firestore database to handle making
 and ending calls.
 */