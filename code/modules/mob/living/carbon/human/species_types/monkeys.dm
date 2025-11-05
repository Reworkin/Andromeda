#define MONKEY_SPEC_ATTACK_BITE_MISS_CHANCE 25

/datum/species/monkey
	name = "Обезьяна"
	plural_form = "Обезьяны"
	id = SPECIES_MONKEY
	mutant_organs = list(
		/obj/item/organ/tail/monkey = "Monkey",
	)
	mutanttongue = /obj/item/organ/tongue/monkey
	mutantbrain = /obj/item/organ/brain/primate
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	meat = /obj/item/food/meat/slab/monkey
	knife_butcher_results = list(/obj/item/food/meat/slab/monkey = 5, /obj/item/stack/sheet/animalhide/monkey = 1)
	inherent_traits = list(
		TRAIT_NO_AUGMENTS,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_UNDERWEAR,
		TRAIT_VENTCRAWLER_NUDE,
		TRAIT_WEAK_SOUL,
	)
	no_equip_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_SUITSTORE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN | SLIME_EXTRACT
	species_cookie = /obj/item/food/grown/banana
	inherent_factions = list(FACTION_MONKEY)
	sexes = FALSE
	species_language_holder = /datum/language_holder/monkey

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/monkey,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/monkey,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/monkey,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/monkey,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/monkey,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/monkey,
	)
	fire_overlay = "monkey"
	gib_anim = "gibbed-m"

	payday_modifier = 1.5
	ai_controlled_species = TRUE

/datum/species/monkey/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if (pref_load)
		ADD_TRAIT(human_who_gained_species, TRAIT_BORN_MONKEY, INNATE_TRAIT) // Не видовая черта, вы не можете избежать своей генетической судьбы
	passtable_on(human_who_gained_species, SPECIES_TRAIT)
	human_who_gained_species.dna.add_mutation(/datum/mutation/race, MUTATION_SOURCE_ACTIVATED)
	human_who_gained_species.AddElement(/datum/element/human_biter)
	human_who_gained_species.update_mob_height()

/datum/species/monkey/on_species_loss(mob/living/carbon/human/C)
	. = ..()
	passtable_off(C, SPECIES_TRAIT)
	C.dna.remove_mutation(/datum/mutation/race, MUTATION_SOURCE_ACTIVATED)
	C.RemoveElement(/datum/element/human_biter)
	C.update_mob_height()

/datum/species/monkey/update_species_heights(mob/living/carbon/human/holder)
	if(HAS_TRAIT(holder, TRAIT_DWARF))
		return MONKEY_HEIGHT_DWARF

	if(HAS_TRAIT(holder, TRAIT_TOO_TALL))
		return MONKEY_HEIGHT_TALL

	return MONKEY_HEIGHT_MEDIUM

/datum/species/monkey/check_roundstart_eligible()
	// ПРЕКРАТИТЕ ДОБАВЛЯТЬ ПОДВИДЫ ОБЕЗЬЯН, ВЫ ЯЗЫЧНИКИ
	// окей, мы убили подвиды обезьян, но оставим это, потому что мы не можем доверять вам, ублюдкам
	if(check_holidays(MONKEYDAY) && id == SPECIES_MONKEY)
		return TRUE
	return ..()

/datum/species/monkey/get_scream_sound(mob/living/carbon/human/monkey)
	return get_sfx(SFX_SCREECH)

/datum/species/monkey/get_hiss_sound(mob/living/carbon/human/monkey)
	return 'sound/mobs/humanoids/human/hiss/human_hiss.ogg'
	// мы оба человекообразные обезьяны, или что-то в этом роде..

/datum/species/monkey/get_physical_attributes()
	return "Обезьяны проворны, могут пролезать в вентиляцию и более ловки, чем люди.. но только когда воруют вещи. \
		Природные обезьяны не могут управлять механизмами или большинством инструментов своими лапами, но необычно умные обезьяны или те, которые когда-то были кем-то другим, могут."

/datum/species/monkey/get_species_description()
	return "Обезьяны - это тип приматов, которые находятся между людьми и животными на эволюционной цепи. \
		Каждый год, в День Обезьяны, Нанотрейзен проявляет уважение к маленьким ребятам, позволяя им свободно бродить по станции."

/datum/species/monkey/get_species_lore()
	return list(
		"Обезьяны обычно используются в качестве подопытных на борту Космической Станции 13. \
		Но что, если... на один день... Обезьянам позволили быть учёными? \
		Какие эксперименты они придумали бы? Будет ли это (стереотипно) как-то связано с бананами? \
		Есть только один способ узнать.",
	)

/datum/species/monkey/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "spider",
			SPECIES_PERK_NAME = "Ползание по вентиляции",
			SPECIES_PERK_DESC = "Обезьяны могут ползать по сетям вентиляции и скрубберов, не нося одежду. \
				Держитесь подальше от кухни!",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "paw",
			SPECIES_PERK_NAME = "Примитивный примат",
			SPECIES_PERK_DESC = "Обезьяны - примитивные люди и не могут делать большинство вещей, которые может делать человек. Компьютеры невозможны, \
				сложные механизмы исключены и большинство одежды не подходит для вашей меньшей формы.",
		),
	)

	return to_add

/datum/species/monkey/create_pref_language_perk()
	var/list/to_add = list()
	// Сохраняем эти переменные, чтобы получить точные названия для нашей особенности.
	var/datum/language/common_language = /datum/language/common
	var/datum/language/monkey_language = /datum/language/monkey

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "comment",
		SPECIES_PERK_NAME = "Примитивный язык",
		SPECIES_PERK_DESC = "Вы можете понимать [initial(common_language.name)], но не можете говорить на нём. \
			Вы можете говорить только на [initial(monkey_language.name)].",
	))

	return to_add

/obj/item/organ/brain/primate // Ук Ук
	name = "Primate Brain"
	desc = "Этот комок мяса мал, но имеет увеличенные затылочные доли для обнаружения бананов."
	organ_traits = list(TRAIT_CAN_STRIP, TRAIT_PRIMITIVE, TRAIT_GUN_NATURAL) // Без грамотности или продвинутого использования инструментов.
	actions_types = list(/datum/action/item_action/organ_action/toggle_trip)
	/// Будет ли эта обезьяна спотыкаться, если её пересечёт простой моб или карбон в боевом режиме? Переключается обезьянами с клиентами и автоматически устанавливается в true для ИИ обезьян.
	var/tripping = TRUE

/datum/action/item_action/organ_action/toggle_trip
	name = "Переключить Спотыкание"
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "lesser_form"
	background_icon_state = "bg_default_on"
	overlay_icon_state = "bg_default_border"

/datum/action/item_action/organ_action/toggle_trip/do_effect(trigger_flags)
	var/obj/item/organ/brain/primate/monkey_brain = target
	if(monkey_brain.tripping)
		monkey_brain.tripping = FALSE
		background_icon_state = "bg_default"
		to_chat(monkey_brain.owner, span_notice("Теперь вы будете избегать спотыкания при столкновении с людьми в боевом режиме."))
	else
		monkey_brain.tripping = TRUE
		background_icon_state = "bg_default_on"
		to_chat(monkey_brain.owner, span_notice("Теперь вы будете спотыкаться при столкновении с людьми в боевом режиме."))
	build_all_button_icons()
	return TRUE

/obj/item/organ/brain/primate/on_mob_insert(mob/living/carbon/primate)
	. = ..()
	RegisterSignal(primate, COMSIG_LIVING_MOB_BUMPED, PROC_REF(on_mob_bump))

/obj/item/organ/brain/primate/on_mob_remove(mob/living/carbon/primate)
	. = ..()
	UnregisterSignal(primate, COMSIG_LIVING_MOB_BUMPED)

/obj/item/organ/brain/primate/proc/on_mob_bump(mob/source, mob/living/crossing_mob)
	SIGNAL_HANDLER
	if(!tripping || !crossing_mob.combat_mode)
		return
	crossing_mob.knockOver(owner)

/obj/item/organ/brain/primate/get_attacking_limb(mob/living/carbon/human/target)
	if(!HAS_TRAIT(owner, TRAIT_ADVANCEDTOOLUSER) || HAS_TRAIT(owner, TRAIT_FERAL_BITER))
		return owner.get_bodypart(BODY_ZONE_HEAD)
	return ..()

#undef MONKEY_SPEC_ATTACK_BITE_MISS_CHANCE
