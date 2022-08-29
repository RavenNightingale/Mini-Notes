Notes = []

howTo3 = function()
	console.row = 0; console.print "Type your note here: "
end function

newNote = function()
	console.delimiter = char(13)
	console.print ""
	console.delimiter = ""
	
	howTo3

	while true
		pressed = key.get

		if pressed.code == 10 then break
		
		console.row = 0; console.print pressed
		Notes.push pressed
	end while

	Notes = Notes.join("")
	return Notes
end function

Nname = []

howTo2 = function()
	console.row = 0	; console.print "Enter a file name: "
end function

NewFile = function()

	howTo2

	while true
		pressed = key.get

		if pressed.code == 10 then break
		
		console.row = 0; console.print pressed
		Nname.push pressed	
	end while

	Nname = Nname.join("")

	Fname = file.open(Nname + ".txt", "w")
	Fname.write newNote
	Fname.close

	globals.Notes = []
	globals.Nname = []
end function

commands = []

for i in range(0,7)
    if displayMode.str(display(i).mode) != "off" then display(i).mode = displayMode.off
end for

console = new TextDisplay
console.install 0
text = console

getKeys = function(pressed)
	console.delimiter = ""
	
	console.row = 0; console.print pressed

	if pressed.code == 10 then
		commands = commands.join("")

		if commands == "exit" then
			exit
		else if commands == "new file" then
			NewFile
		end if

		globals.commands = []
		return
	end if

	commands.push pressed
end function

howTo = function()
	console.row = 10; console.print "Type ''exit'' to close"
	console.row = 9; console.print "Or ''new file'' to write notes!"
end function

howTo

while true
	getKeys(key.get)
	yield
end while