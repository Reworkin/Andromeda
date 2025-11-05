import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const ghost_lighting: FeatureChoiced = {
  name: 'Освещение для призраков',
  component: FeatureDropdownInput,
  category: 'Призрак',
  description: 'Влияет на яркость освещения для призраков',
};
