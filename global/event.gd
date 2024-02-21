extends Node

signal dice_to_job
signal dice_to_hand
signal dice_to_trash
signal dice_to_shot(dice_ui: DiceUI)


signal attr_changed

signal set_target

signal win(layer)
signal lose

signal buff_update(character)

signal take_damage(character, value)
signal enemy_die(character)
