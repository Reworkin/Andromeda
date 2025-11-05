import { CheckboxInput, type FeatureToggle } from '../base';

export const persistent_scars: FeatureToggle = {
  name: 'Постоянные шрамы',
  description:
    'Если отмечено, шрамы будут сохраняться между раундами, если вы доживёте до конца.',
  component: CheckboxInput,
};
