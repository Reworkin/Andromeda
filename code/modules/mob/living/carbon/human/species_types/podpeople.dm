/datum/species/pod
	// Мутация, вызванная воскрешением человека в капсуле ревитализации. Они восстанавливают здоровье на свету и начинают увядать в темноте.
	name = "Подлюд"
	plural_form = "Подлюди"
	id = SPECIES_PODPERSON
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_PLANT_SAFE,
	)
	mutant_organs = list(
		/obj/item/organ/pod_hair = "None",
	)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_PLANT
	inherent_factions = list(FACTION_PLANTS, FACTION_VINES)

	heatmod = 1.5
	payday_modifier = 1.0
	meat = /obj/item/food/meat/slab/human/mutant/plant
	exotic_bloodtype = BLOOD_TYPE_H2O
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/plant

	mutantappendix = /obj/item/organ/appendix/pod
	mutantbrain = /obj/item/organ/brain/pod
	mutantears = /obj/item/organ/ears/pod
	mutanteyes = /obj/item/organ/eyes/pod
	mutantheart = /obj/item/organ/heart/pod
	mutantliver = /obj/item/organ/liver/pod
	mutantlungs = /obj/item/organ/lungs/pod
	mutantstomach = /obj/item/organ/stomach/pod
	mutanttongue = /obj/item/organ/tongue/pod

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/pod,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/pod,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/pod,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/pod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/pod,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/pod,
	)

/datum/species/pod/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features[FEATURE_MUTANT_COLOR] = "#886600"
	human.dna.features[FEATURE_POD_HAIR] = "Rose"
	human.update_body(is_creating = TRUE)

/datum/species/pod/get_physical_attributes()
	return "Подлюди во многом противоположны теням: они исцеляются на свету и увядают в темноте. \
		Их тела подобны труту и легко обугливаются."

/datum/species/pod/get_species_description()
	return "Подлюди - в основном мирные формы жизни на растительной основе, напоминающие гуманоидную фигуру из листьев, цветов и лоз."

/datum/species/pod/get_species_lore()
	return list(
		"О происхождении подлюдей известно немногое. \
		Многие полагают, что они являются результатом давно забытого ботанического эксперимента, медленно мутировавшего годами, пока они не стали теми существами, которыми являются сегодня. \
		С тех пор, как они были обнаружены давным-давно, их вид находили на борту станций и планет по всей галактике, \
		часто работая в гидропонических отсеках, кухнях или научных отделах, работая с растениями и другими ботаническими формами жизни.",
	)

/datum/species/pod/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "lightbulb",
		SPECIES_PERK_NAME = "Фотосинтез",
		SPECIES_PERK_DESC = "Пока вы в сознании и находитесь в хорошо освещённой зоне, вы будете медленно исцелять физический, ожоговый, токсический урон и урон от удушья, а также получать питание - и никогда не толстеть! \
		Однако, если у вас НИЗКОЕ питание, вы будете постепенно получать физический урон до тех пор, пока не умрёте или не вернётесь на свет."
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "biohazard",
		SPECIES_PERK_NAME = "Уязвимость к гербицидам",
		SPECIES_PERK_DESC = "Будучи цветочной формой жизни, вы уязвимы для антифлоралов и будете получать дополнительный токсический урон от них!"
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "briefcase-medical",
		SPECIES_PERK_NAME = "Сложная биология",
		SPECIES_PERK_DESC = "Ваша биология чрезвычайно сложна, что делает обычные медицинские сканеры неспособными просканировать вас. Убедитесь, что врач, лечащий вас, имеет \
		анализатор растений или продвинутый медицинский сканер!"
	))

	return to_add
