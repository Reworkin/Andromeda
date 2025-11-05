/datum/personality/gambler
	savefile_key = "gambler"
	name = "Азартный"
	desc = "Бросить кости всегда стоит того!"
	pos_gameplay_desc = "Любит азартные игры и карточные игры, и спокоен при проигрыше"

/datum/personality/slacking
	/// Зоны, которые считаются "бездельничанием"
	var/list/slacker_areas = list(
		/area/station/commons/fitness,
		/area/station/commons/lounge,
		/area/station/service/bar,
		/area/station/service/cafeteria,
		/area/station/service/library,
		/area/station/service/minibar,
		/area/station/service/theater,
	)
	/// Событие настроения, применяемое при нахождении в зоне безделья
	var/mood_event_type

/datum/personality/slacking/apply_to_mob(mob/living/who)
	. = ..()
	who.apply_status_effect(/datum/status_effect/moodlet_in_area, mood_event_type, slacker_areas, CALLBACK(src, PROC_REF(is_slacking)))

/datum/personality/slacking/remove_from_mob(mob/living/who)
	. = ..()
	who.remove_status_effect(/datum/status_effect/moodlet_in_area, mood_event_type)

/// Callback для эффекта настроения в зоне, чтобы определить, бездельничаем ли мы
/datum/personality/slacking/proc/is_slacking(mob/living/who, area/new_area)
	if(!istype(new_area, /area/station/service))
		return TRUE
	// Работники сервиса не бездельничают в сервисных зонах
	if(who.mind?.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_SERVICE)
		return FALSE

	return TRUE

/datum/personality/slacking/lazy
	savefile_key = "lazy"
	name = "Ленивый"
	desc = "Мне сегодня не очень хочется работать."
	pos_gameplay_desc = "Счастлив в баре или зонах отдыха"
	mood_event_type = /datum/mood_event/slacking_off_lazy
	groups = list(PERSONALITY_GROUP_RECREATION, PERSONALITY_GROUP_WORK, PERSONALITY_GROUP_ATHLETICS)

/datum/personality/slacking/diligent
	savefile_key = "diligent"
	name = "Старательный"
	desc = "Здесь нужно всё сделать!"
	pos_gameplay_desc = "Счастлив, когда находится в своём отделе"
	neg_gameplay_desc = "Несчастлив, когда бездельничает в баре или зонах отдыха"
	mood_event_type = /datum/mood_event/slacking_off_diligent
	groups = list(PERSONALITY_GROUP_RECREATION)

/datum/personality/slacking/diligent/apply_to_mob(mob/living/who)
	. = ..()
	RegisterSignals(who, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_SET_ROLE), PROC_REF(update_effect))
	// К сожалению, изменения работы в игре, например через HoP, пропускаются
	who.apply_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent, who.mind?.get_work_areas())

/datum/personality/slacking/diligent/remove_from_mob(mob/living/who)
	. = ..()
	UnregisterSignal(who, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_SET_ROLE))
	who.remove_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent)

/// Обработчик сигнала для обновления нашего эффекта при смене работы
/datum/personality/slacking/diligent/proc/update_effect(mob/living/source, ...)
	SIGNAL_HANDLER

	source.remove_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent)
	source.apply_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent, source.mind.get_work_areas())

/datum/personality/industrious
	savefile_key = "industrious"
	name = "Трудолюбивый"
	desc = "Все должны работать - иначе мы все тратим время зря."
	neg_gameplay_desc = "Не любит играть в игры"
	groups = list(PERSONALITY_GROUP_WORK)

/datum/personality/athletic
	savefile_key = "athletic"
	name = "Атлетичный"
	desc = "Нельзя же просто сидеть весь день! Нужно продолжать двигаться."
	pos_gameplay_desc = "Любит заниматься спортом"
	neg_gameplay_desc = "Не любит лениться"
	groups = list(PERSONALITY_GROUP_ATHLETICS)

/datum/personality/erudite
	savefile_key = "erudite"
	name = "Эрудированный"
	desc = "Знание - сила. Особенно так глубоко в космосе."
	pos_gameplay_desc = "Любит читать книги"
	groups = list(PERSONALITY_GROUP_READING)

/datum/personality/uneducated
	savefile_key = "uneducated"
	name = "Необразованный"
	desc = "Меня не особо волнуют книги - я уже знаю всё, что мне нужно."
	neg_gameplay_desc = "Не любит читать книги"
	groups = list(PERSONALITY_GROUP_READING)

/datum/personality/spiritual
	savefile_key = "spiritual"
	name = "Духовный"
	desc = "Я верю в высшую силу."
	pos_gameplay_desc = "Любит часовню и капеллана, имеет особые молитвы"
	neg_gameplay_desc = "Не любит нечестивые вещи"
	personality_trait = TRAIT_SPIRITUAL
