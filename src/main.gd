extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var foo = Foo.new()
	var bar = Bar.new()
	foo.say_hello(bar.get_class())
	bar.say_hello(foo.get_class())
