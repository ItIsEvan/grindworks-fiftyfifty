extends Node

## Rolls to randomly destroy non-progression chests when interacted


const FIFTY_FIFTY_DIR := "itsevan-fiftyfifty"
const FIFTY_FIFTY_LOG := "itsevan-fiftyfifty:Main"

func _ready() -> void:
	Globals.s_chest_spawned.connect(on_chest_spawned)

func on_chest_spawned(chest: TreasureChest) -> void:
	chest.s_opened.connect(roll_for_deletion.bind(chest))

func roll_for_deletion(chest: TreasureChest) -> void:
	if chest.scripted_progression: return
	if RandomService.randi_channel('true_random') % 2 == 0:
		destroy_chest(chest)

func destroy_chest(chest: TreasureChest) -> void:
	var timer := Timer.new()
	timer.wait_time = 0.9
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	var world_item : WorldItem = chest.get_node('Item').get_child(0)
	cleanup_world_item(world_item)
	chest.vanish()
	timer.queue_free()

func cleanup_world_item(world_item : WorldItem) -> void:
	ItemService.item_removed(world_item.item)
