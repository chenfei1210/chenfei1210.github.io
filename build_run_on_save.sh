#!/bin/sh

set -e

# === 1. 目录设置 ===
SRC_DIR="src"
OUT_DIR="output"
ASSETS_DIR="assets"
CHANGED_MD_FILE_PATH=$1

# === 2. 更新 HTML 到 output/ ===
echo "🛠️ 开始更新..."

# 构建路径
relative_path="${CHANGED_MD_FILE_PATH#$SRC_DIR/}"
htmlFile="${relative_path%.md}.html"
outFile="$OUT_DIR/$htmlFile"

# 构建style.css的相对路径，例如 ../../style.css
depth=$(dirname "$outFile" | awk -F/ '{print NF - 1}')
if ((depth >0)); then
  cssStylePath=$(printf '../%.0s' $(seq 1 $depth))$ASSETS_DIR/style.css
else
  cssStylePath="$ASSETS_DIR/style.css"
fi

# 删除旧html文件
if [ -f "$outFile" ]; then
  rm "$outFile"
fi

# 生成新html文件
pandoc "$CHANGED_MD_FILE_PATH" \
  --from markdown \
  --to html5 \
  -o "$outFile" \
  --standalone \
  --mathjax \
  --css="$cssStylePath" \
  --lua-filter="$ASSETS_DIR/fix-links.lua" \
  --include-before-body="$ASSETS_DIR/before.html" \
  --include-after-body="$ASSETS_DIR/after.html"

echo "📄 转换: $CHANGED_MD_FILE_PATH → $outFile"

# === 3. 检查新增的图片文件 ===

dir_path=$(dirname "$relative_path")
dir_src="$SRC_DIR/$dir_path/images"
dir_output="$OUT_DIR/$dir_path/images"

# 在src中递归查找所有.png 文件
if [ -d "$dir_src" ]; then
  find "$dir_src" -type f \( -iname '*.png' \) | while read -r file_src; do
    # 获取相对于src的路径
    image_relative_path="${file_src#$dir_src/}"

    # 构建output中的对应路径
    file_output="$dir_output/$image_relative_path"

    # 如果 A 中没有该文件，则复制
    if [ ! -f "$file_output" ]; then
      mkdir -p "$(dirname "$file_output")"
      cp "$file_src" "$file_output"
      echo "📄 复制: $file_src → $file_output"
    fi
  done
fi

echo "✅ 更新完成!"
