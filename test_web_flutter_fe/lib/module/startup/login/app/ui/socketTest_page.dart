import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/service/google_auth_service.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/service/socket_service.dart';
import 'package:universal_html/html.dart' as html;

@injectable
class SocketTestPage extends StatefulWidget {
  final SocketService socketService;
  final GoogleAuthService authService;

  const SocketTestPage({
    Key? key,
    required this.socketService,
    required this.authService,
  }) : super(key: key);

  @override
  State<SocketTestPage> createState() => _SocketTestPageState();
}

class _SocketTestPageState extends State<SocketTestPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _roomController = TextEditingController(
    text: 'room1',
  );

  List<Map<String, dynamic>> _messages = [];
  String? _currentUser;
  bool _isConnected = false;
  bool _isAuthenticated = false;
  String _connectionStatus = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _setupSocketListeners();
    _checkAuthAndConnect();
  }

  void _checkAuthAndConnect() {
    // Avoid multiple connections
    if (widget.socketService.isConnected) {
      return;
    }

    // Check if we just came back from Google OAuth
    if (widget.authService.isAuthSuccessUrl()) {
      _handleGoogleAuthSuccess();
    } else if (widget.authService.isAuthenticated()) {
      // User already authenticated, connect with token
      widget.socketService.connectAuthenticated();
    }
  }

  void _handleGoogleAuthSuccess() {
    try {
      final url = html.window.location.href;
      final token = widget.authService.extractTokenFromUrl(url);
      final userData = widget.authService.extractUserFromUrl(url);

      if (token != null && token.isNotEmpty) {
        widget.authService.saveAuthData(token, userData);
        widget.authService.cleanUrl();

        setState(() {
          _currentUser = userData?['userName']?.toString() ?? 'Google User';
        });

        // Connect to socket with the new token
        widget.socketService.connectAuthenticated();

        _showSnackBar('Google Sign-In successful!', Colors.green);
      } else {
        _showSnackBar('Failed to get authentication token', Colors.red);
      }
    } catch (e) {
      print('Error handling Google auth success: $e');
      _showSnackBar('Error processing authentication: $e', Colors.red);
    }
  }

  void _setupSocketListeners() {
    // Connection status
    widget.socketService.onConnected = () {
      if (mounted) {
        setState(() {
          _isConnected = true;
          _connectionStatus = 'Connected';
        });
      }
    };

    widget.socketService.onDisconnected = () {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isAuthenticated = false;
          _connectionStatus = 'Disconnected';
        });
      }
    };

    // Authentication success
    widget.socketService.onAuthSuccess = (data) {
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _connectionStatus = 'Authenticated';
          _currentUser = data['user']?['userName']?.toString() ?? 'User';
        });

        // Auto join default room
        widget.socketService.joinRoom(_roomController.text);
        widget.socketService.goOnline();

        _showSnackBar('Socket authenticated successfully!', Colors.green);
      }
    };

    // Authentication error
    widget.socketService.onAuthError = (error) {
      if (mounted) {
        setState(() {
          _connectionStatus = 'Auth Failed: $error';
        });
        _showSnackBar('Authentication error: $error', Colors.red);
      }
    };

    // New message received
    widget.socketService.onNewMessage = (data) {
      if (mounted) {
        setState(() {
          _messages.add({
            'id': data['id']?.toString() ?? '',
            'message': data['message']?.toString() ?? '',
            'sender': data['sender']?['userName']?.toString() ?? 'Unknown',
            'timestamp': data['timestamp']?.toString() ?? '',
            'isMe': data['sender']?['userName']?.toString() == _currentUser,
          });
        });
      }
    };

    // Room joined
    widget.socketService.onRoomJoined = (data) {
      if (mounted) {
        _showSnackBar('Joined room: ${data['roomId']}', Colors.green);
        setState(() {
          _messages.clear();
        });
      }
    };

    // User events
    widget.socketService.onUserJoined = (data) {
      if (mounted) {
        _showSnackBar(
          '${data['userName']?.toString() ?? 'Someone'} joined the room',
          Colors.blue,
        );
      }
    };

    widget.socketService.onUserLeft = (data) {
      if (mounted) {
        _showSnackBar(
          '${data['userName']?.toString() ?? 'Someone'} left the room',
          Colors.orange,
        );
      }
    };

    widget.socketService.onUserTyping = (data) {
      if (mounted &&
          data['isTyping'] == true &&
          data['userName']?.toString() != _currentUser) {
        _showSnackBar(
          '${data['userName']?.toString() ?? 'Someone'} is typing...',
          Colors.grey,
        );
      }
    };

    // Error
    widget.socketService.onError = (data) {
      _showSnackBar('Error: ${data['message']}', Colors.red);
    };
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Test'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isConnected ? Icons.wifi : Icons.wifi_off),
            onPressed: _toggleConnection,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Connection Status Card
            _buildStatusCard(),

            SizedBox(height: 16),

            // Authentication Section
            _buildAuthSection(),

            SizedBox(height: 16),

            // Room Controls
            _buildRoomControls(),

            SizedBox(height: 16),

            // Messages List
            _buildMessagesList(),

            SizedBox(height: 16),

            // Message Input
            _buildMessageInput(),

            SizedBox(height: 16),

            // Control Buttons
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _isConnected ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isConnected ? Icons.check_circle : Icons.error,
                color: _isConnected ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                'Status: $_connectionStatus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isConnected
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ],
          ),
          if (_currentUser != null) ...[
            SizedBox(height: 8),
            Text(
              'User: $_currentUser ${_isAuthenticated ? "(Authenticated)" : "(Guest)"}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Icon(Icons.account_circle),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _connectGuest, child: Text('Guest')),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomControls() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _roomController,
            decoration: InputDecoration(
              labelText: 'Room ID',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isConnected ? _joinRoom : null,
          child: Text('Join Room'),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _messages.isEmpty
            ? Center(
                child: Text(
                  'No messages yet. Join a room and start chatting!',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            : ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: message['isMe']
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: message['isMe']
                ? Colors.blue.shade100
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message['sender'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(message['message'], style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text(
                _formatTimestamp(message['timestamp']),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Type a message...',
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (_) => _sendMessage(),
            onChanged: (text) {
              if (text.isNotEmpty && widget.socketService.currentRoom != null) {
                widget.socketService.startTyping(
                  widget.socketService.currentRoom!,
                );
              }
            },
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isConnected ? _sendMessage : null,
          child: Icon(Icons.send),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: _isConnected ? () => widget.socketService.ping() : null,
          child: Text('Ping'),
        ),
        ElevatedButton(
          onPressed: _isConnected
              ? () => widget.socketService.getOnlineUsers()
              : null,
          child: Text('Get Users'),
        ),
        ElevatedButton(
          onPressed: _isConnected
              ? () => widget.socketService.updateStatus('away')
              : null,
          child: Text('Away'),
        ),
        ElevatedButton(
          onPressed: _isConnected
              ? () => widget.socketService.updateStatus('online')
              : null,
          child: Text('Online'),
        ),
      ],
    );
  }

  // Action methods
  void _signInWithGoogle() {
    widget.authService.signInWithGoogle();
  }

  void _connectGuest() {
    if (!widget.socketService.isConnected) {
      widget.socketService.connectGuest();
      setState(() {
        _currentUser = 'Guest';
      });
    }
  }

  void _logout() {
    widget.authService.clearAuthData();
    widget.socketService.disconnect();
    setState(() {
      _currentUser = null;
      _isAuthenticated = false;
      _messages.clear();
    });
    _showSnackBar('Logged out successfully', Colors.blue);
  }

  void _toggleConnection() {
    if (_isConnected) {
      widget.socketService.disconnect();
    } else {
      // Only connect if not already connected
      if (!widget.socketService.isConnected) {
        if (widget.authService.isAuthenticated()) {
          widget.socketService.connectAuthenticated();
        } else {
          widget.socketService.connectGuest();
        }
      }
    }
  }

  void _joinRoom() {
    if (_roomController.text.isNotEmpty) {
      widget.socketService.joinRoom(_roomController.text);
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty &&
        widget.socketService.currentRoom != null) {
      widget.socketService.sendMessage(
        widget.socketService.currentRoom!,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // Clear all callbacks to prevent memory leaks
    widget.socketService.onConnected = null;
    widget.socketService.onDisconnected = null;
    widget.socketService.onAuthSuccess = null;
    widget.socketService.onAuthError = null;
    widget.socketService.onNewMessage = null;
    widget.socketService.onRoomJoined = null;
    widget.socketService.onUserJoined = null;
    widget.socketService.onUserLeft = null;
    widget.socketService.onUserTyping = null;
    widget.socketService.onError = null;

    // Dispose controllers
    _messageController.dispose();
    _roomController.dispose();

    super.dispose();
  }
}
