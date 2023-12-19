import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: false,
  retries: 0,
  workers: undefined,
  reporter: 'html',
  use: { trace: 'on-first-retry' },
  projects: [
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'], headless: true },
    },
  ],
});
