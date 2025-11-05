/datum/species/fly
	name = "Мухолюд"
	plural_form = "Мухолюди"
	id = SPECIES_FLYPERSON
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	meat = /obj/item/food/meat/slab/human/mutant/fly
	mutanteyes = /obj/item/organ/eyes/fly
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/fly
	payday_modifier = 1.0

	mutanttongue = /obj/item/organ/tongue/fly
	mutantheart = /obj/item/organ/heart/fly
	mutantlungs = /obj/item/organ/lungs/fly
	mutantliver = /obj/item/organ/liver/fly
	mutantstomach = /obj/item/organ/stomach/fly
	mutantappendix = /obj/item/organ/appendix/fly
	mutant_organs = list(/obj/item/organ/fly, /obj/item/organ/fly/groin)

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/fly,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/fly,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/fly,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/fly,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/fly,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/fly,
	)

/datum/species/fly/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(human_who_gained_species, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))

/datum/species/fly/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_ATOM_ATTACKBY)

/datum/species/fly/proc/on_attackby(mob/living/source, obj/item/attacking_item, mob/living/attacker, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/melee/flyswatter))
		MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 30) // Да, модификатор урона x30

/datum/species/fly/get_physical_attributes()
	return "Эти отвратительные существа сильно страдают от пестицидов, едят отходы и невероятно уязвимы для яркого света. Но у них есть крылья."

/datum/species/fly/get_species_description()
	return "Без официальной документации или знаний о происхождении \
		этого вида, они остаются загадкой для большинства. Любые слухи среди \
		сотрудников Нанотрейзен о мухолюдях часто быстро пресекаются высокопоставленными \
		сотрудниками или официальными лицами."

/datum/species/fly/get_species_lore()
	return list(
		"Мухолюди - любопытный вид с поразительным сходством с отрядом насекомых Двукрылые, \
		обычно известных как мухи. Без публично известного происхождения, ходят слухи, что мухолюди являются побочной побочкой блюспейс-путешествий, \
		несмотря на заявления о безопасности от официальных лиц Нанотрейзен.",

		"Мало что известно о происхождении этой расы, \
		однако они обладают способностью общаться с гигантскими пауками, изначально обнаруженными в секторе Австраликус \
		и теперь часто встречающимися на чёрных рынках в результате прорыва в исследованиях биологического оружия Синдиката.",

		"Мухолюдей часто боятся или избегают среди других видов, их внешний вид часто описывается как нечистый или пугающий в некоторых случаях, \
		а их пищевые привычки ещё больше, с невыносимым акцентом в придачу.",
	)

/datum/species/fly/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "grin-tongue",
			SPECIES_PERK_NAME = "Сверхъестественная пищеварительная система",
			SPECIES_PERK_DESC = "Мухолюди отрыгивают содержимое своего желудка и пьют его \
				с пищи, чтобы есть и пить без заботы о вкусе, предпочитая отвратительную пищу.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fist-raised",
			SPECIES_PERK_NAME = "Инсектоидная биология",
			SPECIES_PERK_DESC = "Мухобойки наносят значительно больше урона мухолюдям.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Радиальное зрение",
			SPECIES_PERK_DESC = "Мухолюдей можно ослепить вспышкой с любого угла.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "briefcase-medical",
			SPECIES_PERK_NAME = "Странные органы",
			SPECIES_PERK_DESC = "Для лечения мухолюдей требуется специализированные медицинские знания. \
				Их органы деформированы и манипуляции с органами могут быть интересными...",
		),
	)

	return to_add
