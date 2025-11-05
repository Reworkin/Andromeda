/datum/species/abductor
	name = "Абдуктор"
	plural_form = "Абдукторы"
	id = SPECIES_ABDUCTOR
	sexes = FALSE
	inherent_traits = list(
		TRAIT_ABDUCTOR_HUD,
		TRAIT_CHUNKYFINGERS_IGNORE_BATON,
		TRAIT_NEVER_WOUNDED,
		TRAIT_NOBLOOD,
		TRAIT_NOBREATH,
		TRAIT_NODISMEMBER,
		TRAIT_NOHUNGER,
		TRAIT_NO_UNDERWEAR,
		TRAIT_VIRUSIMMUNE,
	)
	mutanttongue = /obj/item/organ/tongue/abductor
	mutantstomach = null
	mutantheart = null
	mutantlungs = null
	mutantbrain = /obj/item/organ/brain/abductor
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/abductor,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/abductor,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/abductor,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/abductor,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/abductor,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/abductor,
	)

/datum/species/abductor/get_physical_attributes()
	return "Абдукторам не нужно дышать, есть, у них нет крови, сердца, желудка или лёгких и они не могут быть заражены человеческими вирусами. \
		Их выносливое телосложение предотвращает ранение или расчленение их кожи, но их неуклюжие трёхпалые руки затрудняют использование человеческого оборудования."

/datum/species/abductor/get_species_description()
	return "Абдукторы, в просторечии известные как \"Серые\", \
		являются трёхпалыми, бледнокожими любознательными инопланетянами, которые не могут хорошо общаться со средним членом экипажа."

/datum/species/abductor/get_species_lore()
	return list(
		"Об абдукторах известно мало. \
		Хотя известно, что они, как вид, похищают другие виды 'меньшего интеллекта' для экспериментов, \
		некоторые из них, как известно, - в редких случаях - работают с теми самыми видами, которых похищают, по неизвестным причинам.",
	)

/datum/species/abductor/create_pref_traits_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_WIND,
		SPECIES_PERK_NAME = "Лёгкие опциональны",
		SPECIES_PERK_DESC = "Абдукторам не нужно дышать, хотя воздействие вакуума всё ещё опасно.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD,
		SPECIES_PERK_NAME = "Устойчивая кожа",
		SPECIES_PERK_DESC = "Серая кожа абдуктора прочная и устойчивая. \
			Их нельзя ранить или расчленить обычными средствами.",
	))
	return perks

/datum/species/abductor/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SYRINGE,
		SPECIES_PERK_NAME = "Иммунитет к болезням",
		SPECIES_PERK_DESC = "Абдукторы невосприимчивы ко всем вирусным инфекциям, встречающимся на станции естественным образом.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK, // Возможно, назвать отсутствие голода нейтральной чертой - натяжка, но язык абдуктора описывает это именно так.
		SPECIES_PERK_ICON = FA_ICON_UTENSILS,
		SPECIES_PERK_NAME = "Голод к знаниям",
		SPECIES_PERK_DESC = "У абдукторов больше голод к знаниям, чем к еде, и поэтому им не нужно есть. \
			Что удачно, поскольку их речевой матрикс не позволяет им потреблять пищу.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_VOLUME_XMARK,
		SPECIES_PERK_NAME = "Суперлингвальный матрикс",
		SPECIES_PERK_DESC = "Абдукторы не могут физически говорить своим естественным языком. \
			Вместо этого они естественным образом общаются телепатически с другими абдукторами, процесс, который все другие виды не слышат. \
			Отлично подходит для секретных разговоров, не так хорошо для заказа чего-либо в баре.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_HANDSHAKE_SLASH,
		SPECIES_PERK_NAME = "Трёхпалые руки",
		SPECIES_PERK_DESC = "Руки абдукторов не предназначены для человеческого оборудования. Использование оборудования станции затруднено для них.",
	))
	return perks
