FROM rocker/r-ver:4.3.1 as base

RUN mkdir /project
WORKDIR /project

RUN mkdir -p rend
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

RUN apt-get update
RUN apt-get install -y cmake libcurl4-openssl-dev libfontconfig1-dev libxml2-dev
RUN R -e "renv::restore()"

###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######

FROM rocker/r-ver:4.3.1

RUN apt-get update
RUN apt-get install -y pandoc

WORKDIR /project
COPY --from=base /project .

COPY Makefile Makefile
COPY report.Rmd report.Rmd

RUN mkdir data
RUN mkdir code
RUN mkdir output
RUN mkdir report

COPY data/cv19_on_sdoh_240930.xlsx data/cv19_on_sdoh_240930.xlsx
COPY code/ code/