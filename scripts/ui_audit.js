const { chromium } = require("playwright");
const fs = require("fs");
const path = require("path");

const baseUrl = "http://127.0.0.1:8081";
const outDir = path.resolve(__dirname, "..", "build", "ui-audit");

const pages = [
  "/",
  "/checker",
  "/guides/public-water-vs-private-well",
  "/compare/under-sink-certified-pfas-options",
  "/public-water/PA1510001",
  "/private-well/CA",
  "/filters/aquasana-aq-6200",
  "/filters/brands/aquasana",
  "/methodology",
  "/source-policy"
];

const viewports = [
  { name: "desktop", width: 1280, height: 720, isMobile: false, hasTouch: false, deviceScaleFactor: 1 },
  { name: "iphone-se", width: 375, height: 667, isMobile: true, hasTouch: true, deviceScaleFactor: 2 }
];

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function sanitize(name) {
  return name.replace(/[^\w\-]+/g, "_");
}

async function collectOverflow(page) {
  return await page.evaluate(() => {
    const doc = document.documentElement;
    const body = document.body;
    const viewportWidth = window.innerWidth;
    const scrollWidth = Math.max(doc.scrollWidth, body ? body.scrollWidth : 0);
    const overflowX = scrollWidth - viewportWidth;

    const offenders = [];
    const elements = Array.from(document.querySelectorAll("body *"));
    for (const el of elements) {
      const rect = el.getBoundingClientRect();
      if (rect.width === 0 || rect.height === 0) {
        continue;
      }
      if (rect.right > viewportWidth + 1 || rect.left < -1) {
        const cls = el.className && typeof el.className === "string" ? el.className.trim().split(/\s+/).slice(0, 3).join(".") : "";
        const tag = el.tagName.toLowerCase();
        const selector = cls ? `${tag}.${cls}` : tag;
        offenders.push({
          selector,
          left: Math.round(rect.left),
          right: Math.round(rect.right),
          width: Math.round(rect.width)
        });
        if (offenders.length >= 8) {
          break;
        }
      }
    }

    return {
      viewportWidth,
      scrollWidth,
      overflowX,
      offenders
    };
  });
}

async function run() {
  ensureDir(outDir);
  const browser = await chromium.launch({ headless: true });
  const report = {
    baseUrl,
    timestamp: new Date().toISOString(),
    results: []
  };

  for (const viewport of viewports) {
    const context = await browser.newContext({
      viewport: { width: viewport.width, height: viewport.height },
      deviceScaleFactor: viewport.deviceScaleFactor,
      isMobile: viewport.isMobile,
      hasTouch: viewport.hasTouch
    });
    const page = await context.newPage();
    const consoleErrors = [];
    page.on("console", (msg) => {
      if (msg.type() === "error") {
        consoleErrors.push(msg.text());
      }
    });

    for (const route of pages) {
      const url = baseUrl + route;
      const entry = { viewport: viewport.name, route, url, status: "ok" };
      try {
        const response = await page.goto(url, { waitUntil: "networkidle", timeout: 45000 });
        entry.httpStatus = response ? response.status() : null;
        await page.waitForTimeout(1000);
        entry.overflow = await collectOverflow(page);
        const shotName = `${viewport.name}__${sanitize(route || "home")}.png`;
        await page.screenshot({ path: path.join(outDir, shotName), fullPage: true });
        entry.screenshot = shotName;
        entry.consoleErrors = consoleErrors.slice(0, 10);
      } catch (err) {
        entry.status = "error";
        entry.error = String(err);
      }
      report.results.push(entry);
    }

    await context.close();
  }

  fs.writeFileSync(path.join(outDir, "report.json"), JSON.stringify(report, null, 2));
  await browser.close();
  console.log(`UI audit complete. Report at ${path.join(outDir, "report.json")}`);
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
