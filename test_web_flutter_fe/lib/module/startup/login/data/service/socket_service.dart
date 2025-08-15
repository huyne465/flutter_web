import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:injectable/injectable.dart';
import 'google_auth_service.dart';

@injectable
class SocketService {
  final GoogleAuthService _authService;

  SocketService(this._authService);

  IO.Socket? _socket;
  bool get isConnected => _socket?.connected ?? false;
  String? _currentRoom;
  bool _isConnecting = false; // Flag to prevent multiple connections

  // Event callbacks
  Function(Map<String, dynamic>)? onNewMessage;
  Function(Map<String, dynamic>)? onUserJoined;
  Function(Map<String, dynamic>)? onUserLeft;
  Function(Map<String, dynamic>)? onUserTyping;
  Function(Map<String, dynamic>)? onAuthSuccess;
  Function(String)? onAuthError;
  Function(Map<String, dynamic>)? onRoomJoined;
  Function(Map<String, dynamic>)? onError;
  Function()? onConnected;
  Function()? onDisconnected;

  /// Connect with authentication
  Future<void> connectAuthenticated() async {
    // Prevent multiple connections
    if (_isConnecting || (_socket != null && _socket!.connected)) {
      print('🔌 Already connecting or connected');
      return;
    }

    try {
      _isConnecting = true;
      final token = _authService.getSavedToken();

      if (token == null) {
        print('❌ No JWT token found');
        onAuthError?.call('No authentication token found');
        return;
      }

      _socket = IO.io(
        'http://localhost:8017',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .build(),
      );

      _setupListeners();
      _socket!.connect();

      // Authenticate after connection
      _socket!.emit('authenticate', {'token': token});

      print('🔌 Connecting to Socket.IO server with token...');
      _isConnecting = false;
    } catch (e) {
      print('❌ Error connecting: $e');
      onAuthError?.call('Connection failed: $e');
      _isConnecting = false;
    }
  }

  /// Connect as guest (no authentication)
  void connectGuest() {
    // Prevent multiple connections
    if (_isConnecting || (_socket != null && _socket!.connected)) {
      print('🔌 Already connecting or connected');
      return;
    }

    try {
      _isConnecting = true;

      // Disconnect existing connection to avoid multiple connections
      if (_socket != null && _socket!.connected) {
        _socket!.disconnect();
      }

      _socket = IO.io(
        'http://localhost:8017',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .build(),
      );

      _setupListeners();
      _socket!.connect();

      // Request guest access after connection with delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_socket != null && _socket!.connected) {
          _socket!.emit('guest_access');
        }
        _isConnecting = false;
      });

      print('🔌 Connecting as guest...');
    } catch (e) {
      print('❌ Error connecting as guest: $e');
      _isConnecting = false;
    }
  }

  void _setupListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.on('connect', (_) {
      print('✅ Connected to Socket.IO server: ${_socket!.id}');
      onConnected?.call();
    });

    _socket!.on('disconnect', (_) {
      print('❌ Disconnected from Socket.IO server');
      onDisconnected?.call();
    });

    _socket!.on('connect_error', (data) {
      print('❌ Connection Error: $data');
      onAuthError?.call('Connection failed');
    });

    // Authentication events
    _socket!.on('auth_success', (data) {
      print('✅ Authentication successful: $data');
      onAuthSuccess?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('auth_error', (data) {
      print('❌ Authentication error: $data');
      onAuthError?.call(data['message'] ?? 'Authentication failed');
    });

    // Guest access events
    _socket!.on('guest_access_granted', (data) {
      print('👤 Guest access granted: $data');
      onAuthSuccess?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('guest_access_denied', (data) {
      print('❌ Guest access denied: $data');
      onAuthError?.call(data['message'] ?? 'Guest access denied');
    });

    // Chat events
    _socket!.on('new_message', (data) {
      print('💬 New message: $data');
      onNewMessage?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('room_joined', (data) {
      print('🏠 Room joined: $data');
      _currentRoom = data['roomId'];
      onRoomJoined?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('user_joined', (data) {
      print('👋 User joined: $data');
      onUserJoined?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('user_left', (data) {
      print('👋 User left: $data');
      onUserLeft?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on('user_typing', (data) {
      print('⌨️ User typing: $data');
      onUserTyping?.call(Map<String, dynamic>.from(data));
    });

    // Error events
    _socket!.on('error', (data) {
      print('❌ Socket error: $data');
      onError?.call(Map<String, dynamic>.from(data));
    });

    // User status events
    _socket!.on('user_status_changed', (data) {
      print('📊 User status changed: $data');
    });

    // Ping/Pong
    _socket!.on('pong', (data) {
      print('🏓 Pong received: $data');
    });
  }

  // Authentication
  void authenticate() {
    final token = _authService.getSavedToken();
    if (token != null) {
      _socket?.emit('authenticate', {'token': token});
    }
  }

  // Join room
  void joinRoom(String roomId) {
    _socket?.emit('join_room', {'roomId': roomId});
  }

  // Send message
  void sendMessage(String roomId, String message) {
    if (_socket?.connected == true) {
      _socket!.emit('send_message', {
        'roomId': roomId,
        'message': message,
        'messageType': 'text',
      });
    }
  }

  // Typing indicators
  void startTyping(String roomId) {
    _socket?.emit('typing_start', {'roomId': roomId});
  }

  void stopTyping(String roomId) {
    _socket?.emit('typing_stop', {'roomId': roomId});
  }

  // Leave room
  void leaveRoom(String roomId) {
    _socket?.emit('leave_room', {'roomId': roomId});
    _currentRoom = null;
  }

  // User status
  void goOnline() {
    _socket?.emit('user_online');
  }

  void updateStatus(String status) {
    _socket?.emit('update_status', {'status': status});
  }

  // Get online users
  void getOnlineUsers() {
    _socket?.emit('get_online_users');
  }

  // Ping server
  void ping() {
    _socket?.emit('ping');
  }

  // Guest access
  void requestGuestAccess() {
    _socket?.emit('guest_access');
  }

  // Disconnect
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _currentRoom = null;
    _isConnecting = false; // Reset connection flag
  }

  String? get currentRoom => _currentRoom;
}
