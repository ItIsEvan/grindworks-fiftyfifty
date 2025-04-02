extends Node

"""
Rolls to randomly destroy non-progression chests when interacted.
We do this using a custom "nothing" item that we override the chest with.
This way, we aren't messing with the items in play, or adding to "seen items".
"""

const FIFTY_FIFTY_DIR := "itsevan-fiftyfifty"
const NOTHING_ITEM_FILE := "item_nothing.tres"
const FIFTY_FIFTY_LOG := "itsevan-fiftyfifty:Main"

func _ready() -> void:
	get_tree().node_added.connect(on_node_added)

func on_node_added(node : Node) -> void:
	if node is TreasureChest:
		chest_spawned(node)

func chest_spawned(chest : TreasureChest) -> void:
	if not chest.scripted_progression and RandomService.randi_channel('chest_rolls') % 2 == 0:
		chest.override_item = get_nothing()
		ModLoaderLog.info("Chest Item Overridden", FIFTY_FIFTY_LOG)

func get_nothing() -> Item:
	return load(ModLoaderMod.get_unpacked_dir().path_join(FIFTY_FIFTY_DIR).path_join(NOTHING_ITEM_FILE))
