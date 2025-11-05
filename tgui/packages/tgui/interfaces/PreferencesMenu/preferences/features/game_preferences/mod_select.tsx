import type { Feature } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const mod_select: Feature<string> = {
  name: 'Активация модуля МОДа',
  category: 'Геймплей',
  description: 'Какая клавиша вызовет функционал активного модуля МОДа.',
  component: FeatureDropdownInput,
};
