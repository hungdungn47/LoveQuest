import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Signaling {
  final SocketService _socketService = SocketService();
  final String userId;
  final String peerId;
  late IO.Socket socket;
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ]
  };

  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  Signaling(this.userId, this.peerId)
      : localRenderer = RTCVideoRenderer(),
        remoteRenderer = RTCVideoRenderer();

  Future<void> init(RTCVideoRenderer local, RTCVideoRenderer remote) async {
    _socketService.connect();

    _socketService.listenToMessages('offer', (data) async {
      await _createPeerConnection();
      await _peerConnection.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
      final answer = await _peerConnection.createAnswer();
      await _peerConnection.setLocalDescription(answer);
      _socketService.sendMessage('answer', {
        'to': data['from'],
        'sdp': answer.sdp,
        'type': answer.type,
      });
    });

    _socketService.listenToMessages('answer', (data) async {
      await _peerConnection.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
    });

    _socketService.listenToMessages('ice-candidate', (data) async {
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );
      await _peerConnection.addCandidate(candidate);
    });

    _localStream = await _createLocalStream();
    local.srcObject = _localStream;
  }

  Future<MediaStream> _createLocalStream() async {
    final mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_iceServers);

    // Thay vì addStream, ta dùng addTrack từng track một
    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        print('Remote track received');
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate != null) {
        _socketService.sendMessage('ice-candidate', {
          'to': peerId,
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };
  }

  Future<void> makeCall() async {
    await _createPeerConnection();

    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    _socketService.sendMessage('offer', {
      'to': peerId,
      'from': userId,
      'sdp': offer.sdp,
      'type': offer.type,
    });
  }

  void dispose() {
    _localStream.dispose();
    _peerConnection.close();
    socket.dispose();
  }
}
