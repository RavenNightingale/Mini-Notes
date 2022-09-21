main = {}

main.console = new TextDisplay

main.init = function() //main initializer
    for i in range(0,7)
        if displayMode.str(display(i).mode) != "off" then display(i).mode = displayMode.off
    end for
    self.console.install 0
end function

main.delNote = function()
    if not file.exists("/usr/Notes") then
        self.console.print "No notes found!"
        self.console.print ""
        return
    end if
    
    options = []
    
    notes = file.children("/usr/Notes/")

    if notes.len == 0 then
        self.console.print "No notes found!"
        self.console.print ""
        return
    end if

    for note in notes
        self.console.print (notes.indexOf(note) + 1)  + ". " + note
        self.console.print ""
    end for

    self.console.delimiter = ""
    self.console.print ">:"
    
    oldcolumn = self.console.column

    while true
        pressed = key.get

        if pressed.code == 8 and options.len == 0 then continue

        self.console.print pressed

        if pressed.code == 8 then
            options.pop
            self.console.setCell(self.console.column, self.console.row, char(32))
            continue
        end if

        if pressed.code == 10 then
            failed = false

            options = options.join("")
            
            for character in options
                if str(character.val) != character then
                    failed = true
                    continue
                end if
            end for

            if failed then
                self.console.delimiter = char(13)
                self.console.print("Invalid Entry")
                self.console.print ""
                self.console.delimiter = ""
                self.console.print ">:"

                options = []
                continue
            end if
            
            options = options.val

            file.delete "/usr/Notes/" + notes[options -1]
            break
        end if
        
        options.push pressed
        yield
    end while
end function

main.listNotes = function()
    if not file.exists("/usr/Notes") then
        self.console.print "No notes found!"
        self.console.print ""
        return
    end if

    notes = file.children("/usr/notes/")

    if notes.len == 0 then
        self.console.print "No notes found!"
        self.console.print ""
    end if

    for note in notes
        self.console.print note
        self.console.print ""
    end for
end function

main.noteDisp2 = function()
    self.console.delimiter = char(13)
    self.console.print ""
    self.console.print "Enter your note here."
    self.console.print "Or press 'end' to save and return."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.noteDisp1 = function()
    self.console.print "Enter note name here."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.newName = []
main.dump = []

main.mkFile = function() //creates new file
    if not file.exists("/usr/Notes") then
        file.makedir("/usr/Notes")
    end if
    
    self.console.print ""
    self.console.delimiter = char(13)
    self.console.print ""
    self.console.print ""
    self.console.print "New file saved!"
    self.console.print ""
    self.dump = self.dump.remove(char(5))
    note = file.open("/usr/Notes/" + self.newName + ".txt", "w")
    note.write self.dump
    note.close
    self.newName = []
    self.dump = []
end function

main.noteData = function() //writes data to file data list
    self.noteDisp2
    text = self.console

    while true
        pressed = key.get

        if pressed.code == 8 and self.dump.len == 0 then continue
    
        self.console.print pressed

        if pressed.code == 5 then
            self.dump = self.dump.join("")
            self.mkFile
            return
        end if
    
        if pressed.code == 8 then
            self.dump.pop
            self.console.setCell(self.console.column, self.console.row, char(8))
            continue
        end if

        self.dump.push pressed
        yield
    end while
end function

main.newNote = function() //writes name to file list
    self.noteDisp1

    while true
        pressed = key.get

        if pressed.code == 8 and self.newName.len == 0 then continue
    
        self.console.print pressed
    
        if pressed.code == 8 and pressed then
            self.newName.pop
            self.console.setCell(self.console.column, self.console.row, char(8))
            continue
        end if

        if pressed.code == 10 then
            self.newName = self.newName.join("")
            self.noteData
            return
        end if
        
        self.newName.push pressed
        yield
    end while
end function

main.help = function()
    self.console.print "Hello and welcome to Mini Notes!"
    self.console.print ""
    self.console.print "exit - exits program."
    self.console.print "new note - creates a note."
    self.console.print "delete - to remove unwanted notes."
    self.console.print "notes - lists your notes."
    self.console.print ""
end function

main.Disp = function()
    self.console.delimiter = char(13)
    self.console.print "Type 'help' for more"
    self.console.print "or 'exit' to quit."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.commands = []

main.getKeys = function(pressed) //grabs user keys
    if pressed.code == 8 and self.commands.len == 0 then return

    self.console.print pressed
    
    if pressed.code == 8 then
        self.commands.pop
        self.console.setCell(self.console.column, self.console.row, char(8))
        return
    end if

    if pressed.code == 10 then
        self.console.delimiter = char(13)
        self.console.print ""
        self.commands = self.commands.join("")
        if self.commands == "exit" then
            exit
        else if self.commands == "clear" then
            self.console.clear
        else if self.commands == "help" then
            self.help
        else if self.commands == "new note" then
           self.newNote
        else if self.commands == "notes" then
            self.listNotes
        else if self.commands == "delete" then
           self.delNote
        end if
        self.Disp
        self.commands = []
        return
    end if

    self.commands.push pressed
end function

main.start = function() //program starter
    self.init
    self.Disp

    while true
        self.getKeys(key.get)
        yield
    end while
end function
main.start