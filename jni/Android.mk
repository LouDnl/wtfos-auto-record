# Source: http://web.guohuiwang.com/technical-notes/androidndk1
# Android.mk start
LOCAL_PATH := $(call my-dir) # Get the local path of the project.
include $(CLEAR_VARS) # Clear all the variables with a prefix "LOCAL_"

# Compiler flags
LOCAL_CFLAGS += -fPIC -std=c99
# Linker flags
LOCAL_LDFLAGS += -fPIC
# Linker libraries
LOCAL_LDLIBS := -llog
# Includes
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
# Source
LOCAL_SRC_FILES := ./src/ar.c
# Module name
LOCAL_MODULE := auto-record

# Assign build shared library
include $(BUILD_SHARED_LIBRARY) # Tell ndk-build that we want to build a shared library.
