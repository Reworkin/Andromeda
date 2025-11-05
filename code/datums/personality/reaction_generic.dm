/datum/personality/apathetic
	savefile_key = "apathetic"
	name = "Апатичный"
	desc = "Меня мало что волнует. Ни хорошее, ни плохое, и уж точно не уродливое."
	neut_gameplay_desc = "Все настроения влияют на вас меньше"
	groups = list(PERSONALITY_GROUP_MOOD_POWER)

/datum/personality/apathetic/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier -= 0.2

/datum/personality/apathetic/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier += 0.2

/datum/personality/sensitive
	savefile_key = "sensitive"
	name = "Чувствительный"
	desc = "Я легко поддаюсь влиянию окружающего мира."
	neut_gameplay_desc = "Все настроения влияют на вас сильнее"
	groups = list(PERSONALITY_GROUP_MOOD_POWER)

/datum/personality/sensitive/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier += 0.2

/datum/personality/sensitive/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier -= 0.2

/datum/personality/resilient
	savefile_key = "resilient"
	name = "Устойчивый"
	desc = "Всё равно. Я могу это выдержать!"
	pos_gameplay_desc = "Негативные настроения исчезают быстрее"
	groups = list(PERSONALITY_GROUP_MOOD_LENGTH)

/datum/personality/resilient/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier -= 0.2

/datum/personality/resilient/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier += 0.2

/datum/personality/brooding
	savefile_key = "brooding"
	name = "Угрюмый"
	desc = "Всё меня задевает, и я не могу не думать об этом."
	neg_gameplay_desc = "Негативные настроения длятся дольше"
	groups = list(PERSONALITY_GROUP_MOOD_LENGTH)

/datum/personality/brooding/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier += 0.2

/datum/personality/brooding/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier -= 0.2

/datum/personality/hopeful
	savefile_key = "hopeful"
	name = "Надеющийся"
	desc = "Я верю, что всё всегда наладится."
	pos_gameplay_desc = "Позитивные настроения длятся дольше"
	groups = list(PERSONALITY_GROUP_HOPE)

/datum/personality/hopeful/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier += 0.2

/datum/personality/hopeful/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier -= 0.2

/datum/personality/pessimistic
	savefile_key = "pessimistic"
	name = "Пессимистичный"
	desc = "Я верю, что наши лучшие дни позади."
	neg_gameplay_desc = "Позитивные настроения длятся меньше"
	groups = list(PERSONALITY_GROUP_HOPE)

/datum/personality/pessimistic/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier -= 0.2

/datum/personality/pessimistic/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier += 0.2

/datum/personality/whimsical
	savefile_key = "whimsical"
	name = "Причудливый"
	desc = "Эта станция иногда слишком серьёзная, расслабьтесь!"
	pos_gameplay_desc = "Любит внешне бессмысленные, но забавные вещи и не против клоунских шуток"

/datum/personality/snob
	savefile_key = "snob"
	name = "Снобистский"
	desc = "Я ожидаю только самого лучшего от этой станции - всё остальное неприемлемо!"
	neut_gameplay_desc = "Качество помещения влияет на ваше настроение"
	personality_trait = TRAIT_SNOB
