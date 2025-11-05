/datum/quirk/item_quirk/narcolepsy
	name = "Narcolepsy"
	desc = "(Нарколепсия) - Вы часто чувствуете сонливость и можете заснуть в любой момент. Кофеин, ходьба или даже подавление симптомов стимуляторами, назначенными или иными, могут помочь вам продержаться смену..."
	icon = FA_ICON_BED
	value = -8
	hardcore_value = 8
	medical_record_text = "Пациент может непроизвольно засыпать во время обычной деятельности и чувствовать сонливость в любой момент."
	mail_goodies = list(
		/obj/item/reagent_containers/cup/glass/coffee,
		/obj/item/reagent_containers/cup/soda_cans/space_mountain_wind,
		/obj/item/storage/pill_bottle/prescription_stimulant,
	)

/datum/quirk/item_quirk/narcolepsy/add_unique(client/client_source)
	var/mob/living/carbon/carbon_user = quirk_holder
	carbon_user.gain_trauma(/datum/brain_trauma/severe/narcolepsy/permanent, TRAUMA_RESILIENCE_ABSOLUTE)

	give_item_to_holder(
		/obj/item/storage/pill_bottle/prescription_stimulant,
		list(
			LOCATION_BACKPACK,
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_HANDS,
		),
		flavour_text = "Выдано вам для помощи в поддержании бодрости в эту смену...",
		notify_player = TRUE,
	)

/datum/quirk/item_quirk/narcolepsy/remove()
	if(!QDELETED(quirk_holder) && quirk_holder.get_organ_by_type(/obj/item/organ/brain))
		var/mob/living/carbon/carbon_user = quirk_holder
		carbon_user?.cure_trauma_type(/datum/brain_trauma/severe/narcolepsy/permanent, TRAUMA_RESILIENCE_ABSOLUTE)
