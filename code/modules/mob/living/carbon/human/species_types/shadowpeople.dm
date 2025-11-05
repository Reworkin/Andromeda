/datum/species/shadow
	// Люди, проклятые оставаться в темноте, чтобы их жизненные силы не истощались. Они восстанавливают здоровье в тени и умирают на свету.
	name = "Теневой"
	plural_form = "Теневые"
	id = SPECIES_SHADOW
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/shadow
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLOOD,
		TRAIT_NODISMEMBER,
		TRAIT_NEVER_WOUNDED
	)
	inherent_factions = list(FACTION_FAITHLESS)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC

	mutantbrain = /obj/item/organ/brain/shadow
	mutanteyes = /obj/item/organ/eyes/shadow
	mutantheart = null
	mutantlungs = null

	species_language_holder = /datum/language_holder/shadowpeople

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/shadow,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/shadow,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/shadow,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/shadow,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/shadow,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/shadow,
	)

/datum/species/shadow/on_species_gain(mob/living/carbon/carbon_mob, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(carbon_mob, COMSIG_MOB_FLASH_OVERRIDE_CHECK, PROC_REF(on_flashed))

/datum/species/shadow/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(human, COMSIG_MOB_FLASH_OVERRIDE_CHECK)

/datum/species/shadow/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/shadow/get_physical_attributes()
	return "Эти проклятые существа исцеляются в темноте, но сильно страдают на свету. Их глаза позволяют им видеть в темноте как днём."

/datum/species/shadow/get_species_description()
	return "Жертвы давно вымершего космического вида. Их плоть - болезненно \
		прозрачная нить, их спутанные внутренности на виду. Их форма \
		- это насмешка над жизнью, оставляющая их в основном неспособными работать с другими при \
		нормальных обстоятельствах."

/datum/species/shadow/get_species_lore()
	return list(
		"Давным-давно Спинвардский сектор был населён видом, метко названными \"Теневые\" \
		из-за их контроля над темнотой и склонности похищать жертв в тёмные технические тоннели. \
		Около 2558 года, Нанотрейзен вела долгую компанию против космических ужасов, закончилась полным вымиранием Теневых.",

		"Жертвы их похищений становились безмозглыми рабами и с помощью хирургии их можно было освободить от контроля Теневых. \
		Те, кому не повезло больше, подвергались полному преобразованию тела Теневыми для лучшего служения в похищениях. \
		В отличие от опухолей мозга при меньшем контроле, этих рабов нельзя было вернуть обратно.",

		"С исчезновением Теневых их воля снова стала их собственной. Но их тела не вернулись обратно, сгорая при воздействии света. \
		Нанотрейзен заверил жертв, что они ищут лекарство. Дальнейшая информация не предоставлялась, даже спустя годы. \
		Большинство теневых людей теперь предполагают, что Нанотрейзен давно положил проект на пыльную полку.",
	)

/datum/species/shadow/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "moon",
			SPECIES_PERK_NAME = "Рождённый во тьме",
			SPECIES_PERK_DESC = "Их кожа расцветает в темноте. Любые виды повреждений, \
				независимо от степени тяжести, будут со временем заживать, пока нет света.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = "Ночное зрение",
			SPECIES_PERK_DESC = "Их глаза адаптированы к ночи и могут видеть в темноте без проблем.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Световой ожог",
			SPECIES_PERK_DESC = "Их плоть увядает на свету. Любое воздействие света \
				невероятно болезненно для теневого человека, обугливая его кожу.",
		),
	)

	return to_add

/obj/item/organ/eyes/shadow
	name = "burning red eyes"
	desc = "Даже без их тенистого владельца, взгляд на эти глаза вызывает чувство страха."
	icon = 'icons/obj/medical/organs/shadow_organs.dmi'
	iris_overlay = null
	color_cutoffs = list(20, 10, 40)
	pepperspray_protect = TRUE
	flash_protect = FLASH_PROTECTION_SENSITIVE

/// ключ ко всем их способностям
/obj/item/organ/brain/shadow
	name = "shadowling tumor"
	desc = "Что-то, что когда-то было мозгом, прежде чем быть переделанным теневым. Оно адаптировалось к темноте, необратимо."
	icon = 'icons/obj/medical/organs/shadow_organs.dmi'
	shade_color = "grey-ish"

/datum/species/shadow/get_scream_sound(mob/living/carbon/human/moth)
	return 'sound/mobs/humanoids/shadow/shadow_wail.ogg'

/datum/species/shadow/proc/on_flashed(source, mob/living/carbon/flashed, flash, deviation)
	SIGNAL_HANDLER

	if(deviation == DEVIATION_FULL) // Если нет отклонения, мы можем предположить, что это не сборная вспышка и должна наносить максимальный урон от вспышки.
		flashed.apply_damage(16, BURN, attacking_item = flash)
		flashed.adjust_confusion_up_to(3 SECONDS, 6 SECONDS)
	else // Если это что-то меньшее, чем полное попадание, оно наносит менее звёздный урон. Имейте в виду, что этот урон наносится гораздо быстрее, поскольку у вспышек более быстрое время восстановления между кликами.
		flashed.apply_damage(8, BURN, attacking_item = flash)
		flashed.adjust_confusion_up_to(1 SECONDS, 3 SECONDS)

	INVOKE_ASYNC(flashed, TYPE_PROC_REF(/mob, emote), "scream")
	flashed.visible_message(span_danger("[flashed] вопит от боли, когда вспышка света опаляет его плоть!"), \
		span_danger("Вы вопите от боли, когда внезапная вспышка света опаляет вашу плоть!"), \
		span_danger("Кто-то вопит от боли! Это звучит как ужасающий монстр! Хорошо, что вы не можете его видеть, иначе вы бы сейчас наверняка запаниковали."))

	return FLASH_OVERRIDDEN
