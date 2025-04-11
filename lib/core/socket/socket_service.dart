import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal();

  void connect() {
    socket = IO.io(
        'wss://9852-2001-ee0-4a6c-e230-3961-45a6-98aa-ab19.ngrok-free.app',
        IO.OptionBuilder()
            .setTransports(['websocket']) // Set transport to WebSocket
            .disableAutoConnect() // Prevent auto-connection
            .build());

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.onError((data) {
      print('Socket error: $data');
    });
  }

  void sendMessage(String event, dynamic message) {
    socket.emit(event, message);
  }

  void listenToMessages(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void disconnect() {
    socket.disconnect();
  }
}
