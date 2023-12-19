import { Page } from "@playwright/test";

export async function login(page: Page) {
  await page.goto(
    'http://localhost:8080/?p_p_id=com_liferay_login_web_portlet_LoginPortlet&p_p_lifecycle=0&p_p_state=maximized&p_p_mode=view',
  );

  await page.getByLabel('Email Address').fill('test@liferay.com', {force: true});
  await page.getByLabel('Password').fill('test');
  await page.getByRole('button', {name: 'Sign In'}).click();
  await page.waitForLoadState('networkidle');
}
