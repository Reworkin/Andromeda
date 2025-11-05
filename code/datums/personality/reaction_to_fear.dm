/datum/personality/brave
	savefile_key = "brave"
	name = "Смелый"
	desc = "Понадобится нечто большее, чем немного крови, чтобы напугать меня."
	pos_gameplay_desc = "Страх накапливается медленнее, и настроения, связанные со страхом, слабее"
	groups = list(PERSONALITY_GROUP_GENERAL_FEAR, PERSONALITY_GROUP_PEOPLE_FEAR)

/datum/personality/cowardly
	savefile_key = "cowardly"
	name = "Трусливый"
	desc = "Всё вокруг представляет опасность! Даже воздух!"
	neg_gameplay_desc = "Страх накапливается быстрее, и настроения, связанные со страхом, сильнее"
	groups = list(PERSONALITY_GROUP_GENERAL_FEAR)
