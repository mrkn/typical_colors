FROM ruby:2.2
MAINTAINER Kenta Murata <mrkn@mrkn.jp>

ENV JULIA_PATH /usr/local/julia
ENV JULIA_VERSION 0.3.10

RUN apt-get update \
        && apt-get install -y --no-install-recommends ca-certificates git curl \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir $JULIA_PATH
RUN curl -sSL "https://julialang.s3.amazonaws.com/bin/linux/x64/${JULIA_VERSION%[.-]*}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | tar -xz -C $JULIA_PATH --strip-components 1

ENV PATH $JULIA_PATH/bin:$PATH

RUN mkdir -p /src /app /log

WORKDIR /app
ADD . /app
RUN bundle install
RUN mkdir -p tmp

EXPOSE 9292
CMD ["/app/start.sh"]
