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
   redirect =
else
   $(info "shell is Windows PowerShell")
   $(info $(OS))
   RM = Remove-Item -fo -r $1
   RMF = del
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
	cp -r data tmp/
	cp -r control tmp/
	chmod +x tmp/control/postinst
	chmod +x tmp/control/prerm
	cd tmp/control && tar --owner=0 --group=0 -czvf ../control.tar.gz .
	cd tmp/data && tar --owner=0 --group=0 -czvf ../data.tar.gz .
	cd tmp/ && tar --owner=0 --group=0 -czvf "../${IPK_NAME}" ./control.tar.gz ./data.tar.gz ./debian-binary

clean:
	-$(RM) tmp
