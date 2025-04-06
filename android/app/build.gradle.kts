plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.indoor_nav"
    compileSdk = 34 // Updated to match Android 14 (API 34)

    defaultConfig {
        applicationId = "com.example.indoor_nav"
        minSdk = 21
        targetSdk = 34 // Updated to match Android 14 (API 34)
        versionCode = 1 // Hardcoded for now; can be dynamically set later
        versionName = "1.0" // Hardcoded for now; can be dynamically set later
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Optional: Add dependencies if needed
dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.0.20")
}