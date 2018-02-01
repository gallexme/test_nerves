FROM ubuntu:trusty

MAINTAINER Fabian Fink <marcelocg@gmail.com>

# Elixir requires UTF-8
RUN apt-get update && apt-get upgrade -y && apt-get install locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install software
RUN apt-get install -y curl wget git make sudo \
    # download and install Erlang apt repo package
    && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && rm erlang-solutions_1.0_all.deb \
    # For some reason, installing Elixir tries to remove this file
    # and if it doesn't exist, Elixir won't install. So, we create it.
    # Thanks Daniel Berkompas for this tip.
    # http://blog.danielberkompas.com
    && touch /etc/init.d/couchdb \
    # install latest elixir package
    && apt-get install -y elixir ssh-askpass squashfs-tools erlang-dialyzer erlang-parsetools git  g++ libssl-dev libncurses5-dev bc m4 make unzip cmake python erlang-dev \
    # clean up after ourselves
    && apt-get clean

RUN curl -OL https://github.com/fhunleth/fwup/releases/download/v1.0.0/fwup_1.0.0_amd64.deb
RUN dpkg -i fwup_1.0.0_amd64.deb
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex nerves_bootstrap --force
CMD ["mix"]