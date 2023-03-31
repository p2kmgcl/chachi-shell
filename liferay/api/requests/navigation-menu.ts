import { PageNavigationMenu } from '../types/generated/Api.ts';
import { api } from '../util/api.ts';
import { SITE_ID } from '../util/constants.ts';

const navigationMenusPage = await api.v10
  .getSiteNavigationMenusPage(SITE_ID)
  .then((response) => response.json() as PageNavigationMenu);

for (const navigationMenu of navigationMenusPage.items || []) {
  if (navigationMenu.id) {
    await api.v10.deleteNavigationMenu(navigationMenu.id.toString());
  }
}

await api.v10.postSiteNavigationMenu(SITE_ID, {
  name: 'Random things',
  navigationMenuItems: [
    {
      name: 'Vowels',
      type: 'submenu',
      navigationMenuItems: [
        { name: 'A', type: 'submenu' },
        { name: 'E', type: 'submenu' },
        { name: 'I', type: 'submenu' },
        { name: 'O', type: 'submenu' },
        { name: 'U', type: 'submenu' },
      ],
    },
    {
      name: 'Fs for people',
      type: 'submenu',
      navigationMenuItems: [
        { name: 'Pablo', type: 'submenu' },
        { name: 'Sandro', type: 'submenu' },
        { name: 'Vero', type: 'submenu' },
        { name: 'Víctor', type: 'submenu' },
      ],
    },
    {
      name: 'Sorted elements',
      type: 'submenu',
      navigationMenuItems: [
        {
          name: 'C.1',
          type: 'submenu',
          navigationMenuItems: [{ name: 'C.1.1', type: 'submenu' }],
        },
        {
          name: 'C.2',
          type: 'submenu',
          navigationMenuItems: [
            { name: 'C.2.1', type: 'submenu' },
            { name: 'C.2.2', type: 'submenu' },
            { name: 'C.2.3', type: 'submenu' },
            { name: 'C.2.4', type: 'submenu' },
          ],
        },
        { name: 'C.3', type: 'submenu' },
        {
          name: 'C.4',
          type: 'submenu',
          navigationMenuItems: [
            {
              name: 'C.4.1',
              type: 'submenu',
              navigationMenuItems: [{ name: 'C.4.1.1', type: 'submenu' }],
            },
          ],
        },
        { name: 'C.5', type: 'submenu' },
      ],
    },
    { name: 'The Z', type: 'submenu' },
    { name: 'The Z v2', type: 'submenu' },
  ],
});
