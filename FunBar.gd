extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 1
	value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	max_value = Global.PeopleInTardis
	value = Global.PeopleHappy
