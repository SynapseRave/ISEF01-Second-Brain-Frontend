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
  // Primär: ?semantics=1 in der URL aktiviert Accessibility beim Flutter-Start.
  // Fallback: flt-semantics-placeholder anklicken falls noch nicht aktiv.
  const alreadyActive = await page.evaluate(() => {
    const host = document.querySelector('flt-semantics-host');
    return host != null && host.children.length > 0;
  });
  if (alreadyActive) return;

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

  // Koordinaten des Semantics-Elements ermitteln und per mouse.click auf den Canvas schicken,
  // da Flutter Klick-Events auf Canvas-Koordinaten auswertet, nicht auf Semantics-Overlays.
  const coords = await page.evaluate((lbl) => {
    const host = document.querySelector('flt-semantics-host');
    const buttons = host?.querySelectorAll('flt-semantics[role="button"]') ?? [];
    const btn = Array.from(buttons).find(el => el.textContent?.trim() === lbl);
    if (!btn) return null;
    const rect = btn.getBoundingClientRect();
    return { x: rect.left + rect.width / 2, y: rect.top + rect.height / 2 };
  }, label);

  if (!coords) throw new Error(`Flutter button "${label}" not found`);
  await page.mouse.click(coords.x, coords.y);
}

export async function flutterTextExists(page: Page, text: string): Promise<boolean> {
  await enableAccessibility(page);
  return page.evaluate((txt) => {
    const host = document.querySelector('flt-semantics-host');
    return host?.textContent?.includes(txt) ?? false;
  }, text);
}
