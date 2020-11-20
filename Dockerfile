# BUILD_DATE for R-3.6.3 is 2020-04-24
# FROM rocker/verse:3.6.3
FROM f0nzie/gitbook:3.6.3 as gitbook-363

RUN . /etc/environment \
    && mkdir /home/rstudio/allbook

FROM gitbook-363 as ml-core
COPY ./pkg/core/DESCRIPTION /home/rstudio/allbook/
# install packages using DESCRIPTION file
RUN R -e "devtools::install(\
    '/home/rstudio/allbook', \
    keep_source=TRUE, \
    args='--install-tests', \
    dependencies=TRUE)"


FROM ml-core as ml-ahead
COPY ./pkg/ahead/DESCRIPTION /home/rstudio/allbook/
# install packages using DESCRIPTION file
RUN R -e "devtools::install(\
    '/home/rstudio/allbook', \
    keep_source=TRUE, \
    args='--install-tests', \
    dependencies=TRUE)"


FROM ml-ahead as ml-pro
COPY ./pkg/pro/DESCRIPTION /home/rstudio/allbook/
# install packages using DESCRIPTION file
RUN R -e "devtools::install(\
    '/home/rstudio/allbook', \
    keep_source=TRUE, \
    args='--install-tests', \
    dependencies=TRUE)"


FROM ml-pro as ml-advanced
COPY ./pkg/advanced/DESCRIPTION /home/rstudio/allbook/
# install packages using DESCRIPTION file
RUN R -e "devtools::install(\
    '/home/rstudio/allbook', \
    keep_source=TRUE, \
    args='--install-tests', \
    dependencies=TRUE)"    

# ENV GITHUB_PAT=805e289e1d6ff1736fc307d7adb278c320216211
FROM ml-advanced as latest_bookdown
    RUN Rscript -e "remotes::install_github('yihui/xfun', dependencies = TRUE, upgrade = TRUE)"
    RUN Rscript -e "remotes::install_github('rstudio/bookdown', dependencies = TRUE, upgrade = TRUE)"

# build the book. Note that boo, data, assets are at the same folder level
FROM latest_bookdown as data_assets
COPY data   /home/rstudio/all/data/
COPY assets /home/rstudio/all/assets/
RUN    mkdir -p /home/rstudio/all/output/models \
    && mkdir -p /home/rstudio/all/output/data

FROM data_assets as render_book
COPY book   /home/rstudio/all/book/
WORKDIR /home/rstudio/all/book
# Build book
# RUN Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook")'
# RUN Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book")'
RUN Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::bs4_book")'




