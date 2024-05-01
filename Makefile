LISP ?= sbcl
BIN := bin/
PKG_NAME := cl-welearn
ASDF := $(PKG_NAME).asd
CLFLAG := --noinform --non-interactive
CLFLAG_DEPLOY := $(CLFLAG) --no-sysinit --no-userinit
define COMMON_BODY
--eval '(push :deploy-console *features*)' \
--eval '(ql:quickload :cl+ssl)' \
--eval '(ql:quickload :deploy)' \
--eval '#+unix (deploy:define-library cl+ssl::libssl :dont-deploy T)' \
--eval '#+unix (deploy:define-library cl+ssl::libcrypto :dont-deploy T)' \
--eval '(asdf:load-asd (merge-pathnames (uiop:getcwd) "$(ASDF)"))' \
--eval '(ql:quickload :$(PKG_NAME))' \
--eval '(asdf:make :$(PKG_NAME))'
endef

COMMON_BODY_DEPLOY := $(subst asdf:make :$(PKG_NAME),asdf:make :$(PKG_NAME)/deploy,$(COMMON_BODY))

all: qlot-deploy

run:
	$(LISP) --noinform --load init.lisp \
		--eval '($(PKG_NAME):main)' 

qlot-deploy:
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
	-rm -rf $(BIN)