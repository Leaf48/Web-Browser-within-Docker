import asyncio
from playwright.async_api import async_playwright

URL = "https://google.com"


async def main():
    async with async_playwright() as p:
        browser = await p.chromium.connect_over_cdp("http://localhost:9222")

        if browser.contexts:
            ctx = browser.contexts[0]
        else:
            ctx = await browser.new_context()
        page = await ctx.new_page()

        await page.goto(URL, wait_until="domcontentloaded")
        print("title:", await page.title())

        await page.screenshot(path="browserscan.png")

        await browser.close()


asyncio.run(main())
