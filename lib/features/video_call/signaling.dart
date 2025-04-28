import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:love_quest/core/socket/socket_service.dart';

class Signaling {
  final SocketService _socketService = SocketService();
  final String userId;
  final String peerId;

  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;

  bool _isCaller = false;
  bool _peerConnectionInitialized = false;
  bool _isInitialized = false;

  MediaStream get localStream => _localStream;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      { "urls": 'stun:stun.relay.metered.ca:80' },
      {
        "urls": 'turn:global.relay.metered.ca:80',
        'username': 'ebab71399588129d876e05b9',
        'credential': 'uRXYA6rx/QIb2UFn'
      },
      {
        'urls': 'turn:global.relay.metered.ca:80?transport=tcp',
        'username': 'ebab71399588129d876e05b9',
        'credential': 'uRXYA6rx/QIb2UFn'
      },
      {
        'urls': 'turn:global.relay.metered.ca:443',
        'username': 'ebab71399588129d876e05b9',
        'credential': 'uRXYA6rx/QIb2UFn'
      },
      {
        'urls': 'turns:global.relay.metered.ca:443?transport=tcp',
        'username': 'ebab71399588129d876e05b9',
        'credential': 'uRXYA6rx/QIb2UFn'
      }
    ],
  };

  Signaling(this.userId, this.peerId);

  Future<void> init() async {
    try {
      print('Initializing signaling...');
      bool connected = await _socketService.connect();
      if (!connected) {
        throw Exception('Failed to connect to socket server');
      }

      _socketService.listenToMessages('signaling_offer', (data) async {
        print('Received offer from ${data['from']}');
        _isCaller = false;
        await _ensurePeerConnectionCreated();

        await _peerConnection.setRemoteDescription(
          RTCSessionDescription(data['sdp'], data['type']),
        );

        final answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);

        _socketService.sendMessage('signaling_answer', {
          'to': data['from'],
          'from': userId,
          'sdp': answer.sdp,
          'type': answer.type,
        });
      });

      _socketService.listenToMessages('signaling_answer', (data) async {
        print('Received answer from ${data['from']}');
        await _peerConnection.setRemoteDescription(
          RTCSessionDescription(data['sdp'], data['type']),
        );
      });

      _socketService.listenToMessages('signaling_ice-candidate', (data) async {
        print('Received ICE candidate from ${data['from']}');
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection.addCandidate(candidate);
      });

      _localStream = await _createLocalStream();
      _isInitialized = true;
      print('Signaling initialized successfully');
    } catch (e) {
      print('Error initializing signaling: $e');
      rethrow;
    }
  }

  Future<void> _ensurePeerConnectionCreated() async {
    if (_peerConnectionInitialized) return;

    try {
      print('Creating peer connection...');
      _peerConnection = await createPeerConnection(_iceServers);
      _peerConnectionInitialized = true;

      _localStream.getTracks().forEach((track) {
        _peerConnection.addTrack(track, _localStream);
      });

      _peerConnection.onTrack = (event) {
        print('Audio track received');
      };

      _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate != null) {
          print('Sending ICE candidate to $peerId');
          _socketService.sendMessage('signaling_ice-candidate', {
            'to': peerId,
            'from': userId,
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          });
        }
      };

      _peerConnection.onIceConnectionState = (state) {
        print('ICE connection state: $state');
        if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
          print('Connection established successfully.');
        } else if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          print('Connection failed');
        }
      };
    } catch (e) {
      print('Error creating peer connection: $e');
      rethrow;
    }
  }

  Future<MediaStream> _createLocalStream() async {
    try {
      print('Creating local stream...');
      final mediaConstraints = {
        'audio': true,
        'video': false,
      };
      final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      print('Local stream created successfully');
      return stream;
    } catch (e) {
      print('Error creating local stream: $e');
      rethrow;
    }
  }

  Future<void> makeCall() async {
    if (!_isInitialized) {
      print('Signaling not initialized');
      return;
    }

    try {
      print('Making call to $peerId...');
      _isCaller = true;
      await _ensurePeerConnectionCreated();

      final offer = await _peerConnection.createOffer();
      await _peerConnection.setLocalDescription(offer);

      _socketService.sendMessage('signaling_offer', {
        'to': peerId,
        'from': userId,
        'sdp': offer.sdp,
        'type': offer.type,
      });
      print('Call offer sent successfully');
    } catch (e) {
      print('Error making call: $e');
      rethrow;
    }
  }

  void dispose() {
    print('Disposing signaling...');
    _localStream.dispose();
    if (_peerConnectionInitialized) {
      _peerConnection.close();
    }
    _peerConnectionInitialized = false;
    _socketService.disconnect();
    print('Signaling disposed');
  }
}
