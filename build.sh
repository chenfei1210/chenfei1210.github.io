#!/bin/bash

set -e

# === 1. 目录与分支设置 ===
SRC_DIR="src"
OUT_DIR="output"
ASSETS_DIR="assets"

# === 2. 构建 HTML 到 output/ ===
echo "🛠️ 开始构建..."

# 清空输出目录
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# 拷贝 CSS 等静态资源
cp -r "$ASSETS_DIR" "$OUT_DIR"

# === 3. 合并处理 Markdown 和图片 ===
echo "🔍 扫描并处理源文件..."
find "$SRC_DIR" \( -name "*.md" -o -type d -name "images" \) | while read -r item; do
    if [[ "$item" == *.md ]]; then
        # 处理 Markdown 文件
        # 构建路径
        relative_path="${item#$SRC_DIR/}"
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

        # 使用 Pandoc 转换
        pandoc "$item" \
          --from markdown \
          --to html5 \
          -o "$outFile" \
          --standalone \
          --mathjax \
          --css="$cssStylePath" \
          --lua-filter="$ASSETS_DIR/fix-links.lua" \
          --include-before-body="$ASSETS_DIR/before.html" \
          --include-after-body="$ASSETS_DIR/after.html"
        
        # echo "📄 转换: $item → $outFile"
    else
        # 处理 images 文件夹
        # 构建路径
        relative_path="${item#$SRC_DIR/}"
        parent_dir="${relative_path%/images}"
        mkdir -p "$OUT_DIR/$parent_dir"

        cp -r "$item" "$OUT_DIR/$parent_dir/"

        # echo "🖼️  复制: $item → $OUT_DIR/$parent_dir/"
    fi
done

echo "✅ 构建完成！"
# echo "输出目录：$OUT_DIR"
# echo "包含以下内容："
# find "$OUT_DIR" -type f | sed "s|^$OUT_DIR/||"