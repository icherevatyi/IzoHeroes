extends Control


func init(title: String, perk_lvl: int) -> void:
	get_node("PerkLvl").set_text(str(perk_lvl))
	get_node("PerkTooltip").set_text(title)
	get_node("PerkTooltip").set_visible(false)
