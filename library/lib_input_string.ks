// lib_input_string.ks provides a method of inputting custom strings while a script is running via an on-screen keyboard.
// Copyright © 2015,2019 KSLib team 
// Lic. MIT
@LAZYGLOBAL off.

function input_string
{
 parameter
  line,   // top edge of the keyboard
  x0, y0, // where to display the input on screen
  hidden, // set to true to display "*" instead of character
  help.   //true or false (the info above the keyboard).

////////////////// internal functions ////////////////////////////////

 function refresh_board // this is done as 1 large print as drawing the boxes individually lags.
 {
  if shift = 0 {
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line).
   print "| ` | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | - | = |" at (0,line+1).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+2).
   print "| q | w | e | r | t | y | u | i | o | p | [ | ] |Ent|" at (0,line+3).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+4).
   print "| a | s | d | f | g | h | j | k | l | ; | ' | # |Cap|" at (0,line+5).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+6).
   print "| \ | z | x | c | v | b | n | m | , | . | / |   |" at (0,line+7).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+8).
  } else if shift = 1 {
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line).
   print "|N/A| ! | "+quote+" |N/A| $ | % | ^ | & | * | ( | ) | _ | + |" at (0,line+1).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+2).
   print "| Q | W | E | R | T | Y | U | I | O | P | { | } |Ent|" at (0,line+3).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+4).
   print "| A | S | D | F | G | H | J | K | L | : | @ | ~ |Cap|" at (0,line+5).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+6).
   print "| | | Z | X | C | V | B | N | M | < | > | ? |   |" at (0,line+7).
   print "+---+---+---+---+---+---+---+---+---+---+---+---+" at (0,line+8).
  }
  refresh_position("N/A",0).
 }

 function refresh_position
 {
  parameter dir, increment.
  if dir = "row" {
   set row to mod(row+increment+keyboard[shift]:length, keyboard[shift]:length).
   set col to mod(col+keyboard[shift][row]:length, keyboard[shift][row]:length).
  } else if dir = "col" {
   set col to mod(col+increment+keyboard[shift][row]:length, keyboard[shift][row]:length).
  }
  print "+---+" at (4*oldCol,2*oldRow+line).
  print "|" at (4*oldCol,2*oldRow+line+1).
  print "|" at (4*(oldCol+1),2*oldRow+line+1).
  print "+---+" at (4*oldCol,2*oldRow+line+2).
  print "#===#" at (4*col,2*row+line).
  print "H" at (4*col,2*row+line+1).
  print "H" at (4*(col+1),2*row+line+1).
  print "#===#" at (4*col,2*row+line+2).
  set oldrow to row.
  set oldCol to col.
 }

 function string_add {
  if keyboard[shift][row][col] = "Cap" {
   set shift to mod(shift+1,2).
   refresh_board().
  } else if keyboard[shift][row][col] = "Ent" {
   set Enter to True.
  } else {
   string:add(keyboard[shift][row][col]).
   if hidden {
    print "*" at (x0+string:length+2,y0).
   } else {
    print keyboard[shift][row][col] at (x0+string:length+2,y0).
   }
  }
 }
 function string_remove {
  if not string:empty {
   string:remove(string:length-1).
   print " " at (x0+string:length+3,y0).
  }
 }


/////////////function body/////////////////////////////////////

 local col is 0.
 local row is 0.
 local oldCol is 0.
 local oldRow is 0.
 local shift is 0.
 local controlMap is ship:control.
 local oldTop is controlMap:pilottop.
 local oldStar is controlMap:pilotstarboard.
 local oldFore is controlMap:pilotfore.
 local Enter is False.
 local string is list().
 local returnString is "".
 local char is 0.
 local oldT is 0.
 local blink is false.
 local quote is char(34).

 local keyboard is list(
  list( //lower case.
   list("`","1","2","3","4","5","6","7","8","9","0","-","="),
   list("q","w","e","r","t","y","u","i","o","p","[","]","Ent"),
   list("a","s","d","f","g","h","j","k","l",";","'","#","Cap"),
   list("\","z","x","c","v","b","n","m",",",".","/"," ")
  ),
  list( //upper case.
   list("¬","!",quote,"£","$","%","^","&","*","(",")","_","+"),
   list("Q","W","E","R","T","Y","U","I","O","P","{","}","Ent"),
   list("A","S","D","F","G","H","J","K","L",":","@","~","Cap"),
   list("|","Z","X","C","V","B","N","M","<",">","?"," ")
  )
 ).

 local oldHeight is terminal:height.
 local oldWidth is terminal:width.
 if oldwidth < 53 {
  set terminal:width to 53.
 }
 if oldHeight < line+9 {
  set terminal:height to line+9.
 }
 refresh_board().
 if help {
  Print "Navigate using the IJKL keys. Use the H and N" at (3,line-3).
  Print "keys to add and remove characters respectively." at (3,line-2).
 }.

 until Enter
 {
  if oldt + 0.3 < time {
   if blink {
    print " " at (x0+string:length+3,y0).
    toggle blink.
   } else {
    print "_" at (x0+string:length+3,y0).
    toggle blink.
   }
   set oldT to time.
  }.
  if (controlMap:PILOTTOP <>  oldTop) or (controlMap:PILOTSTARBOARD <> oldStar) or (controlMap:PILOTFORE <> oldFore)
  {
   if help {
    print "                                             " at (3,line-3).
    print "                                               " at (3,line-2).
    set help to false.
   }
   if controlMap:pilottop > 0
   {
    refresh_position("row",+1).
   } else if controlMap:pilottop < 0 {
    refresh_position("row", -1).
   }
   if controlMap:pilotstarboard > 0 {
    refresh_position("col", +1).
   } else if controlMap:pilotstarboard < 0 {
    refresh_position("col", -1).
   }
   if controlMap:pilotfore > 0 {
    string_add().
   } else if controlMap:pilotfore < 0 {
    string_remove().
   }
   SET oldTop TO controlMap:PILOTTOP.
   SET oldStar TO controlMap:PILOTSTARBOARD.
   SET oldFore TO controlMap:PILOTFORE.
  }
 }
 print " " at (x0+string:length+3,y0).
 set terminal:width to oldWidth.
 set terminal:height to oldHeight.
 for char IN string {
  set returnString to returnString + char.
 }
 return returnString.
}
