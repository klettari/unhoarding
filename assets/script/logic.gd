extends Node

var goldIndex
var bigGoldIndex

# player:

func getPlayer() :
	return $Player.get_used_cells()[0]

func movePlayer(newCoord) :
	var currentPlayer = getPlayer()
	$Player.set_cellv(currentPlayer, -1)

	$Player.set_cellv(newCoord, 0)

# floor:

func getFloorTile(coord) :
	return $Floor.get_cellv(coord)

func getGoldTile(coord) :
	return $Gold.get_cellv(coord)
	
func hasFloor(coord) :
	return getFloorTile(coord) != -1

# gold:

func hasGold(coord) :
	return getGoldTile(coord) != -1

func hasNormalGold(coord) :
	return $Gold.get_cellv(coord) == goldIndex

func hasBigGold(coord) :
	return $Gold.get_cellv(coord) == bigGoldIndex

func removeGold(coord) :
	$Gold.set_cellv(coord, -1)

func setNormalGold(coord) :
	$Gold.set_cellv(coord, goldIndex)

func setBigGold(coord) :
	$Gold.set_cellv(coord, bigGoldIndex)

# win:

func getEndMarker() :
	return $EndMarker.get_used_cells()[0]

func isWin() :
	return getPlayer() == getEndMarker()

# func:

func _ready() :
	goldIndex = $Gold.tile_set.find_tile_by_name("gold")
	bigGoldIndex = $Gold.tile_set.find_tile_by_name("gold-big")

func _input(event) :
	print(  Global.levelsMap[Global.level] )

	if Input.is_key_pressed(KEY_R) :
		get_tree().reload_current_scene()

	var playerPosition = getPlayer()
	var nextCell = playerPosition
	var cellOnePast = playerPosition

	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W) :
		nextCell.x -= 1
		cellOnePast.x -= 2
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S) :
		nextCell.x += 1
		cellOnePast.x += 2
	elif Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A) :
		nextCell.y += 1
		cellOnePast.y += 2
	elif Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D) :
		nextCell.y -= 1
		cellOnePast.y -= 2

	if !hasFloor(nextCell) :
		print("can't move - no floor")
		return
	
	if hasBigGold(nextCell) :
		print("can't move - big gold ahead")
		return
	
	if hasNormalGold(nextCell) :
		if !hasFloor(cellOnePast) :
			print("no floor to move the gold")
			return
	
		if hasBigGold(cellOnePast) :
			print("can't move gold onto big gold")
			return
		
		if hasNormalGold(cellOnePast) :
			print("merging 2 gold piles")
			removeGold(nextCell)
			setBigGold(cellOnePast)
		
		if !hasGold(cellOnePast) :
			print("moving gold ahead")
			removeGold(nextCell)
			setNormalGold(cellOnePast)

	movePlayer(nextCell)
	
	if isWin() :
		var nextLevel = Global.level
		nextLevel += 1

		if Global.levelsMap.has(nextLevel) :
			var pathToLevel = Global.levelsMap[nextLevel]
			get_tree().change_scene(pathToLevel)

			Global.level = nextLevel
