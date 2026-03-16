class AppConstants {
  // API Configuration
  // Jika menggunakan Android Emulator, gunakan 10.0.2.2 untuk akses localhost laptop
  // Jika menggunakan HP fisik, ganti dengan IP laptop Anda (misal: 192.168.1.5)
  static const String baseUrl = 'http://10.0.2.2/api/v1'; 
  
  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String userDataKey = 'user_data';
  static const String lastSyncKey = 'last_sync';
  
  // Database Configuration
  static const String dbName = 'sibaruki.db';
  static const int dbVersion = 1;
  
  // Error Messages
  static const String errorConnection = 'Koneksi gagal. Silakan cek internet/server Anda.';
  static const String errorGeneric = 'Terjadi kesalahan. Silakan coba lagi nanti.';
  static const String errorAuth = 'Username atau Password salah.';
}
