import { test, expect } from '@playwright/test';
import { waitForFlutter } from './helpers';

// Läuft ohne gespeicherten Auth-State — prüft Route Guards
test.use({ storageState: { cookies: [], origins: [] } });

test('geschützte Route /settings leitet zu /login weiter', async ({ page }) => {
  await page.goto('/settings');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/login/, { timeout: 10_000 });
});

test('geschützte Route /history leitet zu /login weiter', async ({ page }) => {
  await page.goto('/history');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/login/, { timeout: 10_000 });
});

test('geschützte Route /search leitet zu /login weiter', async ({ page }) => {
  await page.goto('/search');
  await waitForFlutter(page);
  await expect(page).toHaveURL(/\/login/, { timeout: 10_000 });
});
