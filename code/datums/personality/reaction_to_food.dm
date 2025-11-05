/datum/personality/ascetic
	savefile_key = "ascetic"
	name = "Аскетичный"
	desc = "Я не особо ценю роскошную еду - это всего лишь топливо для тела."
	pos_gameplay_desc = "Огорчение от употребления нелюбимой еды уменьшено"
	neg_gameplay_desc = "Удовольствие от употребления любимой еды ограничено"
	groups = list(PERSONALITY_GROUP_FOOD)

/datum/personality/gourmand
	savefile_key = "gourmand"
	name = "Гурман"
	desc = "Еда для меня - всё!"
	pos_gameplay_desc = "Удовольствие от употребления любимой еды усилено"
	neg_gameplay_desc = "Огорчение от употребления нелюбимой еды усилено, а посредственная еда менее приятна"
	groups = list(PERSONALITY_GROUP_FOOD)

/datum/personality/teetotal
	savefile_key = "teetotal"
	name = "Трезвенник"
	desc = "Алкоголь - не для меня."
	neg_gameplay_desc = "Не любит употреблять алкоголь"
	groups = list(PERSONALITY_GROUP_ALCOHOL)

/datum/personality/bibulous
	savefile_key = "bibulous"
	name = "Любитель выпить"
	desc = "Я всегда готов выпить ещё!"
	pos_gameplay_desc = "Удовлетворение от выпивки длится дольше, даже после того, как вы уже не пьяны"
	groups = list(PERSONALITY_GROUP_ALCOHOL)
