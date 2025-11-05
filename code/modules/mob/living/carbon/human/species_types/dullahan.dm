/datum/species/dullahan
	name = "Дуллахан"
	plural_form = "Дуллаханы"
	id = SPECIES_DULLAHAN
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_USES_SKINTONES,
		TRAIT_ADVANCEDTOOLUSER, // Обычно применяется мозгом, но у нас его нет
		TRAIT_LITERATE,
		TRAIT_CAN_STRIP,
	)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/dullahan,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest,
	)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutantbrain = /obj/item/organ/brain/dullahan
	mutanteyes = /obj/item/organ/eyes/dullahan
	mutanttongue = /obj/item/organ/tongue/dullahan
	mutantears = /obj/item/organ/ears/dullahan
	mutantstomach = null
	mutantlungs = null
	skinned_type = /obj/item/stack/sheet/animalhide/human
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

	/// Реле дуллахана, связанное с владельцем, используется для обработки многих вещей, таких как речь и слух.
	var/obj/item/dullahan_relay/my_head
	/// Была ли уже обработана первая клиентская связь владельца? Полезно, когда процедуру нужно вызвать после того, как клиент переместился в нашего владельца, как для дуллаханов.
	var/owner_first_client_connection_handled = FALSE

/datum/species/dullahan/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/dullahan/on_species_gain(mob/living/carbon/human/human, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	human.lose_hearing_sensitivity(TRAIT_GENERIC)
	RegisterSignal(human, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(on_gained_part))

	var/obj/item/bodypart/head/head = human.get_bodypart(BODY_ZONE_HEAD)
	head.speech_span = null
	if(isnull(human.drop_location()))
		return
	head?.drop_limb()
	if(QDELETED(head)) // drop_limb() удаляет конечность, если нет места для падения, а дамми настройки персонажа находятся в нуль-пространстве.
		return
	my_head = new /obj/item/dullahan_relay(head, human)
	human.put_in_hands(head)

	// Мы хотим дать голове обычные глаза, чтобы спрайт головы не выглядел слишком странно.
	var/obj/item/organ/eyes/eyes = new /obj/item/organ/eyes(head)
	eyes.eye_color_left = human.eye_color_left
	eyes.eye_color_right = human.eye_color_right
	eyes.bodypart_insert(head)
	human.update_body()
	head.update_limb()
	head.update_icon_dropped()
	RegisterSignal(head, COMSIG_QDELETING, PROC_REF(on_head_destroyed))
	RegisterSignal(my_head, COMSIG_MOVABLE_MOVED, PROC_REF(on_relay_move))

/// Если мы получили новую часть тела, лучше бы это была не голова
/datum/species/dullahan/proc/on_gained_part(mob/living/carbon/human/dullahan, obj/item/bodypart/part)
	SIGNAL_HANDLER
	if(part.body_zone != BODY_ZONE_HEAD)
		return
	if(isnull(dullahan.drop_location()))
		return // не превращаем в гиббс в нуль-пространстве
	my_head = null
	dullahan.investigate_log("был превращён в гиббс из-за установки незаконной головы на [dullahan.p_their()] плечи.", INVESTIGATE_DEATHS)
	dullahan.gib(DROP_ALL_REMAINS) // Да, так что установка головы на тело - не очень хорошая идея, поэтому их оригинальная голова останется, но, удачи починить это после этого.

/// Если наша голова уничтожена, то и мы тоже
/datum/species/dullahan/proc/on_head_destroyed()
	SIGNAL_HANDLER
	var/mob/living/human = my_head?.owner
	if(QDELETED(human))
		return // наверное, мы уже умерли
	my_head = null
	human.investigate_log("был превращён в гиббс из-за потери [human.p_their()] головы.", INVESTIGATE_DEATHS)
	human.gib(DROP_ALL_REMAINS)

/// Голова была разделана? Больше не дуллахан
/datum/species/dullahan/proc/on_relay_move()
	SIGNAL_HANDLER
	if(QDELETED(my_head?.owner) || !isdullahan(my_head?.owner))
		return
	my_head.owner.gib(DROP_ALL_REMAINS)
	QDEL_NULL(my_head)

/datum/species/dullahan/on_species_loss(mob/living/carbon/human/human)
	. = ..()
	if(my_head)
		var/obj/item/bodypart/head/detached_head = my_head.loc
		UnregisterSignal(detached_head, COMSIG_QDELETING)
		my_head.owner = null
		QDEL_NULL(my_head)
		if(detached_head)
			qdel(detached_head)

	UnregisterSignal(human, COMSIG_CARBON_ATTACH_LIMB)
	human.regenerate_limb(BODY_ZONE_HEAD, FALSE)
	human.become_hearing_sensitive()
	prevent_perspective_change = FALSE
	human.reset_perspective(human)

/datum/species/dullahan/proc/update_vision_perspective(mob/living/carbon/human/human)
	var/obj/item/organ/eyes/eyes = human.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		human.update_tint()
		if(eyes.tint)
			prevent_perspective_change = FALSE
			human.reset_perspective(human, TRUE)
		else
			human.reset_perspective(my_head, TRUE)
			prevent_perspective_change = TRUE

/datum/species/dullahan/on_owner_login(mob/living/carbon/human/owner)
	var/obj/item/organ/eyes/eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
	if(owner_first_client_connection_handled)
		if(!eyes.tint)
			owner.reset_perspective(my_head, TRUE)
			prevent_perspective_change = TRUE
		return

	// Поскольку это первый раз, когда в нашем мобе есть клиент, мы можем наконец обновить его зрение, чтобы поместить его в голову!
	var/datum/action/item_action/organ_action/dullahan/eyes_toggle_perspective_action = locate() in eyes?.actions

	eyes_toggle_perspective_action?.Trigger()
	owner_first_client_connection_handled = TRUE

/datum/species/dullahan/get_physical_attributes()
	return "Дуллахан очень похож на человека, но его голова отделена от тела и должна носиться с собой."

/datum/species/dullahan/get_species_description()
	return "Злой дух, цепляющийся за землю живых из-за \
		незаконченных дел. Или так говорят книги. Они довольно милые, \
		когда узнаешь их получше."

/datum/species/dullahan/get_species_lore()
	return list(
		"\"Неудивительно, что они все такие ворчливые! Их руки всегда заняты! Я раньше думал, \
		\"Разве это не круто?\" но после того, как я в н-ный раз наблюдал, как эти существа \
		страдают от того, что их голову сбрасывают в утилизатор, я думаю, что мне хватит.\" - Капитан Ларри Додд"
	)

/datum/species/dullahan/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "horse-head",
		SPECIES_PERK_NAME = "Безголовый и бесконный",
		SPECIES_PERK_DESC = "Дуллаханы должны таскать свою голову в руках. Хотя \
			многие творческие применения могут возникнуть из-за независимости вашей головы от \
			тела, дуллаханы в основном считают это проблемой.",
	))

	return to_add

// Не существует биотипа \"Малый нежить\", поэтому мы должны объяснить это в переопределении (см.: вампиры)
/datum/species/dullahan/create_pref_biotypes_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "skull",
		SPECIES_PERK_NAME = "Малый нежить",
		SPECIES_PERK_DESC = "[name] являются малой нежитью. \
			Малая нежить наслаждается некоторыми преимуществами мёртвых, такими как \
			отсутствие необходимости дышать или есть, но не получает многих \
			иммунитетов к окружающей среде, связанных с полной нежитью.",
	))

	return to_add

/obj/item/organ/brain/dullahan
	decoy_override = TRUE
	organ_flags = ORGAN_ORGANIC // не жизненно важный

/obj/item/organ/tongue/dullahan
	zone = BODY_ZONE_CHEST
	organ_flags = parent_type::organ_flags | ORGAN_UNREMOVABLE
	modifies_speech = TRUE

/obj/item/organ/tongue/dullahan/handle_speech(datum/source, list/speech_args)
	if(ishuman(owner))
		var/mob/living/carbon/human/human = owner
		if(isdullahan(human))
			var/datum/species/dullahan/dullahan_species = human.dna.species
			if(isobj(dullahan_species.my_head.loc))
				var/obj/head = dullahan_species.my_head.loc
				if(speech_args[SPEECH_MODS][WHISPER_MODE]) // шепот
					speech_args[SPEECH_SPANS] |= SPAN_ITALICS
				head.say(speech_args[SPEECH_MESSAGE], spans = speech_args[SPEECH_SPANS], sanitize = FALSE, language = speech_args[SPEECH_LANGUAGE], message_range = speech_args[SPEECH_RANGE], message_mods = speech_args[SPEECH_MODS])
	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/ears/dullahan
	zone = BODY_ZONE_CHEST
	organ_flags = parent_type::organ_flags | ORGAN_UNREMOVABLE
	decay_factor = 0

/obj/item/organ/eyes/dullahan
	name = "head vision"
	desc = "Абстракция."
	actions_types = list(/datum/action/item_action/organ_action/dullahan)
	zone = BODY_ZONE_CHEST
	organ_flags = parent_type::organ_flags | ORGAN_UNREMOVABLE
	decay_factor = 0
	tint = INFINITY // для переключения перспективы зрения на голову при species_gain() без проблем.

/datum/action/item_action/organ_action/dullahan
	name = "Переключить перспективу"
	desc = "Переключиться между нормальным зрением из головы или слепым зрением из тела."

/datum/action/item_action/organ_action/dullahan/do_effect(trigger_flags)
	var/obj/item/organ/eyes/dullahan/dullahan_eyes = target
	dullahan_eyes.tint = dullahan_eyes.tint ? NONE : INFINITY
	if(!isdullahan(owner))
		return FALSE
	var/mob/living/carbon/human/human = owner
	var/datum/species/dullahan/dullahan_species = human.dna.species
	dullahan_species.update_vision_perspective(human)
	return TRUE

/obj/item/dullahan_relay
	name = "dullahan relay"
	/// Моб (дуллахан), который владеет этим реле.
	var/mob/living/owner

/obj/item/dullahan_relay/Initialize(mapload, mob/living/carbon/human/new_owner)
	. = ..()
	if(!new_owner)
		return INITIALIZE_HINT_QDEL
	var/obj/item/bodypart/head/detached_head = loc
	if (!istype(detached_head))
		return INITIALIZE_HINT_QDEL
	owner = new_owner
	START_PROCESSING(SSobj, src)
	RegisterSignal(owner, COMSIG_CARBON_REGENERATE_LIMBS, PROC_REF(unlist_head))
	RegisterSignal(owner, COMSIG_LIVING_REVIVE, PROC_REF(retrieve_head))
	RegisterSignal(owner, COMSIG_HUMAN_PREFS_APPLIED, PROC_REF(on_prefs_loaded))
	become_hearing_sensitive(ROUNDSTART_TRAIT)

/obj/item/dullahan_relay/Destroy()
	lose_hearing_sensitivity(ROUNDSTART_TRAIT)
	owner = null
	return ..()

/// Обновляет наши имена после применения настроек имени
/obj/item/dullahan_relay/proc/on_prefs_loaded(mob/living/carbon/human/headless)
	SIGNAL_HANDLER
	var/obj/item/bodypart/head/detached_head = loc
	if (!istype(detached_head))
		return // Всё кончено
	detached_head.real_name = headless.real_name
	detached_head.name = headless.real_name
	name = headless.real_name
	detached_head.voice = headless.voice
	detached_head.pitch = pitch
	var/obj/item/organ/brain/brain = locate(/obj/item/organ/brain) in detached_head
	brain.name = "мозг [headless.name]"

	detached_head.copy_appearance_from(headless, overwrite_eyes = TRUE)
	detached_head.update_icon_dropped()

/obj/item/dullahan_relay/Hear(atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range)
	. = ..()
	var/dist = get_dist(speaker, src) - message_range
	if(dist > 0 && dist <= EAVESDROP_EXTRA_RANGE)
		raw_message = stars(raw_message)
	if(message_range != INFINITY && dist > EAVESDROP_EXTRA_RANGE)
		return FALSE
	if(!owner)
		return FALSE
	return owner.Hear(speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, spans, message_mods, message_range = INFINITY)

/// Останавливает превращение дуллаханов в гиббс при регенерации конечностей
/obj/item/dullahan_relay/proc/unlist_head(datum/source, list/excluded_zones)
	SIGNAL_HANDLER
	excluded_zones |= BODY_ZONE_HEAD

/// Извлечение головы владельца для лучшего лечения.
/obj/item/dullahan_relay/proc/retrieve_head(datum/source, full_heal_flags)
	SIGNAL_HANDLER
	if(!(full_heal_flags & HEAL_ADMIN))
		return

	var/obj/item/bodypart/head/head = loc
	var/turf/body_turf = get_turf(owner)
	if(head && istype(head) && body_turf && !(head in owner.get_all_contents()))
		head.forceMove(body_turf)
