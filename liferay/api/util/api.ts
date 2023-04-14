import {Api as HeadlessDeliveryApi} from '../types/generated/headless-delivery-openapi.ts';
import {Api as ObjectAdminApi} from '../types/generated/object-admin-openapi.ts';

export const api = {
  headlessDelivery: new HeadlessDeliveryApi({
    baseApiParams: {
      headers: {
        Authorization: `Basic ${btoa('test@liferay.com:test')}`,
        Caca: 'Futi',
      },
    },
  }),

  objectAdmin: new ObjectAdminApi({
    baseApiParams: {
      headers: {
        Authorization: `Basic ${btoa('test@liferay.com:test')}`,
        Caca: 'Futi',
      },
    },
  }),
}
