import { type Antagonist, Category } from '../base';

export const WIZARD_MECHANICAL_DESCRIPTION = `
      Выбирайте из множества мощных заклинаний, чтобы вызвать хаос
      на космической станции 13.
    `;

const Wizard: Antagonist = {
  key: 'wizard',
  name: 'Волшебник',
  description: [
    `"ПРИВЕТСТВИЕ. МЫ ВОЛШЕБНИКИ ФЕДЕРАЦИИ ВОЛШЕБНИКОВ."`,
    WIZARD_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Wizard;
