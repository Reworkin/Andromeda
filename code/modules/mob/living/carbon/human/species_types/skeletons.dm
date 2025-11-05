/datum/species/skeleton
	// 2spooky
	name = "Скелет"
	id = SPECIES_SKELETON
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/skeleton
	inherent_traits = list(
		TRAIT_EASYDISMEMBER,
		TRAIT_FAKEDEATH,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_UNDERWEAR,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
		TRAIT_UNHUSKABLE,
		TRAIT_XENO_IMMUNE,
	)
	inherent_factions = list(FACTION_SKELETON)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutanttongue = /obj/item/organ/tongue/bone
	mutantstomach = /obj/item/organ/stomach/bone
	mutantappendix = null
	mutantheart = null
	mutantliver = /obj/item/organ/liver/bone
	mutantlungs = null
	//Технически они могут быть в ОБР
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | ERT_SPAWN
	species_cookie = /obj/item/reagent_containers/condiment/milk
	species_language_holder = /datum/language_holder/skeleton

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/skeleton,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/skeleton,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/skeleton,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/skeleton,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/skeleton,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/skeleton,
	)

/datum/species/skeleton/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/skeleton/get_physical_attributes()
	return "Эти плечевые кости лишены какой-либо плоти, что позволяет им сопротивляться давлению, температуре, радиации, удушью и даже токсинам. \
		Однако, по той же причине, их довольно сложно лечить. Кальций, содержащийся в обычном космическом молоке, очень эффективен для лечения их ран. \
		Их конечности легко выскакивают из суставов, но они могут каким-то образом просто вставить их обратно."

/datum/species/skeleton/get_species_description()
	return "Гремящий скелет! Они спускаются на Космическую Станцию 13 \
		каждый год, чтобы напугать экипаж!"

/datum/species/skeleton/get_species_lore()
	return list(
		"Скелеты хотят, чтобы их снова боялись! Их присутствие в медиа было разрушено, \
		или, по крайней мере, они в это твёрдо верят. Они всегда первые, с кем сражаются в RPG, \
		их фландеризировали в шутки с каламбурами, и это действительно начинает их доставать. \
		Можно сказать, что они глубоко ПОТРЯСЕНЫ. Ха."
	)
