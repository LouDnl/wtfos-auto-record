ifeq ($(OS),Windows_NT)
   $(info "shell is Windows cmd.exe")
   RM = rmdir /s /q
   RMF = del
   FixPath = $(subst /,\,$1)
   redirect = 2> NUL
else ifeq ($(shell uname), Linux)
   $(info "shell is Linux")
   RM = rm -rf
   RMF = rm -f
   FixPath = $1
   redirect = 2>/dev/null
else
   $(info "shell is Windows PowerShell")
   $(info $(OS))
   RM = Remove-Item -fo -r $1
   RMF = del
   FixPath = $(subst /,\,$1)
   redirect = *> $$null
endif

default: clean	all

all: ./jni/src/*
	-mkdir -p jni/libs/armeabi-v7a
	ndk-build NDK_PROJECT_PATH=./jni NDK_APPLICATION_MK=./jni/Application.mk
# NDK_APP_LIBS_OUT=./jni/libs
install:
	install -d ipk/data/opt/etc/preload.d/
	install jni/libs/armeabi-v7a/*.so ipk/data/opt/etc/preload.d/
	chmod +x ./ipk/control/postinst
	chmod +x ./ipk/control/prerm

ipk: all install
	$(MAKE) -C ipk clean
	$(MAKE) -C ipk
	mv ipk/*.ipk ./

clean:
	$(MAKE) -C ipk clean
	-$(RMF) *.ipk
	-$(RM) $(call FixPath,./jni/libs) $(redirect)
	-$(RM) $(call FixPath,./jni/obj) $(redirect)
	-$(RMF) $(call FixPath,data/opt/etc/preload.d/*.so)
