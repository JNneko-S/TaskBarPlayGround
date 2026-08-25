extends Node

@export_dir var items_folder : Array[String]
@export_dir var room_folder : Array[String]
@export_dir var gain_folder : Array[String]
@export_dir var loss_folder : Array[String]
@export_dir var modifier_folder : Array[String]

#Global変数なのでこれはよそで使ってもよい
#使用例:Sword.resource = weapon_cache["DebugSword"]
var weapon_cache : Dictionary[String, Resource] = {}
var modifier_cache : Dictionary[String, Resource] = {}

#room_cacheのintはバイナリ(0101のやつ)、第二はRoomResのArrayとして用意している
var room_cache : Dictionary[int, Array] = {}
var gain_cache : Dictionary[String, ObeliskResource] = {}
var loss_cache : Dictionary[String, ObeliskResource] = {}

func _ready() -> void:
	for folder in items_folder:
		_file_load(folder, weapon_cache)
	for folder in room_folder:
		_file_room_load(folder, room_cache)
	for folder in gain_folder:
		_file_load(folder, gain_cache)
	for folder in loss_folder:
		_file_load(folder, loss_cache)
	for folder in modifier_folder:
		_file_load(folder, modifier_cache)

#下の関数はprivateでここのAutoload専用の関数なのでよそで使わないこと
func _file_load(folder_path : String, res_cache : Dictionary) -> void:
	var folder : DirAccess = DirAccess.open(folder_path)
	
	folder.list_dir_begin()
	
	var file_name : String = folder.get_next()
	
	if folder_path != null:
		while file_name != "":
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_prefix(".remap")
				
			var resource : Resource = load(folder_path + "/" + file_name)
			
			
			var result = file_name.split(".")[0]
			
			res_cache[result] = resource
			
			file_name = folder.get_next()

#room専用のファイル読み込み関数
func _file_room_load(folder_path : String, res_cache : Dictionary) -> void:
	var folder : DirAccess = DirAccess.open(folder_path)
	
	folder.list_dir_begin()
	
	var file_name : String = folder.get_next()
	
	if folder_path != null:
		while file_name != "":
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_prefix(".remap")
				
			var resource : Resource = load(folder_path + "/" + file_name)
			if resource is not RoomInfoResource:
				continue
			
			var mask : int = 0
			
			var room_info_res : RoomInfoResource = resource as RoomInfoResource
			if room_info_res.up:
				mask |= Common.UP_MASK
			if room_info_res.down:
				mask |= Common.DOWN_MASK
			if room_info_res.left:
				mask |= Common.LEFT_MASK
			if room_info_res.right:
				mask |= Common.RIGHT_MASK
			
			if not res_cache.has(mask):
				res_cache[mask] = []
			
			(res_cache[mask] as Array).append(resource)
			
			file_name = folder.get_next()
