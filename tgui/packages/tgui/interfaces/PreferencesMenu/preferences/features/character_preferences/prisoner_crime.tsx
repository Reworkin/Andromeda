import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const prisoner_crime: FeatureChoiced = {
  name: 'Преступление заключённого',
  description:
    'Будучи заключённым, это будет добавлено в ваше дело как причина ареста.',
  component: FeatureDropdownInput,
};
