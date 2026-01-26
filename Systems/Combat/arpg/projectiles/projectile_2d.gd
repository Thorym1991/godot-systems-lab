extends Area2D
class_name Projectile2D

@export var speed: float = 180.0
@export var lifetime: float = 2.0

var dir: Vector2 = Vector2.RIGHT
var damage: int = 1
var knockback: float = 0.0

# WICHTIG: WeakRef statt direkter Node-Referenz
var _source_ref: WeakRef = null

const L_PLAYER := 1
const L_PLAYER_INTERACTION := 2
const L_WORLD := 4
const L_ENEMY_HITBOX := 7
const L_PLAYER_HITBOX := 8
const L_PROJ_PLAYER := 12
const L_PROJ_ENEMY := 13

func setup(_dir: Vector2, _damage: int, _source: Node, _knockback: float) -> void:
	dir = _dir.normalized()
	damage = _damage
	knockback = _knockback
	_source_ref = weakref(_source)
	rotation = dir.angle()

	var source_is_enemy := _source != null and _source.is_in_group("enemy")

	if source_is_enemy:
		# Enemy projectile: World + PlayerHitbox + PlayerBody
		collision_layer = 1 << (L_PROJ_ENEMY - 1)
		collision_mask  = (1 << (L_WORLD - 1)) | (1 << (L_PLAYER_HITBOX - 1)) | (1 << (L_PLAYER - 1))
	else:
		# Player projectile: World + EnemyHitbox
		collision_layer = 1 << (L_PROJ_PLAYER - 1)
		collision_mask  = (1 << (L_WORLD - 1)) | (1 << (L_ENEMY_HITBOX - 1))



	rotation = dir.angle()

func _ready() -> void:
	monitoring = true
	monitorable = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()



func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta


func _on_body_entered(body: Node) -> void:
	_apply_damage(body)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Ignoriere Sensoren/Trigger (Layer 2,3,5,10 etc.)
	# -> wir verlassen uns auf Layer-Mask, aber als Safety:
	if area.collision_layer & (1 << (L_PLAYER_INTERACTION - 1)) != 0:
		return

	_apply_damage(area)
	queue_free()


func _apply_damage(target: Node) -> void:
	if _is_owner_or_related(target):
		return
	var src: Node = null
	if _source_ref != null:
		src = _source_ref.get_ref() as Node
	if src == null:
		src = self

	# Player direkt (wenn body_entered)
	if target is TopdownPlayer2D:
		var p := target as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(damage, src)
		return

	# Enemy über Hurtbox/HitReceiver
	# Variante A: Hurtbox-Node hat owner = Enemy
	if target is Area2D:
		var a := target as Area2D
		var e := a.owner
		if e and e.has_method("apply_hit"):
			var hit := HitData.new()
			hit.damage = damage
			hit.source = src
			hit.dir = dir
			hit.knockback = knockback
			e.apply_hit(hit)
			return

	# Variante B: direkt Enemy getroffen
	if target.has_method("apply_hit"):
		var hit2 := HitData.new()
		hit2.damage = damage
		hit2.source = src
		hit2.dir = dir
		hit2.knockback = knockback
		target.apply_hit(hit2)

func _is_owner_or_child(n: Node) -> bool:
	var src := _source_ref.get_ref() as Node if _source_ref != null else null
	if src == null:
		return false
	if n == src:
		return true
	return n.owner == src

func _is_owner_or_related(n: Node) -> bool:
	var src := _source_ref.get_ref() as Node if _source_ref != null else null
	if src == null:
		return false

	# direkt
	if n == src:
		return true

	# wenn wir eine Area/Shape vom Owner treffen (owner chain)
	if n.owner == src:
		return true

	# wenn wir ein Child vom Owner treffen (Parent chain)
	var p := n
	while p != null:
		if p == src:
			return true
		p = p.get_parent()

	return false

func reflect(new_source: Node, new_dir: Vector2) -> void:
	_source_ref = weakref(new_source)
	dir = new_dir.normalized()
	rotation = dir.angle()

	# wird zum Player-Projektil
	collision_layer = 1 << (12 - 1) # projectile_player
	collision_mask  = (1 << (4 - 1)) | (1 << (7 - 1)) # world + enemy_hitbox
