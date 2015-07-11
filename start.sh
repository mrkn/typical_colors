#!/bin/bash
set -ex

on_terminate() {
  kill -TERM $PID
}

trap 'on_terminate' TERM INT

bundle exec rackup
