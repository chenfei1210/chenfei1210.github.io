#!/bin/sh

find . -type f -name "*.md" | while read -r file; do
  echo "处理文件：$file"

  sed -i '' \
  -e 's|（|\(|g' \
  -e 's|）|\)|g' \
  -e 's|，|, |g' \
  -e 's|：|: |g' \
  -e 's|｛|{ |g' \
  -e 's|｝| }|g' \
  $file

done