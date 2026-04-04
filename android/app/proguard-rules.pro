# Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mantieni annotazioni e info di debug per stack traces leggibili
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Sopprime warning per librerie di rete usate internamente da Flutter
-dontwarn okhttp3.**
-dontwarn okio.**

# Google Play Core (referenziato da Flutter engine ma non usato in questa app)
-dontwarn com.google.android.play.core.**

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# flutter_secure_storage (Android Keystore / EncryptedSharedPreferences)
-keep class androidx.security.crypto.** { *; }
