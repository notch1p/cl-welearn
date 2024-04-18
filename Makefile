LISP := sbcl
DIR := $(shell pwd)/
BIN := bin/
PKG_NAME := cl-welearn
ASDF := $(PKG_NAME).asd
CLFLAG := --noinform --non-interactive
CLFLAG_DEPLOY := $(CLFLAG) --no-sysinit --no-userinit
define COMMON_BODY
--eval '(require :asdf)' \
--eval '(asdf:load-asd "$(DIR)$(ASDF)")' \
--eval '(ql:quickload :$(PKG_NAME))' \
--eval '(asdf:make :$(PKG_NAME))'
endef

COMMON_BODY_DEPLOY := $(subst asdf:make :$(PKG_NAME),asdf:make :$(PKG_NAME)/deploy,$(COMMON_BODY))

all: qlot-deploy

run:
	$(LISP) --noinform --load init.lisp \
		--eval '($(PKG_NAME):main)' 

qlot-deploy:
	qlot install
	$(LISP) $(CLFLAG_DEPLOY) \
		--load '.qlot/setup.lisp' \
		$(COMMON_BODY_DEPLOY)

build:
	$(LISP) $(CLFLAG) \
		$(COMMON_BODY)
deploy:
	$(LISP) $(CLFLAG) \
		$(COMMON_BODY_DEPLOY)

.PHONY: clean
clean:
	-rm -rf $(BIN)*