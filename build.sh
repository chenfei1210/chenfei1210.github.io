#!/bin/bash

set -e


# === 1. 目录与分支设置 ===
SRC_DIR="src"
OUT_DIR="output"
ASSETS_DIR="assets"

# === 2. 构建 HTML 到 output/ ===
echo "🛠️ 生成 HTML 文件..."

# 清空输出目录
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# 拷贝 CSS 等静态资源
cp -r "$ASSETS_DIR" "$OUT_DIR"

# 转换 Markdown 为 HTML（保留目录结构）
# 遍历 src 目录下所有 Markdown 文件
find "$SRC_DIR" -name "*.md" | while read mdFile; do
    # 构建路径
    relative_path="${mdFile#$SRC_DIR/}"
    htmlFile="${relative_path%.md}.html"
    outFile="$OUT_DIR/$htmlFile"
    mkdir -p "$(dirname "$outFile")"

    # 构建style.css的相对路径，例如 ../../style.css
    depth=$(dirname "$outFile" | awk -F/ '{print NF - 1}')
    if (( depth > 0 )); then
    cssStylePath=$(printf '../%.0s' $(seq 1 $depth))$ASSETS_DIR/style.css
    else
    cssStylePath="$ASSETS_DIR/style.css"
    fi
    # echo "cssStylePath: $cssStylePath"

    # 使用 Pandoc 转换
    # echo -e "Converting\n$mdFile\n->\n$outFile\nwith CSS: $cssStylePath"
    pandoc "$mdFile" \
      --from markdown \
      --to html5 \
      -o "$outFile" \
      --standalone \
      --mathjax \
      --css="$cssStylePath" \
      --lua-filter="$ASSETS_DIR/fix-links.lua" \
      --include-before-body="$ASSETS_DIR/before.html" \
      --include-after-body="$ASSETS_DIR/after.html" \

done

echo "✅ 生成 HTML 文件完成，输出目录：$OUT_DIR"
# echo "🧪 构建结果预览："
# find output