FROM ubuntu:disco

RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y cmake libgtk2.0-dev \
											libjpeg-dev \
											liblcms2-dev \
											libpng-dev \
											libsqlite3-dev \
											libtiff-dev \
											libtool \
											libxml2-dev \
											sqlite3 git \
											libudev-dev \
											libunique-dev \
											libnotify-dev

# openjpeg
workdir /
run git clone https://github.com/uclouvain/openjpeg.git
workdir /openjpeg
run mkdir build
workdir /openjpeg/build
run cmake .. -DCMAKE_BUILD_TYPE=Release
run make
run make install

WORKDIR /src
COPY . /src
RUN cmake --version
RUN mkdir dbuild
WORKDIR /src/dbuild/
RUN cmake -D BUILD_TOOLS=ON ../
RUN make
