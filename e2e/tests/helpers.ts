import { Page } from '@playwright/test';

// Flutter rendert semantische Elemente in <flt-semantics-host> (außerhalb Shadow DOM).
// Accessibility muss zuerst aktiviert werden (flt-semantics-placeholder klicken).
// Danach sind flt-semantics[role="button"] per Text-Content auffindbar.

export async function waitForFlutter(page: Page): Promise<void> {
  await page.waitForFunction(() => {
    const glassPane = document.querySelector('flt-glass-pane');
    return glassPane?.shadowRoot != null;
  }, { timeout: 15_000 });
}

async function enableAccessibility(page: Page): Promise<void> {
  await page.waitForSelector('flt-semantics-placeholder', { timeout: 10_000 });
  // flt-semantics-placeholder liegt außerhalb des Viewports — direkt per JS aktivieren
  await page.evaluate(() => {
    const el = document.querySelector('flt-semantics-placeholder') as HTMLElement | null;
    if (el) {
      el.dispatchEvent(new PointerEvent('pointerdown', { bubbles: true, cancelable: true, isPrimary: true }));
      el.dispatchEvent(new PointerEvent('pointerup', { bubbles: true, cancelable: true, isPrimary: true }));
      el.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true }));
    }
  });
  await page.waitForFunction(() => {
    const host = document.querySelector('flt-semantics-host');
    return host != null && host.children.length > 0;
  }, { timeout: 10_000 });
}

export async function clickFlutterButton(page: Page, label: string): Promise<void> {
  await waitForFlutter(page);
  await enableAccessibility(page);

  await page.waitForFunction((lbl) => {
    const host = document.querySelector('flt-semantics-host');
    if (!host) return false;
    const buttons = host.querySelectorAll('flt-semantics[role="button"]');
    return Array.from(buttons).some(el => el.textContent?.trim() === lbl);
  }, label, { timeout: 15_000 });

  const btn = page.locator('flt-semantics[role="button"]').filter({ hasText: label }).first();
  await btn.click({ force: true });
}

export async function flutterTextExists(page: Page, text: string): Promise<boolean> {
  await enableAccessibility(page);
  return page.evaluate((txt) => {
    const host = document.querySelector('flt-semantics-host');
    return host?.textContent?.includes(txt) ?? false;
  }, text);
}
