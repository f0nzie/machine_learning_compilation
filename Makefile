BOOK_IMAGE = book_all
CONTAINER_DUMMY = dummy
CONTAINER_BOOK_OUT_DIR = /home/rstudio/all/book/public
CONTAINER_TO_HOST_DIR = ./from-dummy-container
PUBLISH_DIR = ./from-dummy-container
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


image:
	docker build -t ${BOOK_IMAGE} .

# Simple method to copy the book output folder
# https://stackoverflow.com/a/51186557/5270873
phony: publish_copy
publish_copy:
	if [ -d ${CONTAINER_TO_HOST_DIR} ]; then rm -rf ${CONTAINER_TO_HOST_DIR};fi
	docker create -ti --name ${CONTAINER_DUMMY} ${BOOK_IMAGE} bash
	docker cp dummy:${CONTAINER_BOOK_OUT_DIR} ${CONTAINER_TO_HOST_DIR}
	docker rm -f ${CONTAINER_DUMMY}


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
bs4_book: image publish_copy open_book

phony: backup_dummy_copy
backup_dummy_copy:
	# make a copy of dummy-container
	# date the copy
	# zip it