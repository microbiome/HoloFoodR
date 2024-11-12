ARG BIOC_VERSION
FROM bioconductor/bioconductor_docker:${BIOC_VERSION}

# Copy repository to Docker image
COPY --chown=rstudio:rstudio . /opt/pkg

# Install essentials
RUN apt-get install -y python3 python3-setuptools python3-dev python3-pip

# Install HoloFoodR dependencies
RUN Rscript -e 'repos <- BiocManager::repositories(); \
    remotes::install_local(path = "/opt/pkg/", repos=repos, \
    dependencies=TRUE, build_vignettes=FALSE, upgrade=TRUE); \
    sessioninfo::session_info(installed.packages()[,"Package"], \
    include_base = TRUE)'

# Istall CRAN packages for case study
RUN Rscript -e 'install.packages(c("DT", "GGally", "ggplot2", "ggpubr", "ggraph", "ggsignif", \
                                   "knitr", "latex2exp", "magick", "patchwork", "reshape", "reticulate", "shadowtext", "stringr", "scater"))'

# Install Bioconductor packages for case study
RUN Rscript -e 'BiocManager::install(c("BiocStyle", "ComplexHeatmap", "MGnifyR", "MOFA2", "scater"))'

# Install mia and miaViz from GitHub
RUN Rscript -e 'remotes::install_github(c("microbiome/mia", "microbiome/miaViz"))'

# Install HoloFoodR locally
RUN Rscript -e 'devtools::install(pkg = "/opt/pkg", build = TRUE)'

# Install mofapy2 for case study
RUN python3 -m pip install 'https://github.com/bioFAM/mofapy2/tarball/master'

# Internal port for RStudio server is 8787
EXPOSE 8787
