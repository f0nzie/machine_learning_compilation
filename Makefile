# document builds inside a Docker container
# Requires Docker: yes
# Requires Conda: no
# Build bs4_book: yes
# Copy container output to host: yes
# 
# bookdown
BOOK_IMAGE = book_all
PUBLISH_DIR = ./from-dummy-container
# Docker
CONTAINER_DUMMY = dummy
CONTAINER_BOOK_OUT_DIR = /home/rstudio/all/book/public
CONTAINER_TO_HOST_DIR = ./from-dummy-container
ifeq ($(OS), Windows_NT)
    OSFLAG = WINDOWS
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S), Linux)
        OSFLAG = LINUX
    endif
    ifeq ($(UNAME_S), Darwin)
        OSFLAG = OSX
    endif
endif

#- - - - - - - - - - - - Docker container commands - - - - - - - - - - - - - -#
phony: docker_image
docker_image:
	docker build -t ${BOOK_IMAGE} .

# Simple method to copy the book output folder
# https://stackoverflow.com/a/51186557/5270873
phony: container_to_host_copy
container_to_host_copy:
	if [ -d ${CONTAINER_TO_HOST_DIR} ]; then rm -rf ${CONTAINER_TO_HOST_DIR};fi
	docker create -ti --name ${CONTAINER_DUMMY} ${BOOK_IMAGE} bash
	docker cp dummy:${CONTAINER_BOOK_OUT_DIR} ${CONTAINER_TO_HOST_DIR}
	docker rm -f ${CONTAINER_DUMMY}

#- - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - -#

open_book:
ifeq ($(OSFLAG), OSX)
    @open -a firefox  $(PUBLISH_DIR)/index.html
endif
ifeq ($(OSFLAG), LINUX)
	@firefox  $(PUBLISH_DIR)/index.html
endif
ifeq ($(OSFLAG), WINDOWS)
	@"C:\Program Files\Mozilla Firefox\firefox" $(PUBLISH_DIR)/index.html
endif


phony: bs4_book
bs4_book: docker_image container_to_host_copy open_book

phony: backup_dummy_copy
backup_dummy_copy:
	# make a copy of dummy-container
	# date the copy
	# zip it

# push main branch and github-pages
git_push:
	git push ;\
	git subtree push --prefix from-dummy-container origin gh-pages