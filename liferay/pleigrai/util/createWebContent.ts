import { Page, expect } from '@playwright/test';

export default async function createWebContent(
  page: Page,
  title: string,
) {
  await page.goto(
    'http://localhost:8080/group/guest/~/control_panel/manage?p_p_id=com_liferay_journal_web_portlet_JournalPortlet&p_p_lifecycle=0&p_p_state=maximized',
  );

  await page.getByRole('button', { name: 'New' }).click();
  await page.getByText('Basic Web Content').click();
  await page.waitForLoadState('networkidle');

  await page.getByLabel('Name Required').fill(title);
  await page.getByRole('button', {name: 'Publish'}).click();
  await page.getByText('Your request completed successfully').elementHandle();
}
