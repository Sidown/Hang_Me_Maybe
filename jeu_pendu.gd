extends Control

var secret_word : String = ""
var showed_word = []
var error_number : int = 0
var word_list = ["UN", "DEUX"]
var found = false
var game_over : bool = false
var tryed_letter = []

func _ready():
	secret_word = word_list.pick_random()
	var word_length = secret_word.length()
	for i in word_length:
		showed_word.append("_")
	$VBoxContainer/LabelMot.text = "".join(showed_word)

func _on_bouton_deviner_pressed() -> void:
	if game_over:
		return

	var letter = $VBoxContainer/EntreeLettre.text.to_upper()
	$VBoxContainer/EntreeLettre.text = ""
	if letter in tryed_letter:
		return
			
	found = false
	for i in len(secret_word):
		if secret_word[i] == letter:
			showed_word[i] = letter
			found = true
	
	tryed_letter.append(letter)
	if found == false:
		error_number += 1
	
	$VBoxContainer/LabelMot.text = "".join(showed_word)			

	if error_number == 9:
		$VBoxContainer/LabelMot.text = "PERDU ! Le mot etait: %s" % secret_word
		game_over = true
	
	if not "_" in showed_word:
		$VBoxContainer/LabelMot.text = "Bien joue tu as trouve le mot !"
		game_over = true
	
	$VBoxContainer/LabelLettresTentees.text = "Essais: " + ", ".join(tryed_letter)
