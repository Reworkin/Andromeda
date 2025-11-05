/datum/species/snail
	name = "Улитколюд"
	plural_form = "Улитколюди"
	id = SPECIES_SNAIL
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_SLIP_ALL,
	)

	coldmod = 0.5 // улитки появляются только когда холодно и влажно
	siemens_coeff = 2 // улитки в основном состоят из воды
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP
	sexes = FALSE // улитки - гермафродиты

	mutanteyes = /obj/item/organ/eyes/snail
	mutanttongue = /obj/item/organ/tongue/snail
	mutantliver = /obj/item/organ/liver/snail
	exotic_bloodtype = BLOOD_TYPE_SNAIL

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/snail,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/snail,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/snail,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/snail,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/snail,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/snail
	)

/datum/species/snail/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features[FEATURE_MUTANT_COLOR] = COLOR_BEIGE
	human.update_body(is_creating = TRUE)

/datum/species/snail/get_physical_attributes()
	return "Улитколюди выделяют вязкую, скользкую слизь при ползании по земле, что делает их несколько быстрее в этом, чем другие виды. \
		Они почти полностью состоят из воды, что делает их чрезвычайно восприимчивыми к ударам током, а соль сильно разъедает их."

/datum/species/snail/get_species_description()
	return "Улитколюди - вязкие, слизистые существа с раковиной на спине."

/datum/species/snail/get_species_lore()
	return list(
		"Обычно улитколюди являются результатом неудачного генетического эксперимента, но с тех пор они стали признанным видом сами по себе, \
		подобно фелинидам.",
	)

/datum/species/snail/create_pref_unique_perks()
	var/list/to_add = list()
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_RUNNING,
		SPECIES_PERK_NAME = "Турбо",
		SPECIES_PERK_DESC = "Улитколюди ходят и бегают очень медленно, но ползают очень быстро. При ползании они оставляют за собой след скользкой слизи.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHRIMP,
		SPECIES_PERK_NAME = "Раковина",
		SPECIES_PERK_DESC = "Спина улиткочеловека покрыта бронированной раковиной, которая фактически является несъёмным рюкзаком. \
			Хорошо для защиты вещей от кражи, но плохо для ношения МОДов или маскировки.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SKULL_CROSSBONES,
		SPECIES_PERK_NAME = "Солевой",
		SPECIES_PERK_DESC = "Будучи эволюционировавшими от улиток, улитколюди чрезвычайно восприимчивы к соли, которая обжигает их.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_HAND_FIST,
		SPECIES_PERK_NAME = "Мягкий",
		SPECIES_PERK_DESC = "Улитколюди мягкие и слизистые, что делает их удары и пинки гораздо менее эффективными, чем у других видов.",
	))
	return to_add

/datum/species/snail/on_species_gain(mob/living/carbon/new_snailperson, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/obj/item/storage/backpack/bag = new_snailperson.get_item_by_slot(ITEM_SLOT_BACK)
	if(!istype(bag, /obj/item/storage/backpack/snail))
		new_snailperson.equip_to_slot_or_del(new /obj/item/storage/backpack/snail(new_snailperson), ITEM_SLOT_BACK)

/datum/species/snail/on_species_loss(mob/living/carbon/former_snailperson, datum/species/new_species, pref_load)
	. = ..()
	var/obj/item/storage/backpack/bag = former_snailperson.get_item_by_slot(ITEM_SLOT_BACK)
	if(istype(bag, /obj/item/storage/backpack/snail))
		bag.emptyStorage()
		former_snailperson.temporarilyRemoveItemFromInventory(bag, TRUE)
		qdel(bag)

/obj/item/storage/backpack/snail
	name = "snail shell"
	desc = "Используется улитками в качестве брони и отсека для хранения."
	icon_state = "snailshell"
	inhand_icon_state = null
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	armor_type = /datum/armor/backpack_snail
	max_integrity = 200
	resistance_flags = FIRE_PROOF | ACID_PROOF
	drop_sound = null
	pickup_sound = null
	equip_sound = null

/datum/armor/backpack_snail
	melee = 40
	bullet = 30
	laser = 30
	energy = 10
	bomb = 25
	acid = 50

/obj/item/storage/backpack/snail/dropped(mob/user, silent)
	. = ..()
	emptyStorage()
	if(!QDELETED(src))
		qdel(src)

/obj/item/storage/backpack/snail/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
