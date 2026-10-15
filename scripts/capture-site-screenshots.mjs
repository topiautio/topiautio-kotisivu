#!/usr/bin/env node
// Ottaa kuvakaappauksen jokaisesta rakennetun sivuston sivusta PR-tarkistusta varten.
// Käyttö: node scripts/capture-site-screenshots.mjs [public] [screenshots]
// Chrome: CHROME_BIN tai PUPPETEER_EXECUTABLE_PATH.

import { createServer } from "node:http";
import { readdir, readFile, mkdir, stat } from "node:fs/promises";
import { extname, join, relative, resolve, sep } from "node:path";
import puppeteer from "puppeteer";

const siteDir = resolve(process.argv[2] ?? "public");
const outDir = resolve(process.argv[3] ?? "screenshots");
const width = Number(process.env.SCREENSHOT_WIDTH ?? 1440);
const height = Number(process.env.SCREENSHOT_HEIGHT ?? 1600);
const executablePath = process.env.PUPPETEER_EXECUTABLE_PATH ?? process.env.CHROME_BIN;

const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css",
  ".js": "text/javascript",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".webp": "image/webp",
  ".woff2": "font/woff2",
  ".xml": "application/xml",
};

async function* indexPages(dir) {
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) yield* indexPages(path);
    else if (entry.name === "index.html") yield path;
  }
}

// Sivut palvellaan HTTP:n yli, koska juuripolun osoitteet (/styles.css) eivät toimi file://-osoitteilla.
const server = createServer(async (req, res) => {
  try {
    let path = resolve(siteDir, "." + decodeURIComponent(new URL(req.url, "http://x").pathname));
    if (path !== siteDir && !path.startsWith(siteDir + sep)) throw new Error("outside");
    if ((await stat(path)).isDirectory()) path = join(path, "index.html");
    res.writeHead(200, { "Content-Type": types[extname(path)] ?? "application/octet-stream" });
    res.end(await readFile(path));
  } catch {
    res.writeHead(404).end();
  }
});
await new Promise((ok) => server.listen(0, "127.0.0.1", ok));
const base = `http://127.0.0.1:${server.address().port}`;

await mkdir(outDir, { recursive: true });
const browser = await puppeteer.launch({
  executablePath,
  args: ["--no-sandbox", "--disable-dev-shm-usage"],
});
try {
  const page = await browser.newPage();
  await page.setViewport({ width, height });
  const pages = [];
  for await (const file of indexPages(siteDir)) pages.push(file);
  for (const file of pages.sort()) {
    const route = relative(siteDir, file).replace(/index\.html$/, "");
    const name = route === "" ? "home" : route.replace(/\/$/, "").replaceAll("/", "--");
    await page.goto(`${base}/${route}`, { waitUntil: "networkidle0" });
    await page.evaluate(() => document.fonts.ready);
    await page.screenshot({ path: join(outDir, `${name}.png`) });
    console.log(`${name}.png`);
  }
} finally {
  await browser.close();
  server.close();
}
