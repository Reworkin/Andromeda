/datum/quirk/chip_connector
	name = "Chip Connector"
	desc = "(Разъём для чипов) - У вас установлено устройство, позволяющее вручную добавлять и удалять скилл-чипы! Постарайтесь не приближаться к электромагнитным импульсам."
	icon = FA_ICON_PLUG
	value = 4
	gain_text = span_notice("Вы чувствуете СВЯЗЬ.")
	lose_text = span_danger("Вы больше не чувствуете СВЯЗЬ.")
	medical_record_text = "У пациента есть кибернетический имплант на затылке, позволяющий устанавливать и удалять скилл-чипы по желанию. Отвратительно."
	mail_goodies = list()
	var/obj/item/organ/cyberimp/brain/connector/connector

/datum/quirk/chip_connector/New()
	. = ..()
	mail_goodies = assoc_to_keys(GLOB.quirk_chipped_choice) + /datum/quirk/chipped::mail_goodies

/datum/quirk/chip_connector/add_unique(client/client_source)
	. = ..()
	var/mob/living/carbon/carbon_holder = quirk_holder
	if(!iscarbon(quirk_holder))
		return
	connector = new()
	connector.Insert(carbon_holder, special = TRUE)

/datum/quirk/chip_connector/post_add()
	to_chat(quirk_holder, span_bolddanger(desc)) // efficiency is clever laziness

/datum/quirk/chip_connector/remove()
	qdel(connector)
