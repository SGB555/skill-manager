#!/bin/bash

# Image Compression Script
# Uses resmush.it free API (no registration required)
#
# Usage: ./compress.sh <image_path>

set -e

IMAGE_PATH="$1"
SUPPORTED_FORMATS="png|jpg|jpeg|webp"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes} B"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(echo "scale=2; $bytes/1024" | bc) KB"
    else
        echo "$(echo "scale=2; $bytes/1048576" | bc) MB"
    fi
}

# Validate input
if [ -z "$IMAGE_PATH" ]; then
    echo -e "${RED}用法: ./compress.sh <image_path>${NC}"
    echo "示例: ./compress.sh ./photo.png"
    exit 1
fi

# Check file exists
if [ ! -f "$IMAGE_PATH" ]; then
    echo -e "${RED}❌ 错误: 文件不存在 - $IMAGE_PATH${NC}"
    exit 1
fi

# Get absolute path
ABSOLUTE_PATH=$(cd "$(dirname "$IMAGE_PATH")" && pwd)/$(basename "$IMAGE_PATH")
FILENAME=$(basename "$ABSOLUTE_PATH")
EXT="${FILENAME##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
BASENAME="${FILENAME%.*}"
DIR=$(dirname "$ABSOLUTE_PATH")

# Validate format
if ! echo "$EXT_LOWER" | grep -qE "^($SUPPORTED_FORMATS)$"; then
    echo -e "${RED}❌ 错误: 不支持的格式 \".$EXT_LOWER\"${NC}"
    echo "   支持的格式: png, jpg, jpeg, webp"
    exit 1
fi

# Get original size
ORIGINAL_SIZE=$(stat -f%z "$ABSOLUTE_PATH" 2>/dev/null || stat -c%s "$ABSOLUTE_PATH" 2>/dev/null)

echo ""
echo -e "🖼️  开始压缩: ${YELLOW}$FILENAME${NC}"
echo "📁 原始大小: $(format_bytes $ORIGINAL_SIZE)"
echo ""
echo "⏳ 压缩进度:"
echo "   [1/3] 上传图片..."

# Call resmush.it API
RESPONSE=$(curl -s -X POST -F "files=@$ABSOLUTE_PATH" "http://api.resmush.it/?qlty=85")

# Check for error
if echo "$RESPONSE" | grep -q '"error"'; then
    ERROR_MSG=$(echo "$RESPONSE" | grep -o '"error_long":"[^"]*"' | cut -d'"' -f4)
    echo -e "${RED}❌ API 错误: $ERROR_MSG${NC}"
    exit 1
fi

echo "   [2/3] 压缩完成，下载中..."

# Extract download URL
DOWNLOAD_URL=$(echo "$RESPONSE" | grep -o '"dest":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')
COMPRESSED_SIZE=$(echo "$RESPONSE" | grep -o '"dest_size":[0-9]*' | cut -d':' -f2)

# Download compressed image
OUTPUT_PATH="$DIR/${BASENAME}-compressed.${EXT_LOWER}"
curl -s -o "$OUTPUT_PATH" "$DOWNLOAD_URL"

echo "   [3/3] 保存完成!"

# Calculate savings
SAVED_BYTES=$((ORIGINAL_SIZE - COMPRESSED_SIZE))
SAVED_PERCENT=$(echo "scale=1; ($SAVED_BYTES * 100) / $ORIGINAL_SIZE" | bc)

echo ""
echo -e "${GREEN}✅ 压缩完成!${NC}"
echo ""

# Output JSON result for parsing
echo "--- COMPRESSION_RESULT_JSON ---"
cat << EOF
{
  "success": true,
  "originalPath": "$ABSOLUTE_PATH",
  "compressedPath": "$OUTPUT_PATH",
  "originalSize": $ORIGINAL_SIZE,
  "compressedSize": $COMPRESSED_SIZE,
  "savedBytes": $SAVED_BYTES,
  "savedPercent": $SAVED_PERCENT,
  "format": "$(echo $EXT_LOWER | tr '[:lower:]' '[:upper:]')"
}
EOF
echo "--- END_COMPRESSION_RESULT_JSON ---"
