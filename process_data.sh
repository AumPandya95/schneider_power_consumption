#!/usr/bin/env bash

printf "Starting the data processing operation. \nData from the /data/raw folder's zip file will be unzipped and processed
through to generate processed data in the /data/processed/ folder.\n----------------------------------------------\n"

printf "STEP 1:\n"
for f in ./data/raw/*.zip;
do
  printf "\tFound the zipped data folder -> %s \n\t Extracting the files..." "$f"
  unzip -j -n "$f" -d ./data/raw/
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
printf "\n----------------------------------------------\n"
done;

echo "This is the file -> $TRAIN"
echo "This is the file -> $METADATA"

# Make executable with chmod +x process_data.sh
python ./src/data/extraction.py "$TRAIN" "$METADATA"
