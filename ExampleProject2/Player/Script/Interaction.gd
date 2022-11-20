extends RayCast

var interactive_object_exist = has_method("res://ObjectScript/Interactable.gd")
var current_collider
var wardrobe_left_draw_area

#onready var interaction_label: Label = get_node("/root/MainLevel/WorldMainUI/InteractionLabel")
onready var interaction_label: Label = get_node("../../../WorldMainUI/InteractionLabel")
onready var interaction_label_anim: AnimationPlayer = get_node("../../../InteractionLabelAnim")

func _ready():
	set_interaction_text("")
	

func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider
		
		if Input.is_action_just_pressed("InteractionButton"):
			collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif current_collider:
		current_collider = null
		set_interaction_text("")
		
	
func set_interaction_text(text):
	if !text:
		interaction_label_anim.play_backwards("InteractionLabelPopup")
	else:
		var interact_key = OS.get_scancode_string(InputMap.get_action_list("InteractionButton")[0].scancode)
		interaction_label.set_text("Press %s to %s" % [interact_key, text])
		interaction_label_anim.play("InteractionLabelPopup")
	





