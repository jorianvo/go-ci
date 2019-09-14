#!/bin/bash -eux
readonly _IMAGE="jorianvo/go-ci"

function build () {
    local _TAG_FULL_VERSION=$(grep FROM Dockerfile | sed -n -e 's/FROM golang:\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
    local _TAG_MAJOR=$(grep FROM Dockerfile | sed -n -e 's/FROM golang:\([0-9]*\).*/\1/p')

    echo $_TAG_FULL_VERSION
    echo $_TAG_MAJOR
    docker build -t "$_IMAGE:$_TAG_FULL_VERSION" -t "$_IMAGE:$_TAG_MAJOR" .
}

function push () {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$_IMAGE"
}

case $1 in
    build)
        build
        ;;

    push)
        push
        ;;

    *)
        echo -n "unknown command, exiting..."
        exit 1
        ;;
esac