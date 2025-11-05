/datum/quirk/settler
	name = "Settler"
	desc = "(Поселенец) - Вы из рода самых первых космических поселенцев! Хотя многолетнее воздействие различной гравитации на вашу семью \
		привело к ... меньшему росту, чем обычно для вашего вида, вы компенсируете это лучшими навыками выживания на природе и \
		переноски тяжелого оборудования. Вы также отлично ладите с животными. Однако вы немного медлительны из-за своих коротких ног."
	gain_text = span_bold("Вы чувствуете, что весь мир у ваших ног!")
	lose_text = span_danger("Вы думаете, что, возможно, останетесь сегодня дома.")
	icon = FA_ICON_HOUSE
	value = 4
	mob_trait = TRAIT_SETTLER
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	medical_record_text = "Пациент длительное время подвергался воздействию планетарных условий, что привело к чрезмерно коренастому телосложению."
	mail_goodies = list(
		/obj/item/clothing/shoes/workboots/mining,
		/obj/item/gps,
	)
	/// Most of the behavior of settler is from these traits, rather than exclusively the quirk
	var/list/settler_traits = list(
		TRAIT_EXPERT_FISHER,
		TRAIT_ROUGHRIDER,
		TRAIT_STUBBY_BODY,
		TRAIT_BEAST_EMPATHY,
		TRAIT_STURDY_FRAME,
	)

/datum/quirk/settler/add(client/client_source)
	var/mob/living/carbon/human/human_quirkholder = quirk_holder
	human_quirkholder.set_mob_height(HUMAN_HEIGHT_SHORTEST)
	human_quirkholder.add_movespeed_modifier(/datum/movespeed_modifier/settler)
	human_quirkholder.add_traits(settler_traits, QUIRK_TRAIT)

/datum/quirk/settler/remove()
	if(QDELING(quirk_holder))
		return
	var/mob/living/carbon/human/human_quirkholder = quirk_holder
	human_quirkholder.set_mob_height(HUMAN_HEIGHT_MEDIUM)
	human_quirkholder.remove_movespeed_modifier(/datum/movespeed_modifier/settler)
	human_quirkholder.remove_traits(settler_traits, QUIRK_TRAIT)
