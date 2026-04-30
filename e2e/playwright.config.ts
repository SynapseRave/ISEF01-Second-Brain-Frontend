import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30_000,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: process.env.CI ? 'github' : 'list',

  use: {
    baseURL: process.env.APP_URL ?? 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'setup',
      testMatch: /auth\.setup\.ts/,
    },
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'playwright/.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],

  // Nur lokal: Flutter-App automatisch starten
  // In CI wird die App separat gebaut und per `serve` bereitgestellt
  webServer: process.env.CI
    ? undefined
    : {
        command:
          'flutter run -d web-server --web-port=3000' +
          ' --dart-define=API_BASE_URL=http://localhost:8000' +
          ' --dart-define=KEYCLOAK_URL=http://localhost:8080' +
          ' --dart-define=KEYCLOAK_REALM=second-brain' +
          ' --dart-define=KEYCLOAK_CLIENT_ID=frontend',
        url: 'http://localhost:3000',
        reuseExistingServer: true,
        cwd: '..',
      },
});
