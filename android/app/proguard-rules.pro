# The Flutter engine and its plugin registrations are referenced reflectively.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# drift/sqlite3 load their native library by name.
-keep class com.mr_ha.** { *; }
-dontwarn org.sqlite.**

# Flutter's embedding references the Play Core split-install APIs so that apps
# using deferred components can find them. TradePath ships as a single APK and
# never installs a feature module, so those classes are absent at build time
# and R8 must not treat the dangling references as an error.
-dontwarn com.google.android.play.core.**
