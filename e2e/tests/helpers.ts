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
  await page.evaluate(() => {
    const btn = document.querySelector('flt-semantics-placeholder') as HTMLElement | null;
    if (btn) btn.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true }));
  });
  // Warten bis flt-semantics-host Elemente enthält
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

  await page.evaluate((lbl) => {
    const host = document.querySelector('flt-semantics-host');
    const buttons = host?.querySelectorAll('flt-semantics[role="button"]') ?? [];
    const btn = Array.from(buttons).find(el => el.textContent?.trim() === lbl) as HTMLElement | null;
    btn?.click();
  }, label);
}

export async function flutterTextExists(page: Page, text: string): Promise<boolean> {
  await enableAccessibility(page);
  return page.evaluate((txt) => {
    const host = document.querySelector('flt-semantics-host');
    return host?.textContent?.includes(txt) ?? false;
  }, text);
}
