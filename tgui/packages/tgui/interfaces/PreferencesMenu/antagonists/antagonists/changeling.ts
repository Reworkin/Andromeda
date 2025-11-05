import { type Antagonist, Category } from '../base';

export const CHANGELING_MECHANICAL_DESCRIPTION = `
Превращайте себя или других в разные личности и покупайте из арсенала
биологического оружия с помощью ДНК, которую вы собираете.
`;

const Changeling: Antagonist = {
  key: 'changeling',
  name: 'Генокрад',
  description: [
    `
      Разумный инопланетный хищник, способный изменять свою форму,
      чтобы безупречно походить на человека.
    `,
    CHANGELING_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Changeling;
