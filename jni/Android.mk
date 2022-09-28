ifeq ($(OS),Windows_NT)
   $(info "shell is Windows cmd.exe")
   SRC = src/ar.c
else ifeq ($(shell uname), Linux)
   $(info "shell is Linux")
   SRC = ./src/ar.c
else
   $(info "shell is Windows PowerShell")
   SRC = src/ar.c
endif
# Source: http://web.guohuiwang.com/technical-notes/androidndk1
LOCAL_PATH := $(call my-dir) # Get the local path of the project.
include $(CLEAR_VARS) # Clear all the variables with a prefix "LOCAL_"
$(info LOCAL_PATH=$(LOCAL_PATH))
# Compiler flags
LOCAL_CFLAGS += -fPIC -std=c99
# Linker flags
LOCAL_LDFLAGS += -fPIC
# Linker libraries
LOCAL_LDLIBS := -llog
# Includes
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
# LOCAL_C_INCLUDES := $(LOCAL_PATH)
$(info LOCAL_C_INCLUDES=$(LOCAL_C_INCLUDES))
# Source
LOCAL_SRC_FILES := $(SRC)
# LOCAL_SRC_FILES := ar.c
$(info LOCAL_SRC_FILES=$(LOCAL_SRC_FILES))
# Module name
LOCAL_MODULE    := auto-record
$(info LOCAL_MODULE=$(LOCAL_MODULE))
include $(BUILD_SHARED_LIBRARY) # Tell ndk-build that we want to build a shared library.
