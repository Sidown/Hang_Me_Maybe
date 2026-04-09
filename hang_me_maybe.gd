# pull un mot aleatoire dans une liste DONE
# afficher ce mot en "_"
# prendre des inputs DONE
# verifier si inputs correcte
# verifier si inputs valide DONE
# verifier si inputs deja donne DONE
# remplacer "_" par input si correcte

extends Node2D

var word_pool: Array[String] = ["HELLO", "BONJOUR"]
var wrong_move: int = 0
var letter: String
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVXWYZ"
var choosen_word: String
var showed_word: Array[String] = []
var loose: bool = false
@onready var error: Label = $Error
var score: int = 0

func load_from_file():
	var file = FileAccess.open("res://assets/word.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.text = "Score: %s" % [str(score)]
	var words_list = load_from_file()
	$ErrorAnim.hide()
	choosen_word = choose_word(Array(words_list.split("\n"))).to_upper()
	print(choosen_word)
	for i in choosen_word:
		showed_word.append("_")
	$Guess.text = " ".join(showed_word)

	
func update_showed_word(input: String) -> void:
	for i in len(choosen_word):
		if input == choosen_word[i]:
			showed_word[i] = input
			$Guess.text = " ".join(showed_word)

func choose_word(words_list) -> String:
	return words_list.pick_random()

func show_hangman() -> void:
	$ErrorAnim.show()
	$ErrorAnim/AnimatedSprite2D.play("Error%s" % [str(wrong_move)])
	$ErrorAnim/AnimatedSprite2D.stop()

func reset_all() -> void:
	wrong_move = 0
	loose = false
	showed_word = []
	
func is_word_found() -> bool:
	if not "_" in showed_word:
		return true
	return false

func _input(event: InputEvent) -> void:
	if is_word_found():
		error.text = "Bien joué, tu as trouvé!"
		score += 1
		reset_all()
		_ready()
	elif loose:
		score = 0
		error.text = "Perdu!"
		reset_all()
		_ready()
	elif event is InputEventKey and event.is_pressed():
		letter = event.as_text()
		if letter in alphabet:
			error.text = ''
			if letter in choosen_word:
				update_showed_word(letter)
				print(showed_word)
			else:
				error.text = "Mauvaise lettre!"
				wrong_move += 1
				show_hangman()
				if wrong_move == 7:
					loose = true
				
		else: error.text = "Ce n'est pas une lettre..."
	
