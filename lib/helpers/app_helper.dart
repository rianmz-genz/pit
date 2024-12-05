class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  
  factory AppConfig() {
    return _instance;
  }
  
  AppConfig._internal();

  // Default URL, bisa diubah oleh user
  String baseUrl = "https://odoo.pitelektronik.com";

  // Setter untuk mengubah URL
  void setBaseUrl(String url) {
    baseUrl = url;
  }

  // Getter untuk mengambil URL
  String getBaseUrl() {
    return baseUrl;
  }
}
