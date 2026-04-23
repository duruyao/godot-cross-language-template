extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var foo = Foo.new()
	var bar = Bar.new()
	foo.print_type(foo)
	bar.print_type(bar)
