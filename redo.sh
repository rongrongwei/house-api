#!/bin/bash

# clean up docker space
docker-compose down # shut down any running containters
docker volume rm cs4783-project-spring2021_tyw061-db-vol # remove old volumes
docker images -a -q | xargs docker rmi -f # remove all old images

# prepare next run
docker-compose build
docker-compose up
