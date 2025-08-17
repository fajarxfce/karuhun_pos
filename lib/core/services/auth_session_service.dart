import 'dart:async';

class AuthSessionService {
  static final AuthSessionService instance = AuthSessionService._();
  AuthSessionService._();

  final _controller = StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _controller.stream;

  void sessionExpired() => _controller.add(null);
}
