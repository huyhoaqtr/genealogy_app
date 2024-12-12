import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../storage/storage_manager.dart';

class SocketClientManager {
  // Singleton instance
  static final SocketClientManager _instance = SocketClientManager._internal();

  // Private constructor
  SocketClientManager._internal();

  factory SocketClientManager() {
    return _instance;
  }

  late IO.Socket _socket;

  // Method to initialize the socket connection
  void initialize() {
    _socket = IO.io(
      dotenv.env['SOCKET_API'] ?? "https://default.example.com",
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket
          .enableAutoConnect() // Automatically connect on initialization
          .build(),
    );

    // Listen for connection events
    _socket.onConnect((_) async {
      final myInfo = await StorageManager.getUser();
      if (myInfo == null) return;
      SocketClientManager().emit("online", myInfo.sId);
      print('Socket connected: ${_socket.id}');
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket.onError((data) {
      print('Socket error: $data');
    });

    _socket.onReconnect((attempt) {
      print('Reconnected after $attempt attempts');
    });
  }

  // Emit an event
  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  // Listen for an event
  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  // Remove an event listener
  void off(String event) {
    _socket.off(event);
  }

  // Disconnect the socket
  void disconnect() {
    _socket.disconnect();
  }

  // Reconnect the socket
  void reconnect() {
    _socket.connect();
  }
}
