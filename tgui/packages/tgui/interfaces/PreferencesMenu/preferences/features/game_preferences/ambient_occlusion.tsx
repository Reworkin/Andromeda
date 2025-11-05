import { CheckboxInput, type FeatureToggle } from '../base';

export const ambientocclusion: FeatureToggle = {
  name: 'Включить глобальное затенение',
  category: 'Геймплей',
  description: 'Глобальное затенение, добавляющее легие тени вокруг объектов.',
  component: CheckboxInput,
};
