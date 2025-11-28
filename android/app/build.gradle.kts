import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
}

// ✅ Cargar keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()


if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.examen01"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.examen01"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        // Intentamos crear la configuración de release a partir de `key.properties`.
        // Si el archivo de keystore no existe o las propiedades están vacías,
        // dejaremos que la build use la firma `debug` como fallback para pruebas locales.
        if (keystorePropertiesFile.exists()) {
            val storeFileProp = keystoreProperties.getProperty("storeFile") ?: ""
            val storeFileObj = if (storeFileProp.isNotBlank()) file(storeFileProp) else null

            if (storeFileObj != null && storeFileObj.exists()) {
                create("release") {
                    storeFile = storeFileObj
                    storePassword = keystoreProperties.getProperty("storePassword") ?: ""
                    keyAlias = keystoreProperties.getProperty("keyAlias") ?: ""
                    keyPassword = keystoreProperties.getProperty("keyPassword") ?: ""
                }
            } else {
                // No existe el keystore especificado. No crear release signing.
            }
        }
    }

    buildTypes {
        release {
            // Si definimos release signing, lo usamos; si no, usamos debug como fallback.
            signingConfig = if (signingConfigs.findByName("release") != null) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
