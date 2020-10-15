# Game Of Ur

The Game of Ur was a game played in ancient Mesopotamia.
As there are no surviving direct descriptions of the rules this is a guess as to one rule set for the game.

## To Use

As there are no dependencies for this script you can simply copy it into your archive and run it.

## Rules

This is a two player game, one player is 'X' the other is 'O'.
There are several AI options should you wish to play by your self.
To play you roll dice to determine how far you move in a turn.
The way to Win is to get all 7 of your pieces off the board.
A player can send an opponent's piece back to the start by landing on it with their own piece.
There are 5 areas on the board and players may only interact directly in the Main area.
 
At the start of your turn you roll four sided dice.
Each die has 2 white and 2 black dots with one dot on each face.
The number of white dots are added together to get the number of spaces you will move.
As you can get zero white dots on your roll it is possible to end up skipping your turn.
There are 5 tiles that when landed on allow the player to roll again.
The probability spread for all possible rolls are:  0 = 1/16, 1 = 2/8 2 = 3/8, 3 = 2/8, 4 = 1/16
 
To get a piece off the board you must roll the exact number.
For instance if you are on the last tile then you must roll a 1.
 
A player can only interact with their opponent's pieces in the main area of the board.
To send an opponent's piece back to the start a player must simply land on the piece they wish to send back.
A player can't land on there own pieces.
The roll again tile in the main area is a save tile and a piece on the tile can't be sent back to the start.

The 5 areas on the board are xStart, oStart, Main, xEnd, oEnd.
The tiles are numbered from -4 to 9 along the path of movement.
Some tiles have duplicate numbers because each player has their own start and end areas.
There are 2 hidden tiles for starting and ending places.
The starting area is numbered -5.
The ending area is numbered 10.

Several examples of various rules as well as a copy of the rules can also be found in the help menu with in the game itself.

---
Copyright © 2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).