/// Моб-дух, у которого нет ног, но который всё ещё бродит по станции как часть нежити.
/datum/species/ghost
	name = "Призрак"
	plural_form = "Призраки"
	id = SPECIES_GHOST
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_MOVE_FLYING,
		TRAIT_NEVER_WOUNDED,
		TRAIT_NOBLOOD,
		TRAIT_NODISMEMBER,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_FLOATING_ANIM,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_NO_UNDERWEAR,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_UNHUSKABLE,
	)
	inherent_biotypes = MOB_HUMANOID | MOB_SPIRIT | MOB_UNDEAD
	no_equip_flags = ITEM_SLOT_FEET
	changesource_flags = MIRROR_BADMIN | WABBAJACK | SLIME_EXTRACT | MIRROR_PRIDE | MIRROR_MAGIC
	sexes = FALSE
	meat = /obj/item/ectoplasm

	mutantheart = null
	mutantappendix = null
	mutantears = /obj/item/organ/ears/ghost
	mutantstomach = /obj/item/organ/stomach/ghost
	mutantliver = /obj/item/organ/liver/ghost
	mutantlungs = /obj/item/organ/lungs/ghost
	mutanteyes = /obj/item/organ/eyes/ghost
	mutantbrain = /obj/item/organ/brain/ghost
	mutanttongue = /obj/item/organ/tongue/ghost

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ghost,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ghost,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ghost,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ghost,
	)

	/// Врождённая способность призраков проходить сквозь стены, но сбрасывающая их вещи.
	var/datum/action/innate/toggle_passthrough/passthrough_ability

/datum/species/ghost/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/ghost/on_species_gain(mob/living/carbon/human/new_ghost, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	passthrough_ability = new(src)
	passthrough_ability.Grant(new_ghost)

/datum/species/ghost/on_species_loss(mob/living/carbon/human/former_ghost, datum/species/new_species, pref_load)
	QDEL_NULL(passthrough_ability)
	return ..()

/datum/species/ghost/get_physical_attributes()
	return "Призраки - это духовные останки давно ушедших существ. У них нет ног, они могут летать и проходить сквозь стены, \
		но всё ещё едят, дышат, слышат и видят."

/datum/species/ghost/get_species_description()
	return "Призраки - это духи давно умерших существ, которые по той или иной причине всё ещё бродят вокруг."

/datum/species/ghost/get_species_lore()
	return list(
		"Призраки - одни из самых жутких существ, известных в галактике. \
		Хотя им всё ещё нужен белок для поддержания себя, они способны контролировать свои тела, \
		проходя сквозь стены и избавляясь от всех своих пожитков по желанию. \
		Большинство знаний о них хранится в секрете ведущими святыми Нанотрейзен, которые стремятся \
		сохранить это в тайне.",
	)

/datum/species/ghost/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "body",
		SPECIES_PERK_NAME = "Без ног",
		SPECIES_PERK_DESC = "У призраков нет ног, и они парят, предотвращая падение в дыры в земле.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "ghost",
		SPECIES_PERK_NAME = "Бестелесный",
		SPECIES_PERK_DESC = "Призраки носят свои надгробия с собой и напрямую связаны с ними. \
			Бросив надгробие, вы сможете проходить сквозь твёрдую материю, но станете уязвимыми.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "shoe-prints",
		SPECIES_PERK_NAME = "Нет ног",
		SPECIES_PERK_DESC = "У вас нет ног, следовательно и возможности носить любую обувь!",
	))

	return to_add

/**
 * Способность прохождения
 *
 * Врождённая способность призраков входить в режим призрака,
 * который даёт им способность фазового прохождения, но делает их неспособными использовать что-либо,
 * и они будут привязаны к надгробию, которое, если его выкопать, убьёт их и превратит
 * в скелета.
 */
/datum/action/innate/toggle_passthrough
	name = "Переключить прохождение"
	desc = "Переключает прохождение сквозь всё, включая ваши руки. Вы привязаны к своему надгробию, пока это активно. \
		По крайней мере, вы знаете, как сохранить свою одежду на себе."
	button_icon = 'icons/hud/actions.dmi'
	button_icon_state = "ghost"

	/// Могила, которая появляется, когда мы проходим сквозь стены, и к которой мы также привязаны.
	var/obj/structure/closet/crate/grave/skeleton/grave

/datum/action/innate/toggle_passthrough/Grant(mob/grant_to)
	. = ..()
	grave = new()
	// Содержимое инициализируется, когда могилу ограбят, так как тогда ящик открывается впервые.
	RegisterSignal(grave, COMSIG_CLOSET_CONTENTS_INITIALIZED, PROC_REF(on_grave_robbed))
	RegisterSignal(grave, COMSIG_CLOSET_POST_OPEN, PROC_REF(post_grave_robbed))

/datum/action/innate/toggle_passthrough/Remove(mob/remove_from)
	if(!QDELING(remove_from))
		swap_mode(force_off = TRUE)
	QDEL_NULL(grave)
	return ..()

/datum/action/innate/toggle_passthrough/Activate()
	. = ..()
	if(!iscarbon(owner))
		return
	swap_mode()

/// Переключает режим, позволяя нам проходить сквозь вещи, но сбрасывая всё. Необязательный аргумент 'force_off' предотвращает возможность включения.
/datum/action/innate/toggle_passthrough/proc/swap_mode(force_off)
	// мы можем только выключить, ранний возврат, если мы пытаемся включить вместо этого.
	if(force_off && HAS_TRAIT_FROM(owner, TRAIT_NO_FLOATING_ANIM, SPECIES_TRAIT))
		return

	var/mob/living/carbon/carbon_owner = owner
	if(HAS_TRAIT_FROM(carbon_owner, TRAIT_NO_FLOATING_ANIM, SPECIES_TRAIT))
		grave.forceMove(get_turf(carbon_owner))
		carbon_owner.AddComponent(/datum/component/leash, grave, distance = 7)
		REMOVE_TRAIT(carbon_owner, TRAIT_NO_FLOATING_ANIM, SPECIES_TRAIT)
		carbon_owner.add_traits(list(
			TRAIT_MOVE_PHASING,
			TRAIT_PIERCEIMMUNE,
			TRAIT_INVISIBLE_TO_CAMERA,
			TRAIT_HANDS_BLOCKED, //MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE
			TRAIT_PULL_BLOCKED, //MOBILITY_PULL
			TRAIT_UI_BLOCKED, //MOBILITY_UI
		), SPECIES_TRAIT)
	else
		qdel(carbon_owner.GetComponent(/datum/component/leash))
		carbon_owner.forceMove(get_turf(grave))
		grave.moveToNullspace()
		ADD_TRAIT(carbon_owner, TRAIT_NO_FLOATING_ANIM, SPECIES_TRAIT)
		carbon_owner.remove_traits(list(
			TRAIT_MOVE_PHASING,
			TRAIT_PIERCEIMMUNE,
			TRAIT_INVISIBLE_TO_CAMERA,
			TRAIT_HANDS_BLOCKED,
			TRAIT_PULL_BLOCKED,
			TRAIT_UI_BLOCKED,
		), SPECIES_TRAIT)

/// Вызывается, когда содержимое создано, что означает, что могила была 'открыта', следовательно, ограблена.
/datum/action/innate/toggle_passthrough/proc/on_grave_robbed(obj/structure/closet/crate/grave/skeleton/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/species/skeleton/skeletons_in_the_closet = locate() in source.contents
	owner.mind.transfer_to(skeletons_in_the_closet, force_key_move = TRUE)
	skeletons_in_the_closet.death(gibbed = FALSE)

/// Вызывается ПОСЛЕ того, как содержимое было выброшено, что означает, что владелец теперь в скелете. Давайте приберёмся.
/datum/action/innate/toggle_passthrough/proc/post_grave_robbed(obj/structure/closet/crate/grave/skeleton/source)
	SIGNAL_HANDLER
	qdel(owner)
