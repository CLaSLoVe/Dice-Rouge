extends Control

@onready var relicselector = $relicselector

func init():
	var inactive_relic = get_tree().get_first_node_in_group('inactive_relic').get_children()
	var p: Array[int]
	for child in inactive_relic:
		p.append(child.relic.p)
	var selected_relic = Funcs.select_n_with_p(inactive_relic, 3, p)
	for i in (selected_relic.size()):
		selected_relic[i].reparent(relicselector.get_node('relicbox'+str(i+1)+'/cbox'))
		
