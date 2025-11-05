import {
  FeatureIconnedDropdownInput,
  type FeatureWithIcons,
} from '../dropdowns';

export const preferred_ai_emote_display: FeatureWithIcons<string> = {
  name: 'Отображение эмоций ИИ',
  description:
    'Если вы ИИ, изображение по умолчанию, отображаемое на всех дисплеях ИИ на станции.',
  component: FeatureIconnedDropdownInput,
};
