import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;
  bool isConnected = false;

  SocketService._internal();

  Future<bool> connect() async {
    try {
      print('Attempting to connect to socket server...');
      socket = IO.io(
          // 'ws://10.0.2.2:3000',
          'wss://6f08-14-191-138-195.ngrok-free.app',
          IO.OptionBuilder()
              .setTransports(['websocket']) // Set transport to WebSocket
              .disableAutoConnect() // Prevent auto-connection
              .build());

      socket.connect();

      socket.onConnect((_) {
        print('Connected to socket server successfully');
        isConnected = true;
        sendMessage('register', {'userId': "userA"});
        sendMessage('online', {
          "userId": "456",
          "gender": "MALE"
        });
      });

      socket.onDisconnect((_) {
        print('Disconnected from socket server');
        isConnected = false;
      });

      socket.onError((data) {
        print('Socket error: $data');
        isConnected = false;
      });

      // Wait for connection with timeout
      int attempts = 0;
      while (!isConnected && attempts < 5) {
        await Future.delayed(const Duration(seconds: 1));
        attempts++;
      }

      if (!isConnected) {
        print('Failed to connect to socket server after 5 attempts');
        return false;
      }

      return true;
    } catch (e) {
      print('Error connecting to socket server: $e');
      return false;
    }
  }

  void sendMessage(String event, dynamic message) {
    if (!isConnected) {
      print('Cannot send message: Socket not connected');
      return;
    }
    print('Sending message: $event');
    socket.emit(event, message);
  }

  void listenToMessages(String event, Function(dynamic) callback) {
    print('Listening to messages: $event');
    socket.on(event, callback);
  }

  void disconnect() {
    if (isConnected) {
      print('Disconnecting from socket server');
      socket.disconnect();
      isConnected = false;
    }
  }
}
