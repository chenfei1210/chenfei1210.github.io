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
  -e 's|、|, |g' \
  -e 's|〜| ~ |g' \
  -e 's|　| |g' \
  -e 's|なります|なる|g' \
  -e 's|しています|している|g' \
  -e 's|られます|られる|g' \
  -e 's|です|である|g' \
  -e 's|します|する|g' \
  -e 's|行います|行う|g' \
  -e 's|ています|ている|g' \
  -e 's|いいます|いう|g' \
  -e 's|あります|ある|g' \
  -e 's|用います|用いる|g' \
  -e 's|できません|できない|g' \
  -e 's|できます|できる|g' \
  -e 's|されます|される|g' \
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