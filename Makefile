LISP ?= sbcl
BIN := bin/
PKG_NAME := cl-welearn
ASDF := $(PKG_NAME).asd
CLFLAG := --noinform --non-interactive
CLFLAG_DEPLOY := $(CLFLAG) --no-sysinit --no-userinit
STATUS_OUTPUT := nil
define COMMON_BODY
--eval '(require :asdf)' \
--eval '(require :quicklisp)' \
--eval '(ql:quickload :deploy)' \
--eval '(asdf:load-asd (merge-pathnames (uiop:getcwd) "$(ASDF)"))' \
--eval '(ql:quickload :$(PKG_NAME))' \
--eval '(push :deploy-console *features*)' \
--eval '(setf deploy:*status-output* $(STATUS_OUTPUT))' \
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
		$(subst nil,t,$(COMMON_BODY_DEPLOY))

.PHONY: clean
clean:
	-rm -rf $(BIN)