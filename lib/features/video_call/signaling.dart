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

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {
        'urls': 'turn:openrelay.metered.ca:80',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
    ],
  };

  Signaling(this.userId, this.peerId);

  Future<void> init() async {
    _socketService.connect();

    _socketService.listenToMessages('signaling_offer', (data) async {
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
      await _peerConnection.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
    });

    _socketService.listenToMessages('signaling_ice-candidate', (data) async {
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      await _peerConnection.addCandidate(candidate);
    });

    _localStream = await _createLocalStream();
  }

  Future<void> _ensurePeerConnectionCreated() async {
    if (_peerConnectionInitialized) return;

    _peerConnection = await createPeerConnection(_iceServers);
    _peerConnectionInitialized = true;

    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    _peerConnection.onTrack = (event) {
      // Có thể ghi log để xác nhận âm thanh nhận về
      print('Audio track received');
    };

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate != null) {
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
    };
  }

  Future<MediaStream> _createLocalStream() async {
    final mediaConstraints = {
      'audio': true,
      'video': false,
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<void> makeCall() async {
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
  }

  void dispose() {
    _localStream.dispose();
    _peerConnection.close();
    _peerConnectionInitialized = false;
    _socketService.disconnect();
  }
}
