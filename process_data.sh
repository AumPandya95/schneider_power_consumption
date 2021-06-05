#!/usr/bin/env bash
#!/usr/bin/env python

for f in ./data/raw/*.zip;
do
  for l in $(unzip -Z1 "$f" | tail -5);
    do
      if basename "$l" | grep -i -s '\btraining\b'
        then
          TRAIN=$(basename "$l" | grep -i -s '\btraining\b');
        else
          printf "\t"
      fi
      if basename "$l" | grep -i -s '\bmetadata\b'
        then
          METADATA=$(basename "$l" | grep -i -s '\bmetadata\b');
        else
          printf "\t"
      fi
    done
done;
awk '{$1=$1};1'
echo "This is the file -> $TRAIN"
echo "This is the file -> $METADATA"

# Make executable with chmod +x process_data.sh
python ./src/data/extraction.py "$TRAIN" "$METADATA"
