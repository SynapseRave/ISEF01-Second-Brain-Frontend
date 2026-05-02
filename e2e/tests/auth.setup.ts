import { test as setup } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import { waitForFlutter, clickFlutterButton } from './helpers';

const authFile = 'playwright/.auth/user.json';

setup('authenticate', async ({ page }) => {
  // ?semantics=1 aktiviert Flutter-Accessibility ohne Button-Klick
  await page.goto('/?semantics=1');
  await waitForFlutter(page);

  await clickFlutterButton(page, 'Anmelden');

  await page.waitForURL(/localhost:8080/, { timeout: 15_000 });

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
