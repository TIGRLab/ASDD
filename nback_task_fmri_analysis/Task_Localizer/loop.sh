#!/bin/bash

#Loops over subjects and runs Task_Localizer.sh for each subject.

export DATA_DIR=/projects/ttan/ASSD/Data/testing/

for i in $DATA_DIR/*; do
	bash Task_Localizer.sh ${i##*/}
done

