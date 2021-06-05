#!/usr/bin/env bash

printf "Starting the data processing operation. \nData will be extracted from the /data/raw directory's zip file and processed
through to generate processed data in the /data/processed/ directory.\n----------------------------------------------\n"

printf "STEP 1:\n"
for f in ./data/raw/*.zip;
do
  printf "\tFound the zipped data folder -> %s" "$f"
  printf "\n\tExtracting the files...\n\t"

  unzip -j -n "$f" -d ./data/raw/  # Files will be unzipped, however already existing files will not be replaced

  printf "\nData files used are,\n"

  for l in $(unzip -Z1 "$f" | tail -5);
    do
      if basename "$l" | grep -i -s '\btraining\b'
        then
          TRAIN=$(basename "$l" | grep -i -s '\btraining\b');
        else
          printf "\t" | sed '/^[[:space:]]*$/d'
      fi
      if basename "$l" | grep -i -s '\bmetadata\b'
        then
          METADATA=$(basename "$l" | grep -i -s '\bmetadata\b');
        else
          printf "\t" | sed '/^[[:space:]]*$/d'
      fi
    done
done;

printf ""
printf "\n----------------------------------------------\nSTEP 2:\n\tStored the file names :D\n"
printf "\tHere is the main file name -> %s" "$TRAIN"
printf "\n\tHere is the file name for the building data -> %s" "$METADATA"

# Make executable with chmod +x process_data.sh
printf "\n----------------------------------------------\nSTEP3:\n\tExecuting Python script to generate processed data..."
printf "\n\tProcessed data will be saved in /data/processed/ folder\n"

python ./src/data/extraction.py "$TRAIN" "$METADATA"
printf "\nProcess has been completed!\n----------------------------------------------\n"