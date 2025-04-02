extends Node

## Rolls to randomly destroy non-progression chests when interacted


const FIFTY_FIFTY_DIR := "itsevan-fiftyfifty"
const FIFTY_FIFTY_LOG := "itsevan-fiftyfifty:Main"

var marked_for_deletion : Array[TreasureChest] = []


func _ready() -> void:
	get_tree().node_added.connect(on_node_added)
	Globals.s_title_screen_entered.connect(clear_queue)
	Util.s_floor_started.connect(clear_queue)

func on_node_added(node : Node) -> void:
	if node is TreasureChest:
		chest_spawned(node)

func chest_spawned(chest : TreasureChest) -> void:
	if not chest.scripted_progression and RandomService.randi_channel('chest_rolls') % 2 == 0:
		mark_for_deletion(chest)
		ModLoaderLog.info("Marked chest for deletion.", FIFTY_FIFTY_LOG)

func destroy_chest(chest : TreasureChest) -> void:
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

func clear_queue(_node = false) -> void:
	for chest : TreasureChest in marked_for_deletion.duplicate():
		remove_from_queue(chest)

func remove_from_queue(chest : TreasureChest) -> void:
	if chest.s_opened.is_connected(destroy_chest):
		chest.s_opened.disconnect(destroy_chest)
	marked_for_deletion.erase(chest)

func mark_for_deletion(chest : TreasureChest) -> void:
	chest.s_opened.connect(destroy_chest.bind(chest))
	marked_for_deletion.append(chest)
