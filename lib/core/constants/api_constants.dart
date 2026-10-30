class ApiConstants {
  // Base URL (Configure this with your backend domain or local IP e.g., http://10.0.2.2:8000 for Android emulator)
  static const String baseUrl = 'https://api.societyapp.local/v1';

  // Auth endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String currentUser = '/auth/me';
  static const String switchRole = '/auth/switch-role';

  // Society Endpoints
  static const String mySocieties = '/societies/my-memberships';
  
  // Storage Keys
  static const String accessTokenKey = 'AUTH_ACCESS_TOKEN';
  static const String refreshTokenKey = 'AUTH_REFRESH_TOKEN';
  static const String activeUserKey = 'ACTIVE_USER_DATA';
  static const String activeRoleKey = 'ACTIVE_ROLE_DATA';
}
