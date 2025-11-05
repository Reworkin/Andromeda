/datum/species/zombie
	// 1spooky
	name = "Высокофункциональный Зомби"
	id = SPECIES_ZOMBIE
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/zombie
	mutanttongue = /obj/item/organ/tongue/zombie
	inherent_traits = list(
		// ОБЩЕЕ ДЛЯ ВСЕХ ЗОМБИ
		TRAIT_BLOODY_MESS,
		TRAIT_EASILY_WOUNDED,
		TRAIT_EASYDISMEMBER,
		TRAIT_FAKEDEATH,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NOBREATH,
		TRAIT_NODEATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NOHUNGER,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_ZOMBIFY,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
		// УНИКАЛЬНО ДЛЯ ВЫСОКОФУНКЦИОНАЛЬНЫХ
		TRAIT_NOBLOOD,
		TRAIT_SUCCUMB_OVERRIDE,
	)
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN
	bodytemp_normal = T0C // У них нет естественного тепла тела, температура регулируется окружающей средой
	bodytemp_heat_damage_limit = FIRE_MINIMUM_TEMPERATURE_TO_EXIST // Получают урон при температуре огня
	bodytemp_cold_damage_limit = MINIMUM_TEMPERATURE_TO_MOVE // получают урон ниже минимальной температуры для движения

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie
	)

	/// Жуткие рычания, которые мы иногда проигрываем при жизни
	var/static/list/spooks = list(
		'sound/effects/hallucinations/growl1.ogg',
		'sound/effects/hallucinations/growl2.ogg',
		'sound/effects/hallucinations/growl3.ogg',
		'sound/effects/hallucinations/veryfar_noise.ogg',
		'sound/effects/hallucinations/wail.ogg',
	)

/// Зомби не стабилизируют температуру тела - они ходячие мертвецы и хладнокровны
/datum/species/zombie/body_temperature_core(mob/living/carbon/human/humi, seconds_per_tick, times_fired)
	return

/datum/species/zombie/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/zombie/get_physical_attributes()
	return "Зомби - нежить, и поэтому полностью невосприимчивы к любым опасностям окружающей среды или любым физическим угрозам, кроме тупой травмы и ожогов. \
		Их конечности легко выскакивают из суставов, но они могут каким-то образом просто вставить их обратно."

/datum/species/zombie/get_species_description()
	return "Гниющий зомби! Они спускаются на Космическую Станцию Тринадцать каждый год, чтобы напугать экипаж!"

/datum/species/zombie/get_species_lore()
	return list("У зомби давняя вражда с ботаниками. Их последний инцидент с газоном с защитными растениями оставил их очень расстроенными.")

// Переопределение стандартных перков температуры, чтобы установить, что их не очень волнует температура
/datum/species/zombie/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "thermometer-half",
		SPECIES_PERK_NAME = "Нет температуры тела",
		SPECIES_PERK_DESC = "Давно ушедшие, у зомби больше нет ничего, \
			регулирующего температуру их тела. Это означает, что \
			окружающая среда определяет их температуру тела - что их совсем не волнует, \
			пока не станет слишком жарко.",
	))

	return to_add

/datum/species/zombie/infectious
	name = "Инфекционный Зомби"
	id = SPECIES_ZOMBIE_INFECTIOUS
	examine_limb_id = SPECIES_ZOMBIE
	damage_modifier = 20 // 120 урона для нокаута зомби, что убивает его
	mutanteyes = /obj/item/organ/eyes/zombie
	mutantbrain = /obj/item/organ/brain/zombie
	mutanttongue = /obj/item/organ/tongue/zombie
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

	inherent_traits = list(
		// ОБЩЕЕ ДЛЯ ВСЕХ ЗОМБИ
		TRAIT_BLOODY_MESS,
		TRAIT_EASILY_WOUNDED,
		TRAIT_EASYDISMEMBER,
		TRAIT_FAKEDEATH,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NOBREATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NODEATH,
		TRAIT_NOHUNGER,
		TRAIT_NO_DNA_COPY,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
		// УНИКАЛЬНО ДЛЯ ИНФЕКЦИОННЫХ
		TRAIT_STABLEHEART, // Замена noblood. Инфекционные зомби могут истекать кровью, но не нуждаются в сердце.
		TRAIT_STABLELIVER, // Не обязательно, но для согласованности с вышеуказанным
	)

	// У инфекционных зомби медленные ноги
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie/infectious,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie/infectious,
	)

/datum/species/zombie/infectious/on_species_gain(mob/living/carbon/human/new_zombie, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	new_zombie.set_combat_mode(TRUE)
	// Нужно добавить после установки боевого режима
	ADD_TRAIT(new_zombie, TRAIT_COMBAT_MODE_LOCK, SPECIES_TRAIT)

	// Разберитесь с источником этой зомби-порчи
	// Орган заражения нужно обрабатывать отдельно от mutant_organs
	// потому что он сохраняется при смене видов
	var/obj/item/organ/zombie_infection/infection = new_zombie.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(isnull(infection))
		infection = new()
		infection.Insert(new_zombie)

	new_zombie.AddComponent( \
		/datum/component/mutant_hands, \
		mutant_hand_path = /obj/item/mutant_hand/zombie, \
	)
	new_zombie.AddComponent( \
		/datum/component/regenerator, \
		regeneration_delay = 6 SECONDS, \
		brute_per_second = 0.5, \
		burn_per_second = 0.5, \
		tox_per_second = 0.5, \
		oxy_per_second = 0.25, \
		heals_wounds = TRUE, \
	)

/datum/species/zombie/infectious/on_species_loss(mob/living/carbon/human/was_zombie, datum/species/new_species, pref_load)
	. = ..()
	REMOVE_TRAIT(was_zombie, TRAIT_COMBAT_MODE_LOCK, SPECIES_TRAIT)
	qdel(was_zombie.GetComponent(/datum/component/mutant_hands))
	qdel(was_zombie.GetComponent(/datum/component/regenerator))

/datum/species/zombie/infectious/check_roundstart_eligible()
	return FALSE

/datum/species/zombie/infectious/spec_stun(mob/living/carbon/human/H,amount)
	return min(2 SECONDS, amount)

/datum/species/zombie/infectious/spec_life(mob/living/carbon/carbon_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!HAS_TRAIT(carbon_mob, TRAIT_CRITICAL_CONDITION) && SPT_PROB(2, seconds_per_tick))
		playsound(carbon_mob, pick(spooks), 50, TRUE, 10)

// У вас отваливается кожа
/datum/species/human/krokodil_addict
	name = "Кроколюд"
	id = SPECIES_ZOMBIE_KROKODIL
	examine_limb_id = SPECIES_HUMAN
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie
	)
