import { test, expect } from '@playwright/test';
import { waitForFlutter, clickFlutterButton } from './helpers';

// Flutter speichert den Refresh Token in IndexedDB, nicht in localStorage.
// Playwright's storageState erfasst IndexedDB nicht — deshalb loggt jeder Test
// der Auth benötigt sich selbst ein, anstatt user.json zu verwenden.

async function loginViaKeycloak(page: import('@playwright/test').Page) {
  await page.goto('/');
  await waitForFlutter(page);

  await clickFlutterButton(page, 'Anmelden');
  await page.waitForURL(/localhost:8080/, { timeout: 10_000 });

  await page.fill('#username', process.env.KEYCLOAK_TEST_USER ?? 'testuser');
  await page.fill('#password', process.env.KEYCLOAK_TEST_PASSWORD ?? 'test');
  await page.getByRole('button', { name: /sign in/i }).click();

  await page.waitForURL(/localhost:3000/, { timeout: 15_000 });

  // Warten bis der Token-Austausch abgeschlossen ist und die App eingeloggt ist
  await page.waitForFunction(() => {
    const host = document.querySelector('flt-semantics-host');
    if (!host) return false;
    const buttons = host.querySelectorAll('flt-semantics[role="button"]');
    return !Array.from(buttons).some(el => el.textContent?.trim() === 'Anmelden');
  }, { timeout: 20_000 });

  await waitForFlutter(page);
}

test.use({ storageState: { cookies: [], origins: [] } });

test('Dashboard ist nach Login erreichbar', async ({ page }) => {
  await loginViaKeycloak(page);
  await expect(page).toHaveURL(/\/$|\/dashboard/, { timeout: 10_000 });
});

test('Einstellungsseite ist erreichbar', async ({ page }) => {
  await loginViaKeycloak(page);
  await page.goto('/settings');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/settings/);
});

test('Suchseite ist erreichbar', async ({ page }) => {
  await loginViaKeycloak(page);
  await page.goto('/search');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/search/);
});

test('Historien-Seite ist erreichbar', async ({ page }) => {
  await loginViaKeycloak(page);
  await page.goto('/history');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/history/);
});
