#!/bin/bash
# this script loads a collection of topics to the data store

# first step - declare and initialize the array of topics
declare -a toplist=("giraffe" "elephant" "zebra" "Ostrich" "springbok" "lion" "impala" "kudu" "oryx" "crocodile" "cheetah" "jackal" "hyena" "hippo" "rhino" "baboon")

# loop through the list and insert them in the db
for i in "${toplist[@]}"
do
    echo "$i"
    curl -H "Content-Type: application/json" -X POST -d '{"name":"$i"}' http://196.216.167.210:7483/api/topics
done
