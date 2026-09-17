# The Flutter engine and its plugin registrations are referenced reflectively.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# drift/sqlite3 load their native library by name.
-keep class com.mr_ha.** { *; }
-dontwarn org.sqlite.**
