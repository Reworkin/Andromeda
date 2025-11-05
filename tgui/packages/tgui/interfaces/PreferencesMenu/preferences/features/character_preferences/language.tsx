import {
  CheckboxInput,
  type FeatureChoiced,
  type FeatureToggle,
} from '../base';
import {
  FeatureDropdownInput,
  FeatureIconnedDropdownInput,
} from '../dropdowns';

export const language: FeatureChoiced = {
  name: 'Язык',
  component: FeatureIconnedDropdownInput,
};

export const language_speakable: FeatureToggle = {
  name: 'Возможность говорить',
  description: `Если не отмечено, вы сможете только понимать язык,
    но не говорить на нём.`,
  component: CheckboxInput,
};

export const language_skill: FeatureChoiced = {
  name: 'Уровень языка',
  description: 'Процент языка, который вы можете понимать.',
  component: FeatureDropdownInput,
};

export const csl_strength: FeatureChoiced = {
  name: 'Уровень языка',
  description: 'Процент Общего языка, который вы можете понимать.',
  component: FeatureDropdownInput,
};
