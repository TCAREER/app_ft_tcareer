import 'dart:async';
import 'dart:convert';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AblyService {
  final clientOptions =
      ably.ClientOptions(key: AppConstants.ablyKey, clientId: Uuid().v4());
  // final realtime =  ably.Realtime(options: clientOptions);

  Future<void> listenAllConnectionState(
      {required Function(void) handleConnectionState}) async {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    realtime.connection.on().listen(
        (ably.ConnectionStateChange stateChange) async =>
            handleConnectionState);
  }

  Future<void> listenParticularConnectionState(
      {required Function(void) handleConnectionState}) async {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    realtime.connection.on(ably.ConnectionEvent.connected).listen(
        (ably.ConnectionStateChange stateChange) async =>
            handleConnectionState);
  }

  StreamSubscription<ably.Message> listenAllMessage(
      {required String channelName,
      required Function(ably.Message) handleChannelMessage}) {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    return channel.subscribe().listen((ably.Message message) {
      handleChannelMessage(message);
    });
  }

  StreamSubscription<ably.Message> listenMessageWithSelectedName(
      {required String channelName,
      required String eventName,
      required Function(ably.Message) handleChannelMessage}) {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    return channel
        .subscribe(name: eventName)
        .listen((ably.Message message) async => handleChannelMessage(message));
  }

  Future<void> enterPresence(
      {required String channelName, required String userId}) async {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    String data = jsonEncode({"userId": userId, "status": "online"});
    await channel.presence.enter(data);
  }

  Future<void> leavePresence(
      {required String channelName, required String userId}) async {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    String data = jsonEncode({
      "userId": userId,
      "status": "offline",
      "leavedAt": DateTime.now().toIso8601String()
    });
    await channel.presence.leave(data);
  }

  StreamSubscription<ably.PresenceMessage> listenPresence(
      {required String channelName,
      required Function(ably.PresenceMessage) handleChannelPresence}) {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    return channel.presence
        .subscribe()
        .listen((ably.PresenceMessage presenceMessage) {
      handleChannelPresence(presenceMessage);
    });
  }

  Future<void> publishMessage({
    required String channelName,
    required String name,
    required Object data,
  }) async {
    ably.Realtime realtime = ably.Realtime(options: clientOptions);
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    await channel.publish(name: name, data: data);
  }
}

final ablyServiceProvider = Provider<AblyService>((ref) => AblyService());
