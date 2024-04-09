LISP ?= sbcl
ASDF = cl-welearn.asd
DIR := $(shell pwd)/

all: build

echo:
	@echo $(DIR)

run:
	$(LISP) --noinform --load run.lisp

# build:
# 	$(LISP) --noinform --non-interactive \
# 		--load cl-welearn.asd \
# 		--eval '(ql:quickload :cl-welearn)' \
# 		--eval '(asdf:make :cl-welearn)'
### --load works like --eval '(load)'



build:
	$(LISP) --noinform --non-interactive \
		--eval '(require :asdf)' \
		--eval '(asdf:load-asd (merge-pathnames "$(ASDF)" "$(DIR)"))' \
		--eval '(ql:quickload :cl-welearn)' \
		--eval '(asdf:make :cl-welearn)'

deploy:
	$(LISP) --noinform --non-interactive \
		--load cl-welearn.asd \
		--eval '(ql:quickload :cl-welearn/deploy)' \
		--eval '(asdf:make :cl-welearn/deploy)'

clean:
	-rm -rf finishIt bin