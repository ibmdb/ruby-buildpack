#!/usr/bin/env bash -l

rvm use <%= ruby_version %> --install > /dev/null 2>&1
bundle package --all
