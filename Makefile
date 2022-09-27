ifeq ($(OS),Windows_NT)
   $(info "shell is Windows cmd.exe")
   RM = rmdir /s /q
   FixPath = $(subst /,\,$1)
   redirect = 2> NUL
else ifeq ($(shell uname), Linux)
   $(info "shell is Linux")
   RM = rm -rf
   FixPath = $1
   redirect = 2> /dev/null
else
   $(info "shell is Windows PowerShell")
   $(info $(OS))
   RM = Remove-Item -fo -r $1
   FixPath = $(subst /,\,$1)
   redirect = *> $$null
endif

all: clean default

default: ar

ar: jni/src/*
	ndk-build NDK_PROJECT_PATH=./jni/ NDK_APPLICATION_MK=./jni/Application.mk

install: all
	install -d ipk/data/opt/etc/preload.d/
	install jni/libs/armeabi-v7a/lib*.so ipk/data/opt/etc/preload.d/

ipk: all
	$(MAKE) -C ipk clean
	$(MAKE) install
	$(MAKE) -C ipk

clean:
	-$(RM) $(call FixPath,./jni/libs/) $(redirect)
	-$(RM) $(call FixPath,./jni/obj/) $(redirect)
