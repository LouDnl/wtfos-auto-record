# Makefile.mk start
default: clean	all

all: ./jni/src/*
	ndk-build
#	ndk-build -B V=1
#	ndk-build -B V=1 NDK_APP_OUT=./obj NDK_APP_LIBS_OUT=./libs
# NDK_PROJECT_PATH=./jni NDK_APPLICATION_MK=./jni/Application.mk
# NDK_APP_LIBS_OUT=./jni/libs

install:
	install -d ipk/data/opt/etc/preload.d/
	install libs/armeabi-v7a/*.so ipk/data/opt/etc/preload.d/
	chmod +x ./ipk/control/postinst
	chmod +x ./ipk/control/prerm

ipk: all install
	$(MAKE) -C ipk clean
	$(MAKE) -C ipk
	mv ipk/*.ipk ./

clean:
	$(MAKE) -C ipk clean
	-rm -f *.ipk 2>/dev/null
	-rm -f ./ipk/data/opt/etc/preload.d/libauto-record.so 2>/dev/null
	-rm -rf ./jni/libs 2>/dev/null
	-rm -rf ./jni/obj 2>/dev/null
	-rm -rf ./libs 2>/dev/null
	-rm -rf ./obj 2>/dev/null
	-rm -rf ./jni/libs 2>/dev/null
