APP_OPTIM := debug  # Build the target in debug mode.
APP_ABI := armeabi-v7a # Define the target architecture to be ARM.
APP_CPPFLAGS := -frtti -fexceptions # This is the place you enable exception.
APP_PLATFORM := android-23 # Define the target Android version of the native application.
APP_BUILD_SCRIPT := ./jni/Android.mk