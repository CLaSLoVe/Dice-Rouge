extends Node

# update job credit
signal credit_update_to(value: int)
signal magic_update(value: int)
signal magic_changed()
signal strike_update(value: int)

# ---dice
# dice to base
signal all_dice_to_base

# obtain dice x change
signal dice_on_shot_area(value)
signal dice_right_clicked(dice_ui)

# dice into/from job box
signal dice_into_job_box
signal dice_retrieve_from_job



# enemy
signal select_enemy(enemy)

# battle related
signal battle_win
signal battle_lose
signal new_battle_start
signal player_round_end
signal player_round_start(a, b)
signal battle_counter_update

# buff update
signal buff_update

# check accessible
signal check_skill_access
signal update_skills

# user operation
signal press_shot
signal shot_end


## choose smith symbol
signal smith_symbol_choice(dice_id, symbol_id)
signal relax_choice(things)
signal store_choose(skill, prize)
signal update_store_state



# choose award
signal award_choice
signal award_finished
