import { CheckboxInput, type FeatureToggle } from '../base';

export const playtime_reward_cloak: FeatureToggle = {
  name: 'Надеть плащ геймера',
  description:
    'Ваша награда за 5к+ часов игры. Наденьте стильный плащ, доступный только для таких же супер-ветеранов.',
  component: CheckboxInput,
};
