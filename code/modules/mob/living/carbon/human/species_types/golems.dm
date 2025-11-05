/// Анимированные существа из камня. Они обладают повышенной защитой и не нуждаются в дыхании. Они должны питаться минералами, чтобы жить, что даёт дополнительные усиления.
/datum/species/golem
	name = "Голем"
	plural_form = "Големы"
	id = SPECIES_GOLEM
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_LAVA_IMMUNE,
		TRAIT_NEVER_WOUNDED,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NODISMEMBER,
		TRAIT_NOFIRE,
		TRAIT_NO_AUGMENTS,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_NO_UNDERWEAR,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_SNOWSTORM_IMMUNE, // Общее с плазменной рекой... но, думаю, если вы можете пережить плазменную реку, метель - не проблема
		TRAIT_UNHUSKABLE,
	)
	mutantheart = null
	mutantlungs = null
	inherent_biotypes = MOB_HUMANOID|MOB_MINERAL
	damage_modifier = 10 // голем силён
	payday_modifier = 1.0
	siemens_coeff = 0
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/golem
	species_language_holder = /datum/language_holder/golem

	bodytemp_heat_damage_limit = BODYTEMP_HEAT_LAVALAND_SAFE
	bodytemp_cold_damage_limit = BODYTEMP_COLD_ICEBOX_SAFE

	mutant_organs = list(/obj/item/organ/adamantine_resonator)
	mutanteyes = /obj/item/organ/eyes/golem
	mutantbrain = /obj/item/organ/brain/golem
	mutanttongue = /obj/item/organ/tongue/golem
	mutantstomach = /obj/item/organ/stomach/golem
	mutantliver = /obj/item/organ/liver/golem
	mutantappendix = /obj/item/organ/appendix/golem
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/golem,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/golem,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/golem,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/golem,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/golem,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/golem,
	)

/datum/species/golem/get_physical_attributes()
	return "Големы - выносливые существа, сделанные из камня, которые поэтому естественно устойчивы ко многим опасностям, включая удушье, огонь, радиацию, электричество и вирусы.\
		Они получают особые способности в зависимости от типа потребляемого материала, но им нужно потреблять материал, чтобы поддерживать своё тело."

/datum/species/golem/get_species_description()
	return "Големы - литоидные существа, которые питаются камнями и минералами, чтобы выживать и адаптироваться."

/datum/species/golem/get_species_lore()
	return list(
		"Хотя големов давно часто встречают на пограничных мирах, мирно добывая полезные ископаемые и живя в гармонии с окружающей средой, \
		считается, что они изначально были созданы в лабораториях Нанотрейзен как форма дешёвой рабочей силы. Что произошло до этого момента, неизвестно, \
		но с тех пор они обрели свободу и теперь являются редким зрелищем в галактике.",
	)

/datum/species/golem/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "user-shield",
		SPECIES_PERK_NAME = "Литоид",
		SPECIES_PERK_DESC = "Литоиды - существа, сделанные из минералов вместо \
			крови и плоти. Они сильны и невосприимчивы ко многим окружающим и личным опасностям \
			таким как огонь, радиация, отсутствие воздуха, лава, вирусы и расчленение.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "gem",
		SPECIES_PERK_NAME = "Метаморфическая порода",
		SPECIES_PERK_DESC = "Потребление минералов может дать литоидам временные преимущества в зависимости от типа потреблённого материала.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "tools",
		SPECIES_PERK_NAME = "Природные шахтёры",
		SPECIES_PERK_DESC = "Големы могут слабо видеть в темноте, чувствовать минералы, разбивать валуны и добывать камень голыми руками. \
			Они могут даже плавить руды во внутренней печи, если окружающая среда достаточно горячая.",
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "bolt",
		SPECIES_PERK_NAME = "Анима",
		SPECIES_PERK_DESC = "Поддержание силы, требует затрат. Литоиды должны часто питаться, \
			чтобы избежать возвращения в неодушевлённые статуи и получают питание только от поедания минералов.",
	))

	return to_add
