/datum/quirk/item_quirk/chronic_illness
	name = "Eradicative Chronic Illness"
	desc = "(Хроническое заболевание) - У вас аномальное хроническое заболевание, требующее постоянного приёма лекарств для контроля, иначе оно вызывает коррекцию временного потока."
	icon = FA_ICON_DISEASE
	value = -12
	gain_text = span_danger("Вы чувствуете, как исчезаете...")
	lose_text = span_notice("Вы внезапно чувствуете себя более осязаемым.")
	medical_record_text = "У пациента аномальное хроническое заболевание, требующее постоянного приёма лекарств для контроля."
	hardcore_value = 12
	mail_goodies = list(/obj/item/storage/pill_bottle/sansufentanyl)

/datum/quirk/item_quirk/chronic_illness/add(client/client_source)
	var/datum/disease/chronic_illness/hms = new /datum/disease/chronic_illness()
	quirk_holder.ForceContractDisease(hms)

/datum/quirk/item_quirk/chronic_illness/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/pill_bottle/sansufentanyl, list(LOCATION_BACKPACK), flavour_text = "Вам предоставили лекарства для помощи в управлении вашим состоянием. Принимайте их регулярно, чтобы избежать осложнений.", notify_player = TRUE)
	give_item_to_holder(/obj/item/healthanalyzer/simple/disease, list(LOCATION_BACKPACK))
