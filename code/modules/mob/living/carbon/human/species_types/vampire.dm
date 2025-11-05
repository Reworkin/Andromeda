/// сколько вампиров существует в каждом доме
#define VAMPIRES_PER_HOUSE 5
/// максимум, который вампир выпьет, они выпьют меньше, если достигнут своего предела
#define VAMP_DRAIN_AMOUNT 50

/datum/species/human/vampire
	name = "Вампир"
	plural_form = "Вампиры"
	id = SPECIES_VAMPIRE
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_BLOOD_CLANS,
		TRAIT_USES_SKINTONES,
		TRAIT_NO_MIRROR_REFLECTION,
	)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	changesource_flags = MIRROR_BADMIN | MIRROR_PRIDE | WABBAJACK | ERT_SPAWN
	exotic_bloodtype = BLOOD_TYPE_VAMPIRE
	blood_deficiency_drain_rate = BLOOD_DEFICIENCY_MODIFIER // вампиры уже пассивно теряют кровь, так что это просто заставляет их терять её немного быстрее при дефиците крови.
	mutantheart = /obj/item/organ/heart/vampire
	mutanttongue = /obj/item/organ/tongue/vampire
	/// начальный текст, отправляемый вампиру изначально, потому что вампирам нужно что-то делать, чтобы выжить
	var/info_text = "Вы - <span class='danger'>Вампир</span>. Вы будете медленно, но постоянно терять кровь, если находитесь вне гроба. Если внутри гроба, вы будете медленно исцеляться. Вы можете получить больше крови, схватив живую жертву и используя свою способность высасывания."
	/// UI, отображающий, сколько у нас крови
	var/atom/movable/screen/blood_level/blood_display

/datum/species/human/vampire/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/human/vampire/on_species_gain(mob/living/carbon/human/new_vampire, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	to_chat(new_vampire, "[info_text]")
	new_vampire.skin_tone = "albino"
	new_vampire.update_body(0)
	RegisterSignal(new_vampire, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	if(new_vampire.hud_used)
		on_hud_created(new_vampire)
	else
		RegisterSignal(new_vampire, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/species/human/vampire/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_ATOM_ATTACKBY)
	QDEL_NULL(blood_display)

/datum/species/human/vampire/spec_life(mob/living/carbon/human/vampire, seconds_per_tick, times_fired)
	. = ..()
	if(istype(vampire.loc, /obj/structure/closet/crate/coffin))
		var/need_mob_update = FALSE
		need_mob_update += vampire.heal_overall_damage(brute = 2 * seconds_per_tick, burn = 2 * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		need_mob_update += vampire.adjustToxLoss(-2 * seconds_per_tick, updating_health = FALSE,)
		need_mob_update += vampire.adjustOxyLoss(-2 * seconds_per_tick, updating_health = FALSE,)
		if(need_mob_update)
			vampire.updatehealth()
		return
	vampire.blood_volume -= 0.125 * seconds_per_tick
	if(vampire.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(vampire, span_danger("У вас закончилась кровь!"))
		vampire.investigate_log("был обращён в пыль из-за нехватки крови (вампир).", INVESTIGATE_DEATHS)
		vampire.dust()
	var/area/A = get_area(vampire)
	if(istype(A, /area/station/service/chapel))
		to_chat(vampire, span_warning("Вы не принадлежите этому месту!"))
		vampire.adjustFireLoss(10 * seconds_per_tick)
		vampire.adjust_fire_stacks(3 * seconds_per_tick)
		vampire.ignite_mob()

///Даёт вампиру HUD крови, чтобы он всегда знал, сколько у него крови.
/datum/species/human/vampire/proc/on_hud_created(mob/source)
	SIGNAL_HANDLER
	var/datum/hud/blood_hud = source.hud_used
	blood_display = new(null, blood_hud)
	blood_hud.infodisplay += blood_display
	blood_hud.show_hud(blood_hud.hud_version)

/datum/species/human/vampire/proc/on_attackby(mob/living/source, obj/item/attacking_item, mob/living/attacker, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/nullrod/whip))
		MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 2)

/datum/species/human/vampire/get_physical_attributes()
	return "Вампиры страдают от жажды, нуждаясь утолять её, высасывая кровь из другого живого существа. Однако им не нужно дышать или есть обычным образом. \
		Они мгновенно превращаются в пыль, если у них заканчивается кровь или они входят в священную зону. Однако гробы стабилизируют и исцеляют их и они могут превращаться в летучих мышей!"

/datum/species/human/vampire/get_species_description()
	return "Элегантный Вампир! Они спускаются на Космическую Станцию 13 каждый год, чтобы напугать экипаж!"

/datum/species/human/vampire/get_species_lore()
	return list(
		"Вампиры - нечестивые существа, благословленные и проклятые Жаждой. \
		Жажда требует от них пить кровь, чтобы оставаться в живых и в ответ даёт им много бонусов. \
		Из-за этого вампиры разделились на два клана: один принимает свои силы как благословение, а другой отвергает их.",
	)

/datum/species/human/vampire/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bed",
			SPECIES_PERK_NAME = "Гробовое высиживание",
			SPECIES_PERK_DESC = "Вампиры могут отсрочить Жажду и исцелиться, отдыхая в гробу. Так ВОТ почему они это делают!",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "book-dead",
			SPECIES_PERK_NAME = "Кланы вампиров",
			SPECIES_PERK_DESC = "Вампиры принадлежат к одному из двух кланов - Привитые и Изгнанники. Изгнанники \
				не следуют многим вампирским традициям, в то время как Привитым даются уникальные имена и стиль.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "cross",
			SPECIES_PERK_NAME = "Против бога и природы",
			SPECIES_PERK_DESC = "Почти все высшие силы испытывают отвращение к существованию \
				Вампиров, а вход в Церковь - это самоубийство. Не делайте этого!",
		),
	)

	return to_add

// Кровь вампира особенная, поэтому её нужно обрабатывать отдельной записью.
/datum/species/human/vampire/create_pref_blood_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "Жажда",
		SPECIES_PERK_DESC = "Вместо еды вампиры страдают от Жажды. \
			Жажды чего? Крови! Их язык позволяет им хватать людей и пить \
			их кровь, и они умрут, если у них закончится кровь. Как примечание, не имеет \
			значения, чью кровь вы пьёте, она вся будет преобразована в вашу группу \
			крови при потреблении.",
	))

	return to_add

// Не существует биотипа \"Малая нежить\", поэтому мы должны объяснить это в переопределении (см.: дуллаханы)
/datum/species/human/vampire/create_pref_biotypes_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "skull",
		SPECIES_PERK_NAME = "Малая нежить",
		SPECIES_PERK_DESC = "[name] являются малой нежитью. \
			Малая нежить наслаждается некоторыми преимуществами мёртвых, такими как \
			отсутствие необходимости дышать или есть, но не получает многих \
			иммунитетов к окружающей среде, связанных с полной нежитью.",
	))

	return to_add

/obj/item/organ/tongue/vampire
	name = "vampire teeth"
	desc = "Единственная вещь, с которой допустимо говорить \"Я высосу тебя досуха!\""
	icon_state = "tongue_vampire"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	organ_traits = list(
		TRAIT_SPEAKS_CLEARLY,
		TRAIT_DRINKS_BLOOD,
		// будущее todo : привязать nobreath и nohunger к бонусу набора органов вампира
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
	)
	COOLDOWN_DECLARE(drain_cooldown)

/obj/item/organ/tongue/vampire/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	RegisterSignal(receiver, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(stab_bloodbag))

/obj/item/organ/tongue/vampire/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_ATOM_ITEM_INTERACTION)

/obj/item/organ/tongue/vampire/proc/stab_bloodbag(mob/living/source, mob/living/user,  obj/item/used_item, list/modifiers)
	SIGNAL_HANDLER

	if(user != source)
		return NONE
	if(!istype(used_item, /obj/item/reagent_containers/blood))
		return NONE
	if(used_item.reagents?.total_volume <= 0)
		to_chat(user, span_warning("[src] пуст!"))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice("[user] протыкает [used_item] своими острыми зубами и высасывает его содержимое!"),
		span_notice("Вы протыкаете [used_item] своими острыми зубами и высасываете его содержимое!"),
		span_hear("Вы слышите звук протыкания! ... За которым следует.. хлюпанье?"),
		COMBAT_MESSAGE_RANGE,
	)
	INVOKE_ASYNC(src, PROC_REF(async_stab_bloodbag), user, used_item)
	return ITEM_INTERACT_BLOCKING

/obj/item/organ/tongue/vampire/proc/async_stab_bloodbag(mob/living/carbon/user, obj/item/reagent_containers/blood/bloodbag, time = 0.5 SECONDS)
	if(!do_after(user, time, bloodbag))
		return

	to_chat(user, span_notice("Вы делаете глоток [src]."))
	playsound(bloodbag, 'sound/items/drink.ogg', 50, TRUE) //хлюп
	bloodbag.reagents.trans_to(user, bloodbag.reagents.maximum_volume * 0.05, transferred_by = user, methods = INGEST)
	if(bloodbag.reagents.total_volume > 0)
		async_stab_bloodbag(user, bloodbag, 1 SECONDS)

/datum/action/item_action/organ_action/vampire
	name = "Высасывание жертвы"
	desc = "Высасывайте кровь у любой жертвы, которую вы пассивно держите."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "drain_victim"
	background_icon_state = "bg_vampire"

/datum/action/item_action/organ_action/vampire/do_effect(trigger_flags)
	if(!iscarbon(owner))
		return FALSE

	var/mob/living/carbon/user = owner
	var/obj/item/organ/tongue/vampire/licker_drinker = target
	if(!COOLDOWN_FINISHED(licker_drinker, drain_cooldown))
		to_chat(user, span_warning("Вы только что высосали кровь, подождите несколько секунд!"))
		return FALSE

	if(!iscarbon(user.pulling))
		return FALSE

	var/mob/living/carbon/victim = user.pulling
	if(user.blood_volume >= BLOOD_VOLUME_MAXIMUM)
		to_chat(user, span_warning("Вы уже сыты!"))
		return FALSE
	if(victim.stat == DEAD)
		to_chat(user, span_warning("Вам нужна живая жертва!"))
		return FALSE
	var/blood_name = LOWER_TEXT(user.get_bloodtype()?.get_blood_name())
	if(!victim.blood_volume || victim.get_blood_reagent() != user.get_blood_reagent())
		if (blood_name)
			to_chat(user, span_warning("У [victim] нет [blood_name]!"))
		else
			to_chat(user, span_warning("У [victim] нет ничего внутри, что вы могли бы переварить!"))
		return FALSE
	COOLDOWN_START(licker_drinker, drain_cooldown, 3 SECONDS)
	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
		victim.show_message(span_warning("[user] пытается укусить вас, но останавливается, не коснувшись вас!"))
		to_chat(user, span_warning("[victim] благословлен! Вы останавливаетесь как раз вовремя, чтобы избежать возгорания."))
		return FALSE
	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[user] пытается укусить вас, но отшатывается с отвращением!"))
		to_chat(user, span_warning("[victim] смердит чесноком! вы не можете заставить себя пить такую испорченную кровь."))
		return FALSE
	if(!do_after(user, 3 SECONDS, target = victim, hidden = TRUE))
		return FALSE
	var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - user.blood_volume //Сколько у нас осталось места для поглощения крови
	var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)
	victim.show_message(span_danger("[user] высасывает вашу кровь!"))
	to_chat(user, span_notice("Вы высосали немного крови!"))
	playsound(user, 'sound/items/drink.ogg', 30, TRUE, -2)
	victim.blood_volume = clamp(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
	user.blood_volume = clamp(user.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
	if(!victim.blood_volume)
		to_chat(user, span_notice("Вы опустошили запас [blood_name] у [victim]."))
	return TRUE

/obj/item/organ/heart/vampire
	name = "vampire heart"
	icon_state = "heart_vampire"
	desc = "Какой-то парень зарезал своего брата 6000 лет назад, так что теперь у вас есть это."

#undef VAMPIRES_PER_HOUSE
#undef VAMP_DRAIN_AMOUNT
