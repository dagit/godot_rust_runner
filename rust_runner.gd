@tool
extends EditorPlugin

var run_main_scene_button: Button
var run_current_scene_button: Button

func _enter_tree():
	run_main_scene_button = Button.new()
	run_main_scene_button.text = "▶️ Run Main"
	run_main_scene_button.tooltip_text = "Build Rust GDExtension and run game"
	run_main_scene_button.pressed.connect(_on_run_main_scene_pressed)
	
	run_current_scene_button = Button.new()
	run_current_scene_button.text = "▶️ Run Scene"
	run_current_scene_button.tooltip_text = "Build Rust GDExtension and run scene"
	run_current_scene_button.pressed.connect(_on_run_current_scene_pressed)
	
	add_control_to_container(CONTAINER_TOOLBAR, run_main_scene_button)
	add_control_to_container(CONTAINER_TOOLBAR, run_current_scene_button)

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, run_main_scene_button)
	remove_control_from_container(CONTAINER_TOOLBAR, run_current_scene_button)
	run_main_scene_button.queue_free()
	run_current_scene_button.queue_free()

func _rebuild() -> bool:
	var output = []
	var result = OS.execute("cargo", ["build", "--manifest-path", "../rust/Cargo.toml"], output, true)
	if result == OK:
		print("Rust build succeeded.")
		return true
	else:
		print("Rust build failed.")
		for out in output:
			push_error(out)
		return false

func _on_run_main_scene_pressed():
	if _rebuild():
		get_editor_interface().play_main_scene()

func _on_run_current_scene_pressed():
	if _rebuild():
		get_editor_interface().play_current_scene()
