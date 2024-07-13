extends Area2D


func _on_body_entered(body):
	body.queue_free()
	var parent = get_parent()
	if parent.has_method("wasShotCallback"):
		parent.wasShotCallback()
