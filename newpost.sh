#!/bin/bash

set -e

prefix=`date +"%Y-%m-%d"`

filename=`echo $@ \
  | tr '[:upper:]' '[:lower:]' \
  | sed -e 's/ /-/g' \
  | sed -e 's/[^a-z0-9\-]//g'`

cat > _posts/$prefix-$filename.md << EOF
---
title: $@
categories:
---
EOF

echo "Created _posts/$prefix-$filename.md"
