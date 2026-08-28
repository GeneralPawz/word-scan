// Hand-rolled PNG encoder (no dependencies) that draws a simple flat "scan into document"
// glyph: a blue rounded square, a white document, and a cyan scan line.
// Used to (re)generate addin/assets/icon-*.png and the repo logo.
const fs = require("fs");
const path = require("path");
const zlib = require("zlib");

const BLUE = [0x18, 0x5a, 0xbd, 255]; // brand blue background
const WHITE = [0xff, 0xff, 0xff, 255]; // document
const CYAN = [0x00, 0xd4, 0xd4, 255]; // scan line
const LIGHT = [0xdf, 0xef, 0xff, 255]; // faint document lines

function crc32(buf) {
  let table = crc32.table;
  if (!table) {
    table = crc32.table = new Uint32Array(256);
    for (let n = 0; n < 256; n++) {
      let c = n;
      for (let k = 0; k < 8; k++) {
        c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
      }
      table[n] = c >>> 0;
    }
  }
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    crc = table[(crc ^ buf[i]) & 0xff] ^ (crc >>> 8);
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function chunk(type, data) {
  const typeBuf = Buffer.from(type, "ascii");
  const lenBuf = Buffer.alloc(4);
  lenBuf.writeUInt32BE(data.length, 0);
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
  return Buffer.concat([lenBuf, typeBuf, data, crcBuf]);
}

function encodePNG(width, height, rgba) {
  const sig = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);

  const ihdrData = Buffer.alloc(13);
  ihdrData.writeUInt32BE(width, 0);
  ihdrData.writeUInt32BE(height, 4);
  ihdrData[8] = 8; // bit depth
  ihdrData[9] = 6; // color type: RGBA
  ihdrData[10] = 0;
  ihdrData[11] = 0;
  ihdrData[12] = 0;
  const ihdr = chunk("IHDR", ihdrData);

  const stride = width * 4;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0; // no filter
    rgba.copy(raw, y * (stride + 1) + 1, y * stride, y * stride + stride);
  }
  const idat = chunk("IDAT", zlib.deflateSync(raw, { level: 9 }));

  const iend = chunk("IEND", Buffer.alloc(0));

  return Buffer.concat([sig, ihdr, idat, iend]);
}

function drawIcon(size) {
  const rgba = Buffer.alloc(size * size * 4);
  const set = (x, y, color) => {
    if (x < 0 || y < 0 || x >= size || y >= size) return;
    const i = (y * size + x) * 4;
    rgba[i] = color[0];
    rgba[i + 1] = color[1];
    rgba[i + 2] = color[2];
    rgba[i + 3] = color[3];
  };

  const corner = size * 0.22;
  const insideCorner = (x, y) => {
    // rounds the four corners of the square background
    const cx = x < corner ? corner : x > size - 1 - corner ? size - 1 - corner : null;
    const cy = y < corner ? corner : y > size - 1 - corner ? size - 1 - corner : null;
    if (cx === null || cy === null) return true;
    const dx = x - cx;
    const dy = y - cy;
    return dx * dx + dy * dy <= corner * corner;
  };

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      if (insideCorner(x, y)) set(x, y, BLUE);
    }
  }

  // Document: white rounded rect, slightly right-of-center to suggest paper feeding through.
  const docLeft = Math.round(size * 0.30);
  const docRight = Math.round(size * 0.80);
  const docTop = Math.round(size * 0.18);
  const docBottom = Math.round(size * 0.82);
  const docCorner = Math.max(1, Math.round(size * 0.04));

  const insideDoc = (x, y) => {
    if (x < docLeft || x > docRight || y < docTop || y > docBottom) return false;
    const cx =
      x < docLeft + docCorner ? docLeft + docCorner : x > docRight - docCorner ? docRight - docCorner : null;
    const cy =
      y < docTop + docCorner ? docTop + docCorner : y > docBottom - docCorner ? docBottom - docCorner : null;
    if (cx === null || cy === null) return true;
    const dx = x - cx;
    const dy = y - cy;
    return dx * dx + dy * dy <= docCorner * docCorner;
  };

  for (let y = docTop; y <= docBottom; y++) {
    for (let x = docLeft; x <= docRight; x++) {
      if (insideDoc(x, y)) set(x, y, WHITE);
    }
  }

  // Faint text lines on the document.
  const lineInset = Math.round(size * 0.06);
  [0.32, 0.42, 0.52].forEach((f) => {
    const y = Math.round(size * f);
    for (let x = docLeft + lineInset; x <= docRight - lineInset; x++) {
      if (insideDoc(x, y)) set(x, y, LIGHT);
    }
  });

  // Cyan scan line crossing the document, with a soft glow (two extra rows).
  const scanY = Math.round(size * 0.66);
  for (let x = docLeft - 2; x <= docRight + 2; x++) {
    set(x, scanY - 1, CYAN);
    set(x, scanY, CYAN);
    set(x, scanY + 1, CYAN);
  }

  return encodePNG(size, size, rgba);
}

const outDir = process.argv[2] || path.join(__dirname, "..", "addin", "assets");
fs.mkdirSync(outDir, { recursive: true });

const sizes = [16, 32, 80, 128];
for (const size of sizes) {
  const buf = drawIcon(size);
  const file = path.join(outDir, `icon-${size}.png`);
  fs.writeFileSync(file, buf);
  console.log(`wrote ${file} (${buf.length} bytes)`);
}
