ARG TAG=40
FROM fedora:${TAG}

ENV TZ=US/Michigan

RUN dnf install -y \
        ccache \
        g++ \
        git \
        make \
        ninja-build \
        libxml2-devel \
        curl \
        tree \
        valgrind \
        zip \
        file \
        rpm-build \
        && dnf clean all

# Install cmake
ARG TARGETPLATFORM
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")  ARCHITECTURE="x86_64"   ;; \
         "linux/arm64")  ARCHITECTURE="aarch64"  ;; \
         *)  exit 1 ;; \
    esac; \
    curl --insecure -L "https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0-linux-${ARCHITECTURE}.tar.gz" | tar xz --strip-components=1 -C /usr/local

# Put ccache into the path
ENV PATH /usr/lib/ccache:$PATH
RUN export PATH=/usr/lib/ccache/:$PATH

# Install srcml for testing
RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")  ARCHITECTURE="x86_64"   ;; \
         "linux/arm64")  ARCHITECTURE="aarch64"  ;; \
         *)  exit 1 ;; \
    esac; \
    curl --insecure -L -O "https://mlcollard.net/dist/srcml-1.0.0-1.fc38.${ARCHITECTURE}.rpm" && \
    dnf install -y /srcml-1.0.0*.rpm; \
    rm -f /srcml_1.0.0*.rpm
