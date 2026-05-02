import { test as setup } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import { waitForFlutter, clickFlutterButton } from './helpers';

const authFile = 'playwright/.auth/user.json';

setup('authenticate', async ({ page }) => {
  await page.goto('/');
  await waitForFlutter(page);

  // Debug: DOM-Zustand vor dem Klick loggen
  const domInfo = await page.evaluate(() => {
    const host = document.querySelector('flt-semantics-host');
    const buttons = host?.querySelectorAll('flt-semantics[role="button"]') ?? [];
    return {
      hostExists: !!host,
      hostChildren: host?.children.length ?? 0,
      buttons: Array.from(buttons).map(b => ({
        text: b.textContent?.trim(),
        rect: JSON.stringify(b.getBoundingClientRect()),
      })),
      url: location.href,
    };
  });
  console.log('DOM before click:', JSON.stringify(domInfo, null, 2));

  await clickFlutterButton(page, 'Anmelden');
  console.log('Button clicked, current URL:', page.url());

  await page.screenshot({ path: 'test-results/after-click.png' });

  await page.waitForURL(/localhost:8080/, { timeout: 10_000 });

  await page.fill('#username', process.env.KEYCLOAK_TEST_USER ?? 'testuser');
  await page.fill('#password', process.env.KEYCLOAK_TEST_PASSWORD ?? 'test');
  await page.getByRole('button', { name: /sign in/i }).click();

  // Keycloak leitet zurück zu localhost:3000 mit ?code= in der URL.
  // Die App bleibt auf dieser URL und zeigt das Dashboard — kein Redirect.
  await page.waitForURL(/localhost:3000/, { timeout: 15_000 });

  // Warten bis die Login-Seite verschwunden ist (kein "Anmelden"-Button mehr)
  await page.waitForFunction(() => {
    const host = document.querySelector('flt-semantics-host');
    if (!host) return false;
    const buttons = host.querySelectorAll('flt-semantics[role="button"]');
    return !Array.from(buttons).some(el => el.textContent?.trim() === 'Anmelden');
  }, { timeout: 20_000 });

  await waitForFlutter(page);

  fs.mkdirSync(path.dirname(authFile), { recursive: true });
  await page.context().storageState({ path: authFile });
});
