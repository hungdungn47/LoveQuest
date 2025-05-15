import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;
  bool isConnected = false;

  SocketService._internal();
  Function()? _onConnectCallback;

  void setOnConnect(Function() callback) {
    _onConnectCallback = callback;
  }

  final Set<String> _registeredEvents = {};

  void listenToMessages(String event, Function(dynamic) callback) {
    if (_registeredEvents.contains(event)) return;

    print('Listening to messages: $event');
    socket.on(event, callback);
    _registeredEvents.add(event);
  }


  Future<bool> connect() async {
    try {
      if (isConnected) {
        print('Already connected to socket server.');
        return true;
      }
      print('Attempting to connect to socket server...');
      socket = IO.io(
        'ws://192.168.1.4:3000',
        // 'wss://95dd-2001-ee0-4a6d-45b0-9d5e-2096-bf2a-cbe.ngrok-free.app',
        //   'ws://10.0',
          IO.OptionBuilder()
              .setTransports(['websocket']) // Set transport to WebSocket
              .disableAutoConnect() // Prevent auto-connection
              .build());

      socket.connect();

      socket.onConnect((_) {
        if (!isConnected) {
          print('Connected to socket server successfully');
          isConnected = true;

          _onConnectCallback?.call();
        } else {
          print('Already marked as connected, skipping re-register.');
        }
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

  void disconnect() {
    if (isConnected) {
      print('Disconnecting from socket server');
      socket.clearListeners(); // clears all listeners
      socket.disconnect();
      isConnected = false;
      _registeredEvents.clear(); // if you used event tracking
    }
  }
}