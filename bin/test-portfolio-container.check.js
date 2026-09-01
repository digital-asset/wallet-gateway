const { chromium } = require("playwright");

const port = process.env.PORT;
if (!port) {
  console.error("PORT env var is required");
  process.exit(1);
}
const url = `http://localhost:${port}/connect`;

async function main() {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  page.setDefaultTimeout(15000);

  const response = await page.goto(url, { waitUntil: "load" });
  if (!response || response.status() !== 200) {
    throw new Error(
      `Expected 200 from ${url}, got ${response && response.status()}`,
    );
  }
  console.log(`${url} returned 200`);

  const header = page.locator("h1", { hasText: "Splice Portfolio" });
  await header.waitFor({ state: "visible" });
  console.log("Found header: Splice Portfolio");

  const button = page.locator("button", { hasText: "Connect Wallet" });
  await button.waitFor({ state: "visible" });
  console.log("Found button: Connect Wallet");

  await browser.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
