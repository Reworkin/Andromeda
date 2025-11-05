/datum/quirk/touchy
	name = "Touchy"
	desc = "(Осязательный) - Вы очень осязательны и должны физически иметь возможность прикоснуться к чему-либо, чтобы осмотреть это."
	icon = FA_ICON_HAND
	value = -2
	gain_text = span_danger("Вы чувствуете, что не можете осматривать вещи на расстоянии.")
	lose_text = span_notice("Вы чувствуете, что можете осматривать вещи на расстоянии.")
	medical_record_text = "Пациент не может различать объекты на расстоянии."
	hardcore_value = 4

/datum/quirk/touchy/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_CLICK_SHIFT, PROC_REF(examinate_check))

/datum/quirk/touchy/remove()
	UnregisterSignal(quirk_holder, COMSIG_CLICK_SHIFT)

///Checks if the mob is besides the  thing being examined, if they aren't then we cancel their examinate.
/datum/quirk/touchy/proc/examinate_check(mob/examiner, atom/examined)
	SIGNAL_HANDLER

	if(!examined.Adjacent(examiner))
		return COMSIG_MOB_CANCEL_CLICKON
