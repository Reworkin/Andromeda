/datum/quirk/foreigner
	name = "Foreigner"
	desc = "(Иностранец) - Вы не здешний. Вы не знаете Общегалактический язык!"
	icon = FA_ICON_LANGUAGE
	value = 0
	gain_text = span_notice("Слова, которые говорят вокруг, не имеют для вас никакого смысла.")
	lose_text = span_notice("Вы освоили Общегалактический язык.")
	medical_record_text = "Пациент не говорит на Общегалактическом языке и может требовать переводчика."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.grant_language(/datum/language/uncommon, source = LANGUAGE_QUIRK)

/datum/quirk/foreigner/remove()
	if(QDELETED(quirk_holder))
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.remove_language(/datum/language/uncommon)
