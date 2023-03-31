import { Api } from '../types/generated/Api.ts';

export const api = new Api({
  baseApiParams: {
    headers: {
      Authorization: `Basic ${btoa('test@liferay.com:test')}`,
      Caca: 'Futi',
    },
  },
});
