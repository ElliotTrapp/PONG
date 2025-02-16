extends OptionButton


func _on_item_selected(index: int) -> void:
	var item = get_item_text(index).to_upper()
	Settings.selected_skill = Settings.Skill[item]
