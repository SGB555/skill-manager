---
name: image-compress
description: Compress images using free online API (resmush.it). Use when the user wants to compress images, reduce image file size, optimize images, or mentions image compression.
---

# Image Compression

Compress PNG, JPG, JPEG, and WebP images using the free resmush.it API.

## Usage

When the user provides an image path, run the compression script:

```bash
~/.cursor/skills/image-compress/scripts/compress.sh "<image_path>"
```

## Workflow

1. **Validate input**: Check the file exists and is a supported format
2. **Run compression**: Execute the script and show progress
3. **Display results**: Show before/after comparison
4. **Ask user preference**: Use AskQuestion tool to ask:
   - Replace original file
   - Create compressed copy (adds `-compressed` suffix)
5. **Execute choice**: Move or copy the compressed file accordingly

## Output Format

After compression, display results in this format:

```
📊 压缩结果对比

| 项目 | 压缩前 | 压缩后 | 变化 |
|------|--------|--------|------|
| 文件大小 | X.XX MB | X.XX MB | -XX% |
| 格式 | PNG | PNG | - |

✅ 压缩成功！
```

## Post-Compression Question

Use AskQuestion tool:

```
Question: "压缩完成！你希望如何处理压缩后的图片？"
Options:
  - "替换源文件" (replace)
  - "保存为新文件 (xxx-compressed.png)" (copy)
```

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| File not found | Path incorrect | Verify path exists |
| Unsupported format | Not PNG/JPG/JPEG/WebP | Convert to supported format first |
| API error | Network or file too large | Check network, max 5MB per image |
| No size reduction | Already optimized | File is already well-compressed |

## API Details

- **Service**: resmush.it (free, no API key required)
- **Max file size**: 5MB
- **Supported formats**: PNG, JPG, JPEG, WebP
- **Rate limit**: None (but be reasonable)
