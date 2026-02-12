extends Node
class_name FeedbackManager

# Minimal: Projekt-Version/Build in ProjectSettings setzen:
# application/config/version = "0.1.0"
var game_version: String:
	get:
		return str(ProjectSettings.get_setting("application/config/version", "dev"))

var session_id: String = ""
var session_started_unix: int = 0

# Optional: simple Session-Metriken (kannst du später erweitern)
var deaths: int = 0
var boss_completed: bool = false
var last_checkpoint: String = ""

func _ready() -> void:
	_start_new_session()

func _start_new_session() -> void:
	session_id = _make_id()
	session_started_unix = Time.get_unix_time_from_system()

func mark_death() -> void:
	deaths += 1

func mark_boss_completed() -> void:
	boss_completed = true

func set_checkpoint(id: String) -> void:
	last_checkpoint = id

func submit_feedback(payload: Dictionary) -> String:
	# payload enthält nur die Antworten aus dem UI
	# Wir reichern an: version, session, basic metrics
	var data := {
		"version": game_version,
		"session_id": session_id,
		"session_started_unix": session_started_unix,
		"submitted_unix": Time.get_unix_time_from_system(),
		"metrics": {
			"deaths": deaths,
			"boss_completed": boss_completed,
			"last_checkpoint": last_checkpoint,
		},
		"feedback": payload
	}

	var json := JSON.stringify(data, "\t")

	var dir := DirAccess.open("user://")
	if dir and not dir.dir_exists("feedback"):
		dir.make_dir("feedback")

	var filename := "user://feedback/feedback_%s.json" % _timestamp_id()
	var f := FileAccess.open(filename, FileAccess.WRITE)
	if f == null:
		push_warning("Feedback: could not write file: " + filename)
		return ""

	f.store_string(json)
	f.flush()
	f.close()

	return filename

func build_share_text(payload: Dictionary) -> String:
	# Text, den Testende dir z.B. per Discord schicken können
	var lines: Array[String] = []
	lines.append("=== FEEDBACK ===")
	lines.append("Version: %s" % game_version)
	lines.append("Session: %s" % session_id)
	lines.append("Deaths: %d" % deaths)
	lines.append("BossCompleted: %s" % str(boss_completed))
	lines.append("Checkpoint: %s" % last_checkpoint)
	lines.append("")
	for k in payload.keys():
		lines.append("%s: %s" % [str(k), str(payload[k])])
	return "\n".join(lines)

func _timestamp_id() -> String:
	var dt := Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d_%02d-%02d-%02d_%s" % [
		dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, session_id
	]

func _make_id() -> String:
	# kurze ID (kein Crypto, reicht für Tests)
	var a := int(Time.get_unix_time_from_system()) % 100000
	var b := randi() % 100000
	return "%05d%05d" % [a, b]
