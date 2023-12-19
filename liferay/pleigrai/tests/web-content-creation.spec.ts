import { Page, test } from '@playwright/test';
import { login } from '../util/login';
import createWebContent from '../util/createWebContent';

test.describe('Create web contents', () => {
  let page: Page;

  test.beforeAll(async ({ browser }) => {
    page = await browser.newPage();
  });

  test.afterAll(async () => {
    await page.close();
  });

  test('Login', async () => {
    await login(page);
  });

  for (let i = 0; i < 1000; i++) {
    test(`Create Web Content ${i}`, async () => {
      await createWebContent(page, `Test Web Content ${i}`);
    });
  }
});
