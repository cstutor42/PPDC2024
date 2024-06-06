#!/bin/bash

# find . -name "Assign*.zip" -exec bash -c 'echo -e "\n {}"; unzip -Z1 {} | grep -Po "(?<=^|\/)(Set.*Test\.hs)$"' \;
ASSIGN_TEMPL=$(find . -maxdepth 1 -iname "*assignment*.zip" | grep -v "olution" | sort)

for zip_file in $ASSIGN_TEMPL; do

    # Make assignment test module

    ASSIGN_NUM=$(echo "$(basename "$zip_file")" | grep -Po "\d+")
    ASSIGN_MODULE="Assignment${ASSIGN_NUM}Test"
    echo "$zip_file  $ASSIGN_NUM"

    SETS=$(unzip -Z1 "$zip_file" | grep -Po "(?<=^|\/)(Set.*Test)(?=\.hs$)")
    IMPORTS=$(for SET in $SETS; do echo "import qualified $SET as $SET"; done)
    MAIN=$(for SET in $SETS; do echo "  $SET.main"; done)
    cat <<-EOF > "$ASSIGN_MODULE.hs"
module $ASSIGN_MODULE where

$IMPORTS

main = do
$MAIN
EOF

    # Submission archive bundler

    SUBMISSION="Submission$ASSIGN_NUM.zip"
    # [ -f "$SUBMISSION" ] && rm "$SUBMISSION"
    # zip "$SUBMISSION" $(echo "$SETS" | sed 's/Test$/.hs/')
    # echo "These are the files in $SUBMISSION:"; unzip -Z1 "$SUBMISSION"

done
