#!/bin/bash

gosln() {
    echo "opening all sln files"

    start *.sln
}

alias sln="gosln"