import { CheckboxInput, type FeatureToggle } from '../base';

export const rds_limit: FeatureToggle = {
  name: 'Безлимитные галлюцинации',
  description:
    'Отметка этой галочки уберёт ограничения на галлюцинации, \
    делая их более частыми, навязчивыми и (обычно) более безумными.',
  component: CheckboxInput,
};
