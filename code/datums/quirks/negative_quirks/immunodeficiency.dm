/datum/quirk/item_quirk/immunodeficiency
	name = "Immunodeficiency"
	desc = "(Иммунодефицит) - Будь то из-за хронического заболевания или генетической случайности, ваше тело работает как круглосуточный отель для бактерий, вирусов и паразитов всех видов. Даже с назначенными иммуностимуляторами вы будете переносить болезни хуже, чем другие."
	icon = FA_ICON_MASK_FACE
	value = -10
	mob_trait = TRAIT_IMMUNODEFICIENCY
	gain_text = span_danger("Одна только мысль о болезни вызывает у вас жар.")
	lose_text = span_notice("Ваша иммунная система чудесным образом восстанавливается.")
	medical_record_text = "Пациент страдает хроническим иммунодефицитом."
	mail_goodies = list(
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/healthanalyzer/simple/disease
	)

/datum/quirk/item_quirk/immunodeficiency/add_unique(client/client_source)
	give_item_to_holder(
		/obj/item/clothing/mask/surgical,
		list(
			LOCATION_MASK,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		)
	)
	give_item_to_holder(
		/obj/item/storage/pill_bottle/immunodeficiency,
		list(
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		)
	)
