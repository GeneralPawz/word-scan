// Packs existing icon PNGs (16/32/80/128) into a single .ico container.
// Modern Windows (Vista+) accepts raw PNG data per ICONDIRENTRY, so no re-encoding needed.
const fs = require("fs");
const path = require("path");

const assetsDir = path.join(__dirname, "..", "assets");
const sizes = [16, 32, 80, 128];
const images = sizes.map((size) => ({
  size,
  data: fs.readFileSync(path.join(assetsDir, `icon-${size}.png`)),
}));

const dir = Buffer.alloc(6);
dir.writeUInt16LE(0, 0); // reserved
dir.writeUInt16LE(1, 2); // type: icon
dir.writeUInt16LE(images.length, 4);

let offset = 6 + images.length * 16;
const entries = [];
for (const img of images) {
  const entry = Buffer.alloc(16);
  entry.writeUInt8(img.size >= 256 ? 0 : img.size, 0); // width
  entry.writeUInt8(img.size >= 256 ? 0 : img.size, 1); // height
  entry.writeUInt8(0, 2); // color count
  entry.writeUInt8(0, 3); // reserved
  entry.writeUInt16LE(1, 4); // planes
  entry.writeUInt16LE(32, 6); // bit count
  entry.writeUInt32LE(img.data.length, 8); // bytes in resource
  entry.writeUInt32LE(offset, 12); // offset
  entries.push(entry);
  offset += img.data.length;
}

const ico = Buffer.concat([dir, ...entries, ...images.map((i) => i.data)]);
const outPath = path.join(assetsDir, "icon-128.ico");
fs.writeFileSync(outPath, ico);
console.log(`wrote ${outPath} (${ico.length} bytes)`);
