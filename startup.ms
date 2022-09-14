main = {}

main.console = new TextDisplay

main.init = function()
    for i in range(0,7)
        if displayMode.str(display(i).mode) != "off" then display(i).mode = displayMode.off
    end for
    self.console.install 0
end function

main.noteDisp2 = function()
    self.console.delimiter = char(13)
    self.console.print "Enter your note here."
    self.console.print "Or press 'end' to save and return."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.noteDisp1 = function()
    self.console.delimiter = char(13)
    self.console.print "Enter note name here."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.newName = []
main.dump = []

main.mkFile = function()
    self.dump = self.dump.remove(char(5))
    note = file.open(self.newName + ".txt", "w")
    note.write self.dump
    note.close
end function

main.noteData = function()
    self.noteDisp2
    text = self.console

    while true
        if key.pressed("end") then
            self.dump = self.dump.join("")
            self.mkFile
            return
        end if
        
        pressed = key.get
        if pressed.code == 8 and self.dump.len == 0 then continue
    
        self.console.print pressed
    
        if pressed.code == 8 then
            self.dump.pop
            self.console.setCell(self.console.column, self.console.row, char(8))
            continue
        end if
        
        self.dump.push pressed
        yield
    end while
end function

main.newNote = function()    
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

main.Disp = function()
    self.console.delimiter = char(13)
    self.console.print "Type 'new note' to begin."
    self.console.print "Or 'exit' to quit."
    self.console.delimiter = ""
    self.console.print ">:"
end function

main.commands = []

main.getKeys = function(pressed)
    if pressed.code == 8 and self.commands.len == 0 then return
    
    self.console.print pressed
    
    if pressed.code == 8 then
        self.commands.pop
        self.console.setCell(self.console.column, self.console.row, char(8))
        return
    end if

    if pressed.code == 10 then
        self.commands = self.commands.join("")
        if self.commands == "exit" then
            exit
        else if self.commands == "new note" then
           self.newNote
        end if
        self.Disp
        self.commands = []
        return
    end if

    self.commands.push pressed
end function

main.start = function()
    self.init
    self.Disp

    while true
        self.getKeys(key.get)
        yield
    end while
end function

main.start