// Подвид человека
/datum/species/human/felinid
	name = "Фелинид"
	plural_form = "Фелиниды"
	id = SPECIES_FELINE
	examine_limb_id = SPECIES_HUMAN
	mutantbrain = /obj/item/organ/brain/felinid
	mutanttongue = /obj/item/organ/tongue/cat
	mutantears = /obj/item/organ/ears/cat
	mutanteyes = /obj/item/organ/eyes/felinid
	mutant_organs = list(
		/obj/item/organ/tail/cat = "Cat",
	)
	inherent_traits = list(
		TRAIT_CATLIKE_GRACE,
		TRAIT_HATED_BY_DOGS,
		TRAIT_USES_SKINTONES,
		TRAIT_WATER_HATER,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/felinid
	payday_modifier = 1.0
	family_heirlooms = list(/obj/item/toy/cattoy)
	/// Когда false, это фелинид, созданный массовым мурбацией
	var/original_felinid = TRUE
	/// Вкусняшка!
	species_cookie = /obj/item/food/nugget

/datum/species/human/felinid/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE, replace_missing = TRUE)
	if(!pref_load) //Ха! Их насильно подвергли мурбации. Принудительно установить части фелинида по умолчанию, если у них нет мутантных частей в этих областях!
		if(human_who_gained_species.dna.features[FEATURE_TAIL_CAT] == SPRITE_ACCESSORY_NONE)
			human_who_gained_species.dna.features[FEATURE_TAIL_CAT] = get_consistent_feature_entry(SSaccessories.feature_list[FEATURE_TAIL_CAT])
		if(human_who_gained_species.dna.features[FEATURE_EARS] == SPRITE_ACCESSORY_NONE)
			human_who_gained_species.dna.features[FEATURE_EARS] = get_consistent_feature_entry(SSaccessories.feature_list[FEATURE_EARS])

	// Замена кошачьих ушей на обычные человеческие, если у них невидимые кошачьи уши.
	if(human_who_gained_species.dna.features[FEATURE_EARS] == SPRITE_ACCESSORY_NONE)
		mutantears = /obj/item/organ/ears
	return ..()

/datum/species/human/felinid/get_hiss_sound(mob/living/carbon/human/felinid)
	return 'sound/mobs/humanoids/felinid/felinid_hiss.ogg'

/proc/mass_purrbation()
	for(var/mob in GLOB.human_list)
		purrbation_apply(mob)
		CHECK_TICK

/proc/mass_remove_purrbation()
	for(var/mob in GLOB.human_list)
		purrbation_remove(mob)
		CHECK_TICK

/proc/purrbation_toggle(mob/living/carbon/human/target_human, silent = FALSE)
	if(!ishuman(target_human))
		return
	if(!istype(target_human.get_organ_slot(ORGAN_SLOT_EARS), /obj/item/organ/ears/cat))
		purrbation_apply(target_human, silent = silent)
		. = TRUE
	else
		purrbation_remove(target_human, silent = silent)
		. = FALSE

/proc/purrbation_apply(mob/living/carbon/human/soon_to_be_felinid, silent = FALSE)
	if(!ishuman(soon_to_be_felinid) || isfelinid(soon_to_be_felinid))
		return
	if(ishumanbasic(soon_to_be_felinid))
		soon_to_be_felinid.set_species(/datum/species/human/felinid)
		var/datum/species/human/felinid/cat_species = soon_to_be_felinid.dna.species
		cat_species.original_felinid = FALSE
	else
		// Это удаляет спинные пластины, если они существуют
		var/obj/item/organ/spines/current_spines = soon_to_be_felinid.get_organ_slot(ORGAN_SLOT_EXTERNAL_SPINES)
		if(current_spines)
			current_spines.Remove(soon_to_be_felinid, special = TRUE)
			qdel(current_spines)

		// Без этой строки хвосты были бы невидимы. Это потому, что кошачий хвост и уши по умолчанию установлены в None.
		// Люди преобразуются напрямую в фелинидов, и ключ обрабатывается в on_species_gain.
		// Теперь, когда мы получаем mob.dna.features[feature_key], он возвращает None, поэтому хвост невидим.
		// stored_feature_id устанавливается только один раз (при первой вставке органа), так что это должно быть безопасно.
		var/obj/item/organ/ears/cat/kitty_ears = new
		kitty_ears.Insert(soon_to_be_felinid, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		if(should_visual_organ_apply_to(/obj/item/organ/tail/cat, soon_to_be_felinid)) // дать хвост только если у них есть спрайты для него / они совместимый подвид.
			var/obj/item/organ/tail/cat/kitty_tail = new
			kitty_tail.Insert(soon_to_be_felinid, special = TRUE, movement_flags = DELETE_IF_REPLACED)

	if(!silent)
		to_chat(soon_to_be_felinid, span_boldnotice("Что-то не так, мяу~."))
		playsound(get_turf(soon_to_be_felinid), 'sound/effects/meow1.ogg', 50, TRUE, -1)

/proc/purrbation_remove(mob/living/carbon/human/purrbated_human, silent = FALSE)
	if(isfelinid(purrbated_human))
		var/datum/species/human/felinid/cat_species = purrbated_human.dna.species
		if(cat_species.original_felinid)
			return // Не показывать сообщение to_chat
		purrbated_human.set_species(/datum/species/human)
	else if(ishuman(purrbated_human) && !ishumanbasic(purrbated_human))
		var/datum/species/target_species = purrbated_human.dna.species

		// Из предыдущей проверки мы знаем, что они не фелинид, поэтому удаление кошачьих ушей и хвоста безопасно
		var/obj/item/organ/tail/old_tail = purrbated_human.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(istype(old_tail, /obj/item/organ/tail/cat))
			old_tail.Remove(purrbated_human, special = TRUE)
			qdel(old_tail)
			// Locate не работает с ассоциативными списками, поэтому делаем вручную
			for(var/external_organ in target_species.mutant_organs)
				if(!should_visual_organ_apply_to(external_organ, purrbated_human))
					continue
				if(ispath(external_organ, /obj/item/organ/tail))
					var/obj/item/organ/tail/new_tail = new external_organ()
					new_tail.Insert(purrbated_human, special = TRUE, movement_flags = DELETE_IF_REPLACED)
				// Не забываем о спинных пластинах, которые мы удалили ранее
				else if(ispath(external_organ, /obj/item/organ/spines))
					var/obj/item/organ/spines/new_spines = new external_organ()
					new_spines.Insert(purrbated_human, special = TRUE, movement_flags = DELETE_IF_REPLACED)

		var/obj/item/organ/ears/old_ears = purrbated_human.get_organ_slot(ORGAN_SLOT_EARS)
		if(istype(old_ears, /obj/item/organ/ears/cat))
			var/obj/item/organ/new_ears = new target_species.mutantears()
			new_ears.Insert(purrbated_human, special = TRUE, movement_flags = DELETE_IF_REPLACED)
	if(!silent)
		to_chat(purrbated_human, span_boldnotice("Вы больше не кошка."))

/datum/species/human/felinid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#ffcccc", update = FALSE) // розовый
	human_for_preview.set_hairstyle("Hime Cut", update = TRUE)

	var/obj/item/organ/ears/cat/cat_ears = human_for_preview.get_organ_by_type(/obj/item/organ/ears/cat)
	if (cat_ears)
		cat_ears.color = human_for_preview.hair_color
		human_for_preview.update_body()

/datum/species/human/felinid/get_physical_attributes()
	return "Фелиниды очень похожи на людей почти во всех отношениях, с их самыми большими отличиями - способность зализывать раны, \
		и повышенная чувствительность к шуму, что часто является недостатком. Они также довольно любят есть апельсины."

/datum/species/human/felinid/get_species_description()
	return "Фелиниды - одно из многих типов индивидуальных генетических \
		модификаций, появившихся благодаря мастерству человечества в генетической науке, и также \
		одни из самых распространённых. Мяу?"

/datum/species/human/felinid/get_species_lore()
	return list(
		"Биоинженерия в её наиболее кошачьем проявлении, фелиниды - пиковый пример мастерства человечества над генетическим кодом. \
			Один из многих вариантов \"Анималидов\", фелиниды - самые популярные и распространённые, а также одна из \
			самых спорных точек в генетической модификации.",

		"Модификаторы тел стремились соединить человеческую и кошачью ДНК в поисках святой троицы: ушей, глаз и хвоста. \
			Эти черты были очень востребованы, с соответствующими побочными эффектами в виде вокальных и нейрохимических изменений, которые считались незначительными неудобствами.",

		"К сожалению для фелинидов, это были не незначительные неудобства. Изгнанные многими как недочеловеки и монстры, фелиниды и другие анималиды, \
			искали свои лучшие доли в колониях, собираясь в сообщества себе подобных. \
			В результате, внешнее человеческое пространство имеет высокую популяцию анималидов.",
	)

// Фелиниды являются подвидами людей.
// Это не должно вызывать родительскую процедуру, иначе мы получим кучу особенностей, связанных с людьми (хотя причин для этого нет).
/datum/species/human/felinid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "grin-tongue",
			SPECIES_PERK_NAME = "Уход",
			SPECIES_PERK_DESC = "Фелиниды могут зализывать раны, чтобы уменьшить кровотечение.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_FALLING,
			SPECIES_PERK_NAME = "Кошачья грация",
			SPECIES_PERK_DESC = "Фелиниды имеют кошачьи инстинкты, позволяющие им приземляться на лапы.  \
				Вместо того чтобы быть сбитыми с ног от падения, вы получаете лишь кратковременное замедление. \
				Однако у них нет кошачьих ног и падение нанесёт дополнительный урон.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Чувствительный слух",
			SPECIES_PERK_DESC = "Фелиниды более чувствительны к громким звукам, таким как светошумовые гранаты.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "shower",
			SPECIES_PERK_NAME = "Гидрофобия",
			SPECIES_PERK_DESC = "Фелиниды не любят, когда их заливают водой.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_ANGRY,
			SPECIES_PERK_NAME = "Бей или Беги",
			SPECIES_PERK_DESC = "Фелиниды, ставшие психически нестабильными, проявляют \
				крайнюю реакцию 'бей или беги' против агрессоров. Они иногда кусают людей. Жестоко.",
		),
	)
	return to_add
