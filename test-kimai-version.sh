#!/bin/sh

# An awk wizard can probably do this whole script in a single line ;)
MAJVER=$(echo $KIMAI | awk -F "." '{print $1}')
MINVER=$(echo $KIMAI | awk -F "." '{print $2}')

if test "${MAJVER}" -eq "1" && test "${MINVER}" -lt 11
then
  echo "+--------------------------------------------------------------------------+"
  echo "| Kimai versions older than 1.11 require composer 1.x                      |"
  echo "| To build older versions you'll need to use a tagged version of this repo |"
  echo "| https://github.com/tobybatch/kimai2/releases/tag/EOL-composer-1.x        |"
  echo "|                                                                          |"
  echo "| See https://github.com/tobybatch/kimai2/issues/180                       |"
  echo "+--------------------------------------------------------------------------+"
  return 1
fi

