extends Node

signal dice_to_job
signal dice_to_hand
signal dice_to_trash
signal dice_to_shot(dice_ui: DiceUI)


signal attr_changed

signal set_target

signal win(layer)
signal win_ui_pop_up
signal lose

signal dice_selector_selected(selector)
signal relic_selected
signal skill_selected

signal init_award

signal next_turn_start
signal award_selected(label)

signal buff_update(character)

signal take_damage(character, value)
signal enemy_die(character)
