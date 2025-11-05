/datum/species/android
	name = "Андроид"
	plural_form = "Андроиды"
	id = SPECIES_ANDROID
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NOFIRE,
		TRAIT_NOHUNGER,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_NO_UNDERWEAR,
		TRAIT_OVERDOSEIMMUNE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
	)

	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	exotic_bloodtype = BLOOD_TYPE_OIL
	meat = null
	mutantbrain = /obj/item/organ/brain/cybernetic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantstomach = null
	mutantappendix = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	mutanteyes = /obj/item/organ/eyes/robotic
	mutantears = /obj/item/organ/ears/cybernetic
	species_language_holder = /datum/language_holder/synthetic
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/android,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/android,
	)

/datum/species/android/get_physical_attributes()
	return "Андроиды почти, но не совсем, идентичны полностью аугментированным людям. \
	В отличие от них, они полностью невосприимчивы к токсичному воздействию, не имеют крови или органов, кроме головы, не испытывают голода и могут прикреплять оторванные конечности! \
	Тем не менее, ЭМИ повредить или полностью вывести их и они не могут перерабатывать химические вещества."

/datum/species/android/get_species_description()
	return "Андроиды - полностью синтетический вид."

/datum/species/android/get_species_lore()
	return list(
		"Андроиды - это синтетический вид, созданный Нанотрейзен в качестве промежуточного звена между людьми и киборгами."
	)

/datum/species/android/create_pref_traits_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_ALT,
		SPECIES_PERK_NAME = "Способности андроида",
		SPECIES_PERK_DESC = "Будучи синтетической формой жизни, андроиды невосприимчивы ко многим видам урона, к которым уязвимы люди. \
			Огонь, холод, жара, давление, радиация и токсины - всё это неэффективно против них. \
			Они также не могут передозировать наркотики, не нуждаются в дыхании или еде, не могут загореться и невосприимчивы к пронзанию.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_COGS,
		SPECIES_PERK_NAME = "Модульная форма жизни",
		SPECIES_PERK_DESC = "Конечности андроидов модульные, что позволяет им легко прикреплять оторванные части тела.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_DNA,
		SPECIES_PERK_NAME = "Всё-таки не человек",
		SPECIES_PERK_DESC = "За глазами андроида нет человечности, и поэтому у них нет ДНК для генетического изменения.",
	))
	return perks

/datum/species/android/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_HEART,
		SPECIES_PERK_NAME = "Некоторые компоненты опциональны",
		SPECIES_PERK_DESC = "У андроидов очень мало внутренних органов. Хотя они могут выжить без многих из них, \
			они также не получают от них никаких преимуществ.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_ROBOT,
		SPECIES_PERK_NAME = "Синтетический",
		SPECIES_PERK_DESC = "Будучи синтетическими, андроиды уязвимы для ЭМИ.",
	))
	return perks
