#!/bin/sh

character_conversion() {
  echo "处理文件: $1"

  sed -i '' \
  -e 's|（|\(|g' \
  -e 's|）|\)|g' \
  -e 's|，|, |g' \
  -e 's|：|: |g' \
  -e 's|｛|{ |g' \
  -e 's|｝| }|g' \
  -e 's|％|%|g' \
  -e 's|［|[|g' \
  -e 's|］|]|g' \
  -e 's|／|/|g' \
  -e 's|なります|なる|g' \
  $1
}

if [ -z "$1" ]; then
  echo "处理所有文件"
  find . -type f -name "*.md" | while read -r file; do
    character_conversion $file
  done
else
  echo "处理指定文件"
  character_conversion $1
fi