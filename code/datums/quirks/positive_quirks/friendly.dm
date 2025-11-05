/datum/quirk/friendly
	name = "Friendly"
	desc = "(Дружелюбный) - Вы дарите лучшие объятия, особенно когда находитесь в подходящем настроении."
	icon = FA_ICON_HANDS_HELPING
	value = 2
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("Вам хочется кого-нибудь обнять.")
	lose_text = span_danger("Вы больше не чувствуете потребности обнимать других.")
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациент демонстрирует низкие запреты на физический контакт и хорошо развитые руки. Запрашиваю другого врача для ведения этого случая."
	mail_goodies = list(/obj/item/storage/box/hug)

/datum/quirk/friendly/add_unique(client/client_source)
	var/mob/living/carbon/human/human_quirkholder = quirk_holder
	var/obj/item/organ/heart/holder_heart = human_quirkholder.get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(holder_heart) || isnull(holder_heart.reagents))
		return
	holder_heart.reagents.maximum_volume = 20
	// У нас большое сердце, полное любви!
	holder_heart.reagents.add_reagent(/datum/reagent/love, 2.5)
	// И физически больше.
	holder_heart.reagents.add_reagent(/datum/reagent/consumable/nutriment/organ_tissue, 5)
	holder_heart.transform = holder_heart.transform.Scale(1.5)
	holder_heart.beat_noise += ". Излучает любящее тепло" // wuv is a detectable diagnostic quality
