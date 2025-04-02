extends Node


const FIFTY_FIFTY_DIR := "itsevan-fiftyfifty"
const FIFTY_FIFTY_LOG := "itsevan-fiftyfifty:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(FIFTY_FIFTY_DIR)

func _ready() -> void:
	ModLoaderLog.info("Ready!", FIFTY_FIFTY_LOG)
	var chest_finder : Node = load(ModLoaderMod.get_unpacked_dir().path_join(FIFTY_FIFTY_DIR).path_join("chest_tracker.gd")).new()
	ModLoaderLog.info("Adding ChestFinder", FIFTY_FIFTY_LOG)
	add_child(chest_finder)
	ModLoaderLog.info("ChestFinder added successfully", FIFTY_FIFTY_LOG)
	
