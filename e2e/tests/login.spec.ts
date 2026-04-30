import { test, expect } from '@playwright/test';
import { waitForFlutter, flutterTextExists, clickFlutterButton } from './helpers';

// Läuft ohne gespeicherten Auth-State — simuliert einen nicht eingeloggten Nutzer
test.use({ storageState: { cookies: [], origins: [] } });

test('zeigt Login-Seite für unauthenticated user', async ({ page }) => {
  await page.goto('/');
  await waitForFlutter(page);
  expect(await flutterTextExists(page, 'Anmelden')).toBe(true);
});

test('Login-Button leitet zu Keycloak weiter', async ({ page }) => {
  await page.goto('/');
  await waitForFlutter(page);
  await clickFlutterButton(page, 'Anmelden');
  await expect(page).toHaveURL(/localhost:8080/, { timeout: 10_000 });
});
