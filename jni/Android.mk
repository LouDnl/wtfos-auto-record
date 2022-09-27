# Source: http://web.guohuiwang.com/technical-notes/androidndk1
LOCAL_PATH := $(call my-dir) # Get the local path of the project.
include $(CLEAR_VARS) # Clear all the variables with a prefix "LOCAL_"

# Compiler flags
LOCAL_CFLAGS += -fPIC -std=c99
# Linker flags
LOCAL_LDFLAGS += -fPIC
# Linker libraries
LOCAL_LDLIBS := -llog

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SRC_FILES := ./src/ar.c # Indicate the source code
LOCAL_MODULE    := wtfos-ar # The name of the output binary
include $(BUILD_SHARED_LIBRARY) # Tell ndk-build that we want to build a shared library.
