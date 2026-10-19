#!/usr/bin/env node

import {
  hexFromArgb,
  argbFromHex,
  themeFromSourceColor,
  QuantizerCelebi,
  Score
} from "@material/material-color-utilities";

import { Jimp } from "jimp";
import fs from "node:fs";

const args = process.argv.slice(2);

function usage() {
  console.error(`usage:
  material-theme-image IMAGE
  material-theme-image --color '#RRGGBB'
  material-theme-image --palette '#RRGGBB' '#RRGGBB' ...
  material-theme-image --palette-json palette.json
  colorthief palette IMAGE --count 8 --json | material-theme-image --palette-json -`);
}

if (args.length === 0 || args[0] === "--help" || args[0] === "-h") {
  usage();
  process.exit(args.length === 0 ? 2 : 0);
}

function schemeToObject(scheme) {
  const out = {};
  for (const [key, value] of Object.entries(scheme.toJSON())) {
    out[key] = hexFromArgb(value);
  }
  return out;
}

function makeTheme(sourceArgb, sourcesArgb = [sourceArgb]) {
  const theme = themeFromSourceColor(sourceArgb);

  return {
    sources: sourcesArgb.map(hexFromArgb),
    source: hexFromArgb(sourceArgb),
    secondarySource: hexFromArgb(sourcesArgb[1] ?? sourceArgb),
    schemes: {
      light: schemeToObject(theme.schemes.light),
      dark: schemeToObject(theme.schemes.dark)
    }
  };
}

function unique(xs) {
  return [...new Set(xs)];
}

function extractHexesFromColorthiefJson(value) {
  if (!Array.isArray(value)) {
    throw new Error("palette JSON must be an array");
  }

  return value
    .map((x) => x?.hex)
    .filter((x) => typeof x === "string" && /^#[0-9a-fA-F]{6}$/.test(x));
}

async function rankedFromImage(path) {
  const image = await Jimp.read(path);
  image.resize({ w: 256 });

  const pixels = [];

  for (let y = 0; y < image.bitmap.height; y++) {
    for (let x = 0; x < image.bitmap.width; x++) {
      const idx = (image.bitmap.width * y + x) << 2;

      const r = image.bitmap.data[idx + 0];
      const g = image.bitmap.data[idx + 1];
      const b = image.bitmap.data[idx + 2];
      const a = image.bitmap.data[idx + 3];

      if (a < 255) continue;

      pixels.push(((255 << 24) | (r << 16) | (g << 8) | b) >>> 0);
    }
  }

  const quantized = QuantizerCelebi.quantize(pixels, 128);
  return Score.score(quantized);
}

let sourcesArgb;

if (args[0] === "--color") {
  const hex = args[1];
  if (!hex) {
    usage();
    process.exit(2);
  }
  sourcesArgb = [argbFromHex(hex)];
} else if (args[0] === "--palette") {
  const hexes = args.slice(1);
  if (hexes.length === 0) {
    usage();
    process.exit(2);
  }
  sourcesArgb = unique(hexes).map(argbFromHex);
} else if (args[0] === "--palette-json") {
  const path = args[1];
  if (!path) {
    usage();
    process.exit(2);
  }

  const raw = path === "-"
    ? fs.readFileSync(0, "utf8")
    : fs.readFileSync(path, "utf8");

  const hexes = extractHexesFromColorthiefJson(JSON.parse(raw));

  if (hexes.length === 0) {
    console.error("no hex colors found in palette JSON");
    process.exit(1);
  }

  sourcesArgb = unique(hexes).map(argbFromHex);
} else {
  sourcesArgb = await rankedFromImage(args[0]);
}

if (sourcesArgb.length === 0) {
  console.error("no suitable source color found");
  process.exit(1);
}

console.log(JSON.stringify(
  makeTheme(sourcesArgb[0], sourcesArgb),
  null,
  2
));
