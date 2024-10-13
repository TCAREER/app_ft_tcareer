import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AblyService {
  final clientOptions = ably.ClientOptions(key: AppConstants.ablyKey);
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
