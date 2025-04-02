extends Node3D


func setup(item : Item) -> void:
	# Remove item from play
	ItemService.item_removed(item)
	
	# Destroy treasure chest
	var treasure_chest : TreasureChest = NodeGlobals.get_ancestor_of_type(self, TreasureChest)
	if not treasure_chest:
		return
	treasure_chest.vanish()
