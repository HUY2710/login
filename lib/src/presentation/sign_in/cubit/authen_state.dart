abstract class AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

enum AuthEvent { appStarted, loggedIn, loggedOut }
