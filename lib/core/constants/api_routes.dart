class ApiRoutes {
  // Base constants if needed, but complete paths are preferred for clarity

  // Auth
  static const String authSendCode = '/api/auth/send-verification-code';
  static const String authVerifyCode = '/api/auth/verify-code';
  static const String authSignup = '/api/auth/signup';
  static const String authLogin = '/api/auth/login';
  static const String authRefresh = '/api/auth/refresh';

  // Wardrobe
  static const String wardrobe = '/api/wardrobe';

  // Fit
  static const String fitRecommend = '/api/fits/recommend';
}
