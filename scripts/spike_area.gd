extends Area2D

@onready var collision = $collision as CollisionShape2D
@onready var texture = $texture as Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = texture.get_rect().size

func _on_body_entered(body):
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(randi_range(-100,100), -250))
