#!/bin/bash

#Loops over subjects and runs Find_Peak.sh for each subject. Should have already created ROIs using Search_Space.sh

export DATA_DIR=/projects/ttan/ASSD/Data/testing/

for i in $DATA_DIR/*; do
	bash Find_Peak.sh ${i##*/}
done

