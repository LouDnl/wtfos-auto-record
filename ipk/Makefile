ifeq ($(OS),Windows_NT)
   $(info "shell is Windows cmd.exe")
   RM = rmdir /s /q
   CP = xcopy /E/H
   FixPath = $(subst /,\,$1)
   redirect = 2> NUL
else ifeq ($(shell uname), Linux)
   $(info "shell is Linux")
   RM = rm -rf
   CP = cp -r
   FixPath = $1
   redirect = 2> /dev/null
else
   $(info "shell is Windows PowerShell")
   $(info $(OS))
   RM = Remove-Item -fo -r $1
   CP = cp -r
   FixPath = $(subst /,\,$1)
   redirect = *> $$null
endif

NAME = $(shell cat ./control/control | grep Package | cut -d" " -f2)
ARCH = $(shell cat ./control/control | grep Architecture | cut -d" " -f2)
VERSION = $(shell cat ./control/control | grep Version | cut -d" " -f2)
IPK_NAME = "${NAME}_${VERSION}_${ARCH}.ipk"

all:
	mkdir -p tmp
	echo "2.0" > tmp/debian-binary
	$(CP) data tmp/
	$(CP) control tmp/
	cd tmp/control && tar --owner=0 --group=0 -czvf ../control.tar.gz .
	cd tmp/data && tar --owner=0 --group=0 -czvf ../data.tar.gz .
	cd tmp/ && tar --owner=0 --group=0 -czvf "../${IPK_NAME}" ./control.tar.gz ./data.tar.gz ./debian-binary

clean:
	-$(RM) -rf tmp $(redirect)
