#define GAMING_WITHDRAWAL_TIME (15 MINUTES)
/datum/quirk/gamer
	name = "Gamer"
	desc = "(Игроман) - Вы заядлый геймер и вам нужно играть. Вы любите побеждать и ненавидите проигрывать. Вам нравится только еда геймеров."
	icon = FA_ICON_GAMEPAD
	value = 0
	gain_text = span_notice("Вы чувствуете внезапное желание играть.")
	lose_text = span_notice("Вы потеряли весь интерес к играм.")
	medical_record_text = "Пациент имеет серьёзную игровую зависимость."
	mob_trait = TRAIT_GAMER
	mail_goodies = list(/obj/item/toy/intento, /obj/item/clothing/head/fedora)
	/// Таймер для начала ломки от игр
	var/gaming_withdrawal_timer = TIMER_ID_NULL

/datum/quirk/gamer/add(client/client_source)
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue)
		// Диета геймера
		tongue.liked_foodtypes = JUNKFOOD
	RegisterSignal(quirk_holder, COMSIG_MOB_WON_VIDEOGAME, PROC_REF(won_game))
	RegisterSignal(quirk_holder, COMSIG_MOB_LOST_VIDEOGAME, PROC_REF(lost_game))
	RegisterSignal(quirk_holder, COMSIG_MOB_PLAYED_VIDEOGAME, PROC_REF(gamed))

/datum/quirk/gamer/post_add()
	// Геймер начинает без ломки
	gaming_withdrawal_timer = addtimer(CALLBACK(src, PROC_REF(enter_withdrawal)), GAMING_WITHDRAWAL_TIME, TIMER_STOPPABLE)

/datum/quirk/gamer/remove()
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue)
		tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
	UnregisterSignal(quirk_holder, COMSIG_MOB_WON_VIDEOGAME)
	UnregisterSignal(quirk_holder, COMSIG_MOB_LOST_VIDEOGAME)
	UnregisterSignal(quirk_holder, COMSIG_MOB_PLAYED_VIDEOGAME)

/**
 * Геймер выиграл игру
 *
 * Выполняется по сигналу COMSIG_MOB_WON_VIDEOGAME
 * Этот сигнал должен вызываться, когда игрок выиграл видеоигру.
 * (Например, Orion Trail)
 */
/datum/quirk/gamer/proc/won_game()
	SIGNAL_HANDLER
	// Эпичная победа геймера
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_won", /datum/mood_event/gamer_won)

/**
 * Геймер проиграл игру
 *
 * Выполняется по сигналу COMSIG_MOB_LOST_VIDEOGAME
 * Этот сигнал должен вызываться, когда игрок проиграл видеоигру.
 * (Например, Orion Trail)
 */
/datum/quirk/gamer/proc/lost_game()
	SIGNAL_HANDLER
	// Выполняется, когда геймер проиграл
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_lost", /datum/mood_event/gamer_lost)
	// Выполняется асинхронно из-за say()
	INVOKE_ASYNC(src, PROC_REF(gamer_moment))

/**
 * Геймер играет в игру
 *
 * Выполняется по сигналу COMSIG_MOB_PLAYED_VIDEOGAME
 * Этот сигнал должен вызываться, когда игрок взаимодействует с видеоигрой.
 */
/datum/quirk/gamer/proc/gamed()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/human_holder = quirk_holder
	// Убрать штраф за ломку
	human_holder.clear_mood_event("gamer_withdrawal")
	// Сбросить таймер ломки
	if (gaming_withdrawal_timer)
		deltimer(gaming_withdrawal_timer)
	gaming_withdrawal_timer = addtimer(CALLBACK(src, PROC_REF(enter_withdrawal)), GAMING_WITHDRAWAL_TIME, TIMER_STOPPABLE)


/datum/quirk/gamer/proc/gamer_moment()
	// Это был горячий геймерский момент...
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.say(";[pick("ДЕРЬМО", "СУКА", "БЛЯДЬ", "ПИЗДА", "МУДОСОС", "УЁБОК")]!!", forced = name)

/datum/quirk/gamer/proc/enter_withdrawal()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_withdrawal", /datum/mood_event/gamer_withdrawal)

#undef GAMING_WITHDRAWAL_TIME
