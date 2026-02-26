import { chromium } from "playwright";
import fs from "node:fs/promises";

const previewUrl = (process.argv[2] || "").replace(/\/$/, "");
if (!previewUrl) {
  console.error("Usage: node .github/scripts/playwright_preview_capture.mjs <preview-url>");
  process.exit(1);
}

await fs.mkdir("output/playwright", { recursive: true });
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage();

await page.goto(`${previewUrl}/registration/new`, { waitUntil: "networkidle" });
await page.screenshot({ path: "output/playwright/preview-registration-new.png", fullPage: true });

await page.goto(`${previewUrl}/`, { waitUntil: "networkidle" });
await page.screenshot({ path: "output/playwright/preview-home.png", fullPage: true });

await browser.close();
console.log("Captured Playwright preview screenshots.");
