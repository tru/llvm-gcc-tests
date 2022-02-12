FROM ubuntu:16.04 as gcc

RUN apt-get update
RUN apt-get install -y build-essential git wget libz-dev file
RUN git clone https://github.com/BobSteagall/gcc-builder.git \
  && cd gcc-builder \
  && git checkout gcc7

COPY gcc-build-vars.sh gcc-builder

RUN cd gcc-builder && ./build-gcc.sh -T

RUN apt-get install -y lsb-release
RUN cd gcc-builder && ./stage-gcc.sh && ./pack-gcc.sh
RUN tar -zxvf /gcc-builder/packages/kewb-gcc710*.tgz -C /


COPY hello.cpp /

#RUN g++ -std=c++17 -o hello-5 hello.cpp

RUN . ./usr/local/bin/setenv-for-gcc710.sh && g++ -o hello hello.cpp -std=c++17

FROM ubuntu:16.04

COPY --from=gcc /hello /hello
RUN ./hello