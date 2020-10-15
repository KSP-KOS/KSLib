// Game_of_Ur.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT
// Originally developed by nuggreat

SET TERMINAL:WIDTH TO 70.
SET TERMINAL:HEIGHT TO 35.

//init of the various needed variables
LOCAL boardPos IS LIST(5,5).
LOCAL spacePos IS LEX(
"X Start -5",LIST(0,0),"X Start -4",LIST(27,2),"X Start -3",LIST(33,2),"X Start -2",LIST(39,2),"X Start -1",LIST(45,2),
"O Start -5",LIST(0,0),"O Start -4",LIST(27,10),"O Start -3",LIST(33,10),"O Start -2",LIST(39,10),"O Start -1",LIST(45,10),
"main 0",LIST(45,6),"main 1",LIST(39,6),"main 2",LIST(33,6),"main 3",LIST(27,6),"main 4",LIST(21,6),"main 5",LIST(15,6),"main 6",LIST(9,6),"main 7",LIST(3,6),
"X End 8",LIST(3,2),"X End 9",LIST(9,2),"X End 10",LIST(0,0),
"O End 8",LIST(3,10),"O End 9",LIST(9,10),"O End 10",LIST(0,0)).
LOCAL validSpaces IS spacePos:KEYS.
LOCAL rollAgainSpots IS LIST("X Start -1","O Start -1","main 3","X End 9","O End 9").
LOCAL blankLine IS " ":PADRIGHT(70).

LOCAL rollSpread IS LIST(0.0625,0.25,0.375,0.25).

LOCAL gameBoardData IS LEX(
"X Start -5"," ","X Start -4","X","X Start -3","X","X Start -2","X","X Start -1","X",
"O Start -5"," ","O Start -4","O","O Start -3","O","O Start -2","O","O Start -1","O",
"main 0","X","main 1","O","main 2","X","main 3","O","main 4","X","main 5","O","main 6","X","main 7","O",
"X End 8","X","X End 9","X","X End 10"," ",
"O End 8","O","O End 9","O","O End 10"," ").
LOCAL gamePieceData IS LEX("xStart",0,"oStart",0,"xEnd",7,"oEnd",7).

LOCAL helpPieceData IS gamePieceData:COPY().
LOCAL helpBoardData IS LEX().
LOCAL helpKeyToNum IS LEX().
LOCAL count IS 0.
FOR key IN LIST("move","area","number","special","blank") {
  helpBoardData:ADD(key,gameBoardData:COPY()).
  helpKeyToNum:ADD(key,count).
  helpKeyToNum:ADD(count,key).
  SET count TO count + 1.
  clear_board(helpBoardData[key],helpPieceData).
}

FOR key IN helpBoardData["area"]:KEYS {
  IF key:CONTAINS("Start") {
    SET helpBoardData["area"][key] TO key[0] + "s".
  } ELSE IF key:CONTAINS("End") {
    SET helpBoardData["area"][key] TO key[0] + "e".
  } ELSE {
    SET helpBoardData["area"][key] TO "m".
  }
}

FOR key IN helpBoardData["number"]:KEYS {
  SET helpBoardData["number"][key] TO key:SUBSTRING(key:LENGTH - 2,2):TONUMBER():TOSTRING().
}

FOR key IN rollAgainSpots {
  SET helpBoardData["special"][key] TO "R".
}

FOR key IN helpBoardData["blank"]:KEYS {
  SET helpBoardData["blank"][key] TO "  ".
}

LOCAL gameData IS LEX("inProgres",FALSE, "curentTurn","X", "showOptions",TRUE,
"X",LEX("isHuman",TRUE,"AItype","tmap","AIstate",LIST(0,0)),
"O",LEX("isHuman",FALSE,"AItype","tmap","AIstate",LIST(0,0))).

LOCAL aiMoveMap IS LEX(
"hare",ai_hare_move@,
"tort",ai_tortoise_move@,
"tmap",ai_threat_map@,
"rand",ai_random@,
"mute",ai_mutating@,
"randAI",ai_random_ai@).
LOCAL otherPlayer IS LEX("X","O","O","X").

LOCAL aiTypeToNum IS LEX("hare",0,"tort",1,"tmap",2,"rand",3,"mute",4,"randAI",5).
FOR key IN aiTypeToNum:KEYS { aiTypeToNum:ADD(aiTypeToNum[key],key). }


LOCAL termIn IS TERMINAL:INPUT.
LOCAL validKeys IS LIST("o","q","h",termIn:UPCURSORONE,termIn:DOWNCURSORONE,termIn:ENTER).
LOCAL interruptKeys IS LIST("o","q","h").

//human interrupt for key presses
LOCAL interrupt IS "o".
LOCAL keyQueue IS QUEUE().
WHEN termIn:HASCHAR THEN {
  LOCAL newChar IS termIn:GETCHAR().
  IF validKeys:CONTAINS(newChar) {
    IF interruptKeys:CONTAINS(newChar) {
      SET interrupt TO newChar.
    } ELSE {
      IF keyQueue:LENGTH < 8 {
        keyQueue:PUSH(newChar).
      }
    }
  }
  PRESERVE.
}

LOCAL quitGame IS FALSE.
ui_help_intro(TRUE).
SET interrupt TO "o".
IF NOT quitGame {
  ui_interrupt_handler().
  SET gameData["inProgres"] TO TRUE.
  IF NOT quitGame {
    clear_board(gameBoardData,gamePieceData).
    draw_board(boardPos[0],boardPos[1]).
    draw_picses(boardPos[0],boardPos[1],gameBoardData,gamePieceData).
  }
}

UNTIL quitGame {//(gamePieceData["xEnd"] >= 7) OR (gamePieceData["oEnd"] >= 7) {
  IF (gamePieceData["xEnd"] >= 7) OR (gamePieceData["oEnd"] >= 7) {
    IF gamePieceData["xEnd"] >= 7 {
      ui_congratulation("X").
    } ELSE {
      ui_congratulation("O").
    }
    clear_board(gameBoardData,gamePieceData).
    SET gameData["inProgres"] TO FALSE.
    IF gameData["showOptions"] {
      SET interrupt TO "o".
      ui_interrupt_handler().
      IF quitGame { BREAK. }
      draw_board(boardPos[0],boardPos[1]).
    }
    draw_picses(boardPos[0],boardPos[1],gameBoardData,gamePieceData).
    set_player_move_first().
    SET gameData["X"]["AIstate"] TO LIST(0,0).
    SET gameData["O"]["AIstate"] TO LIST(0,0).
    SET gameData["inProgres"] TO TRUE.
  }
  IF ui_interrupt_handler() {
    IF quitGame { BREAK. }
    draw_board(boardPos[0],boardPos[1]).
    draw_picses(boardPos[0],boardPos[1],gameBoardData,gamePieceData).
  }
  LOCAL pType IS gameData["curentTurn"].
  LOCAL newRoll IS dice_roll().
  LOCAL moveList IS player_move_list(pType,newRoll,gameBoardData).
  LOCAL col IS boardPos[0].
  LOCAL row IS boardPos[1] + 15.
  LOCAL validMove IS moveList:LENGTH > 0.
  PRINT pType + " rolled: " + newRoll AT(col,row - 2).
  draw_move_list(col,row,moveList).
  LOCAL pData IS gameData[pType].
  LOCAL rollAgain IS FALSE.
  IF validMove {
    LOCAL selectedMove IS 0.
    IF pData["isHuman"] {
      PRINT "Press ENTER to Select [x]" AT(col,row+moveList:LENGTH).
      SET selectedMove TO ui_move(col,row,moveList,gameBoardData,gamePieceData).
      IF quitGame { BREAK. }
    } ELSE {
      SET selectedMove TO ai_move(pType,pData,moveList).
      PRINT "X" AT(col + 1,row+selectedMove).
      WAIT 1.
    }
    SET rollAgain TO move_piece(pType,moveList[selectedMove],gameBoardData,gamePieceData).
  } ELSE {
    PRINT "No Valid Move"AT(col,row).
    WAIT 1.
  }
  draw_picses(boardPos[0],boardPos[1],gameBoardData,gamePieceData).
  IF NOT rollAgain {
    SET gameData["curentTurn"] TO otherPlayer[gameData["curentTurn"]].
    PRINT "             " AT (col,row - 1).
  }
}

//UI

FUNCTION ui_interrupt_handler {
  PARAMETER ignore IS LIST().
  IF interrupt <> FALSE {
    IF ignore:CONTAINS(interrupt) {
      SET interrupt TO FALSE.
      RETURN FALSE.
    } ELSE {
      IF interrupt = "o" {
        ui_game_options().
      } ELSE IF interrupt = "q" {
        ui_quit().
      } ELSE IF interrupt = "h" {
        ui_help().
      }
      SET interrupt TO FALSE.
      RETURN TRUE.
    }
  } ELSE {
    RETURN FALSE.
  }
}

FUNCTION ui_game_options {
  LOCAL col IS 0.
  LOCAL row IS 0.
  LOCAL aiNumbers IS aiMoveMap:KEYS:LENGTH.
  LOCAL level0Offset IS LIST().
  level0Offset:ADD(row + 1).
  level0Offset:ADD(level0Offset[0] + 4 + aiNumbers).
  level0Offset:ADD(level0Offset[1] + 4 + aiNumbers).
  level0Offset:ADD(level0Offset[2] + 4).
  level0Offset:ADD(level0Offset[3] + 1).
  LOCAL l0Max IS 3.
  LOCAL l0i IS 3.
  LOCAL pType IS "X".
  LOCAL AItMax IS aiMoveMap:KEYS:LENGTH - 1.
  LOCAL level IS 0.
  IF gameData["inProgres"] {
    SET l0Max TO l0Max + 1.
  }
  draw_game_options(col,row).
  draw_current_settings(col,row,pType,level).
  draw_game_restart(col + 2,row + level0Offset[2] + 1,"-").
  PRINT "X" AT(1,row + level0Offset[l0i]).
  LOCAL done IS FALSE.
  UNTIL done {
    IF ui_interrupt_handler(LIST("o")) {
      IF quitGame { BREAK. }
      draw_game_options(col,row).
      draw_current_settings(col,row,pType,level).
      IF level > 0 {
        PRINT "-" AT(1,row + level0Offset[l0i]).
        IF l0i = 2 {
          draw_game_restart(col + 2,row + level0Offset[2] + 1,"X").
        } ELSE {
          draw_game_restart(col + 2,row + level0Offset[2] + 1,"-").
        }
      } ELSE {
        draw_game_restart(col + 2,row + level0Offset[2] + 1,"-").
        PRINT "X" AT(1,row + level0Offset[l0i]).
      }
    }
    IF is_enter_key() {
      IF level = 0 {
        IF l0i < 2 {
          PRINT "-" AT(1,row + level0Offset[l0i]).
          SET level TO level + 1.
          IF l0i = 0 {
            SET pType TO "X".
          } ELSE {
            SET pType TO "O".
          }
          draw_player_setttings(col,row + level0Offset[l0i],pType,level).
        } ELSE IF l0i = 2 {
          PRINT "-" AT(1,row + level0Offset[l0i]).
          draw_game_restart(col + 2,row + level0Offset[l0i] + 1,"X").
          SET level TO level + 1.
        } ELSE IF l0i = 3 {
          clear_board(gameBoardData,gamePieceData).
          SET gameData["X"]["AIstate"] TO LIST(0,0).
          SET gameData["O"]["AIstate"] TO LIST(0,0).
          SET done TO TRUE.
        } ELSE IF l0i = 4 {
          SET done TO TRUE.
        }
      } ELSE IF level = 1 {
        IF l0i < 2 {
          IF gameData[pType]["isHuman"] {
            SET level TO 0.
            PRINT "X" AT(1,row + level0Offset[l0i]).
          } ELSE {
            SET level TO level + 1.
            draw_player_setttings(col,row + level0Offset[l0i],pType,level).
          }
        } ELSE IF l0i = 2 {
          SET level TO 0.
          draw_game_restart(col + 2,row + level0Offset[l0i] + 1,"X").
          PRINT "X" AT(1,row + level0Offset[l0i]).
        }
      } ELSE {
        SET level TO 0.
        PRINT "X" AT(1,row + level0Offset[l0i]).
        draw_player_setttings(col,row + level0Offset[l0i],pType,level).
      }
    } ELSE {
      IF is_up_key() {
        IF level = 0 {
          PRINT " " AT(1,row + level0Offset[l0i]).
          SET l0i TO l0i - 1.
          IF l0i < 0 {
            SET l0i TO l0Max.
          }
          PRINT "X" AT(1,row + level0Offset[l0i]).
        } ELSE IF level = 1 {
          IF l0i < 2 {
            SET gameData[pType]["isHuman"] TO NOT gameData[pType]["isHuman"].
            draw_player_setttings(col,row + level0Offset[l0i],pType,level).
          } ELSE {
            SET gameData["showOptions"] TO NOT gameData["showOptions"].
            draw_game_restart(col + 2,row + level0Offset[l0i] + 1,"X").
          }
        } ELSE IF level = 2 {
          LOCAL AIti IS aiTypeToNum[gameData[pType]["aiType"]] - 1.
          IF AIti < 0 {
            SET AIti TO AItMax.
          }
          SET gameData[pType]["aiType"] TO aiTypeToNum[AIti].
          draw_player_setttings(col,row + level0Offset[l0i],pType,level).
        }
      } ELSE IF is_down_key() {
        IF level = 0 {
          PRINT " " AT(1,row + level0Offset[l0i]).
          SET l0i TO l0i + 1.
          IF l0i > l0Max {
            SET l0i TO 0.
          }
          PRINT "X" AT(1,row + level0Offset[l0i]).
        } ELSE IF level = 1 {
          IF l0i < 2 {
            SET gameData[pType]["isHuman"] TO NOT gameData[pType]["isHuman"].
            draw_player_setttings(col,row + level0Offset[l0i],pType,level).
          } ELSE {
            SET gameData["showOptions"] TO NOT gameData["showOptions"].
            draw_game_restart(col + 2,row + level0Offset[l0i] + 1,"X").
          }
        } ELSE IF level = 2 {
          LOCAL AIti IS aiTypeToNum[gameData[pType]["aiType"]] + 1.
          IF AIti > AItMax {
            SET AIti TO 0.
          }
          SET gameData[pType]["aiType"] TO aiTypeToNum[AIti].
          draw_player_setttings(col,row + level0Offset[l0i],pType,level).

        }
      }
    }
    WAIT 0.
  }
}

FUNCTION ui_congratulation {
  PARAMETER pType,delayTime IS 5.
  CLEARSCREEN.
  PRINT "Congratulation Player " + pType + " On winning this match".
  WAIT delayTime.
  RETURN TRUE.
}

FUNCTION ui_quit {
  ui_interrupt_handler(LIST("o","q","h")).
  CLEARSCREEN.
  PRINT "Do you want to Quit?" AT(0,0).
  PRINT "[X],Yes"AT(0,1).
  PRINT "[ ],No"AT(0,2).
  LOCAL doQuit IS TRUE.

  LOCAL done IS FALSE.
  UNTIL done {
    ui_interrupt_handler(LIST("o","q","h")).
    IF is_up_key() OR is_down_key() {
      SET doQuit TO NOT doQuit.
      IF doQuit {
        PRINT "X"AT(1,1).
        PRINT " "AT(1,2).
      } ELSE {
        PRINT " "AT(1,1).
        PRINT "X"AT(1,2).
      }
    }
    IF is_enter_key() {
      SET done TO TRUE.
    } 
  }
  SET quitGame TO doQuit.
}

FUNCTION ui_help {
  LOCAL row IS 0.
  LOCAL col IS 0.

  draw_help_menue(col,row).
  LOCAL iMax IS 4.
  LOCAL move IS 0.
  PRINT "X" AT(col + 1,row).
  LOCAL done IS FALSE.
  UNTIL done {
    IF ui_interrupt_handler(LIST("o","h")) {
      IF quitGame { BREAK. }
      draw_help_menue(col,row).
    }
    IF is_enter_key() {
      IF move = 0 {
        ui_help_rules().
      } ELSE IF move = 1 {
        ui_help_board().
      } ELSE IF move = 2 {
        ui_help_ai().
      } ELSE IF move = 3 {
        ui_help_intro().
      } ELSE IF move = 4 {
        SET done TO TRUE.
      }
      IF quitGame { BREAK. }
      draw_help_menue(col,row).
      PRINT "X" AT(col + 1,row + move).
    } ELSE {
      IF is_up_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move - 1.
        IF move < 0 {
          SET move TO iMax.
        }
        PRINT "X" AT(col + 1,row + move).

      } ELSE IF is_down_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move + 1.
        IF move > iMax {
          SET move TO 0.
        }
        PRINT "X" AT(col + 1,row + move).

      }
    }
    WAIT 0.
  }
}

FUNCTION ui_help_rules {
  LOCAL page IS 1.
  draw_help_rules(page).
  UNTIL page > 2 {
    IF ui_interrupt_handler(LIST("o","h")) {
      IF quitGame { BREAK. }
      draw_help_rules(page).
    }
    IF is_enter_key(FALSE) {
      SET page to page + 1.
      draw_help_rules(page).
    }
    WAIT 0.
  }
}

FUNCTION ui_help_intro {
  PARAMETER isFirstIntro IS FALSE.
  draw_help_intro(isFirstIntro).
  LOCAL done IS FALSE.
  UNTIL done {
    IF ui_interrupt_handler(LIST("o","h")) {
      IF quitGame { BREAK. }
      draw_help_intro(isFirstIntro).
    }
    IF is_enter_key(FALSE) {
      SET done TO TRUE.
    }
    WAIT 0.
  }
}


FUNCTION ui_help_board {
  LOCAL col IS boardPos[0] + 1.
  LOCAL row IS boardPos[1] + 14.
  LOCAL iMax IS 3.
  LOCAL move IS 0.
  LOCAL updateTime IS TIME:SECONDS + 1.
  LOCAL updateBoard IS TRUE.
  LOCAL movePieceState IS 0.
  LOCAL xMove IS TRUE.

  draw_help_board(boardPos[0],boardPos[1],helpBoardData[helpKeyToNum[move]]).
  draw_help_board_info(col - 6,row + 5,move).

  LOCAL moveBoardData IS helpBoardData["move"].
  clear_board(moveBoardData,helpPieceData).
  SET helpPieceData["xStart"] TO 0.
  SET helpPieceData["oStart"] TO 0.
  SET moveBoardData["X Start -5"] TO " ".
  SET moveBoardData["O Start -5"] TO " ".

  PRINT "X" AT(col,row).
  LOCAL done IS FALSE.
  UNTIL done {
    IF ui_interrupt_handler(LIST("o","h")) {
      IF quitGame { BREAK. }
      draw_help_board(boardPos[0],boardPos[1],helpBoardData[helpKeyToNum[move]]).
      draw_help_board_info(col - 6,row + 5,move).
    }
    IF is_enter_key() {
      SET done TO TRUE.
    } ELSE {
      IF is_up_key() {
        PRINT " " AT(col,row + move).
        SET move TO move - 1.
        IF move < 0 {
          SET move TO iMax.
        }
        PRINT "X" AT(col,row + move).
        SET updateBoard TO TRUE.
      } ELSE IF is_down_key() {
        PRINT " " AT(col,row + move).
        SET move TO move + 1.
        IF move > iMax {
          SET move TO 0.
        }
        PRINT "X" AT(col,row + move).
        SET updateBoard TO TRUE.
      }
    }

    IF (move = 0) AND (updateTime < TIME:SECONDS) {
      SET updateTime TO TIME:SECONDS + 0.5.
      IF xMove {
        IF movePieceState = 0 {
          SET moveBoardData["X Start -5"] TO "X".
          SET helpPieceData["xStart"] TO 1.
          SET helpPieceData["xEnd"] TO 0.
        }
        LOCAL moveList IS player_move_list("X",1,moveBoardData).
        FOR move IN moveList {
          move_piece("X",move,moveBoardData,helpPieceData).
        }
      } ELSE {
        IF movePieceState = 5 {
          SET moveBoardData["O Start -5"] TO "O".
          SET helpPieceData["oStart"] TO 1.
          SET helpPieceData["oEnd"] TO 0.
        }
        LOCAL moveList IS player_move_list("O",1,moveBoardData).
        FOR move IN moveList {
          move_piece("O",move,moveBoardData,helpPieceData).
        }
      }
      SET xMove TO NOT xMove.
      SET movePieceState TO movePieceState + 1.
      IF movePieceState > 9 {
        SET movePieceState TO 0.
      }
      draw_picses(boardPos[0],boardPos[1],moveBoardData,helpPieceData,FALSE).
    }

    IF updateBoard {
      draw_picses(boardPos[0],boardPos[1],helpBoardData["blank"],helpPieceData,FALSE).
      draw_picses(boardPos[0],boardPos[1],helpBoardData[helpKeyToNum[move]],helpPieceData,FALSE).
      draw_help_board_info(col - 6,row + 5,move).
      SET updateBoard TO FALSE.
    }
    WAIT 0.
  }
}

FUNCTION ui_help_ai {
  LOCAL col IS 0.
  LOCAL row IS 0.
  LOCAL iMax IS 5.
  LOCAL drawTextOffset IS row + iMax + 3.
  LOCAL move IS 0.

  draw_ai_types_list(col,row).
  draw_ai_types_info(col,drawTextOffset,move).

  PRINT "X" AT(col + 1,row).
  LOCAL done IS FALSE.
  UNTIL done {
    IF ui_interrupt_handler(LIST("o","h")) {
      IF quitGame { BREAK. }
      draw_ai_types_list(col,row).
      draw_ai_types_info(col,drawTextOffset,move).
    }
    IF is_enter_key() {
      SET done TO TRUE.
    } ELSE {
      IF is_up_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move - 1.
        IF move < 0 {
          SET move TO iMax.
        }
        PRINT "X" AT(col + 1,row + move).
        draw_ai_types_info(col,drawTextOffset,move).
      } ELSE IF is_down_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move + 1.
        IF move > iMax {
          SET move TO 0.
        }
        PRINT "X" AT(col + 1,row + move).
        draw_ai_types_info(col,drawTextOffset,move).
      }
    }
  }
}

FUNCTION ui_move {
  PARAMETER col,row,moveList,boardData,pieceData.
  keyQueue:CLEAR().
  LOCAL iMax IS moveList:LENGTH -1.
  LOCAL done IS FALSE.
  LOCAL move IS 0.
  PRINT "X" AT(col + 1,row).
  UNTIL done {
    IF ui_interrupt_handler() {
      IF quitGame { BREAK. }
      CLEARSCREEN.
      draw_board(boardPos[0],boardPos[1]).
      draw_picses(boardPos[0],boardPos[1],boardData,pieceData).
      draw_move_list(col,row,moveList).
      PRINT "X" AT(col + 1,row + move).
    }
    IF is_enter_key() {
      SET done TO TRUE.
    } ELSE {
      IF is_up_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move - 1.
        IF move < 0 {
          SET move TO iMax.
        }
        PRINT "X" AT(col + 1,row + move).
      } ELSE IF is_down_key() {
        PRINT " " AT(col + 1,row + move).
        SET move TO move + 1.
        IF move > iMax {
          SET move TO 0.
        }
        PRINT "X" AT(col + 1,row + move).
      }
    }
    WAIT 0.
  }

  RETURN move.
}

FUNCTION is_up_key {
  PARAMETER keepOther IS TRUE.
  RETURN is_key(termIn:UPCURSORONE,keepOther).
}

FUNCTION is_down_key {
  PARAMETER keepOther IS TRUE.
  RETURN is_key(termIn:DOWNCURSORONE,keepOther).
}

FUNCTION is_enter_key {
  PARAMETER keepOther IS TRUE.
  RETURN is_key(termIn:ENTER,keepOther).
}

FUNCTION is_key {
  PARAMETER checkChar,keepOther.
  IF NOT keyQueue:EMPTY {
    IF keepOther {
      IF keyQueue:PEEK() = checkChar {
        keyQueue:POP().
        RETURN TRUE.
      }
    } ELSE {
      IF keyQueue:POP() = checkChar {
        RETURN TRUE.
      }
    }
  }
  RETURN FALSE.
}

//drawing

//  game options drawing

FUNCTION draw_game_options {
  PARAMETER col,row.
  CLEARSCREEN.
  PRINT "                          ---Game Options---                          " AT(col,row).
  draw_human_ai_options(col,row + 1,"X").
  SET row TO row + 11.
  draw_human_ai_options(col,row,"O").
  SET row TO row + 10.
  PRINT "[ ]Bring up game options when a match ends" AT(col,row).
  PRINT "-[ ]Yes" AT(col,row + 1).
  PRINT "-[ ]No" AT(col,row + 2).
  SET row TO row + 4.
  PRINT "[ ]Start New Game" AT(col,row).
  IF gameData["inProgres"] {
    PRINT "[ ]Resume Game" AT(col,row + 1).
    PRINT "This [-] marks the current setttings" AT(col,row + 3).
    PRINT "Press <Enter> to select [x]" AT(col,row + 4).
    PRINT "Any changes will take effect after the current turn ends." AT(col,row + 5).
  } ELSE {
    PRINT "This [-] marks the current setttings" AT(col,row + 1).
    PRINT "Press <Enter> to select [x]" AT(col,row + 2).
  }
}

FUNCTION draw_human_ai_options {
  PARAMETER col,row,pType.
  PRINT "[ ]Player " + pType + " Type" AT(col,row).
  PRINT "-[ ]Human" AT(col,row + 1).
  PRINT "-[ ]AI" AT(col,row + 2).
  PRINT "--[ ]Hare" AT(col,row + 3).
  PRINT "--[ ]Tortoise"AT(col,row + 4).
  PRINT "--[ ]Threat Aware"AT(col,Row + 5).
  PRINT "--[ ]Random" AT(col,row + 6).
  PRINT "--[ ]Mutating" AT(col,row + 7).
  PRINT "--[ ]Random AI" AT(col,row + 8).
}

FUNCTION draw_current_settings {
  PARAMETER col,row,pType,level.
  SET row TO row + 1.
  IF pType = "X" {
    draw_player_setttings(col,row,"X",level).
    draw_player_setttings(col,row + 4 + aiMoveMap:KEYS:LENGTH,"O",0).
  } ELSE {
    draw_player_setttings(col,row,"X",0).
    draw_player_setttings(col,row + 4 + aiMoveMap:KEYS:LENGTH,"O",level).
  }
}

FUNCTION draw_player_setttings {
  PARAMETER col,row,pType,level.
  LOCAL pData IS gameData[pType].
  PRINT " " AT(2 + col,1 + row).
  PRINT " " AT(2 + col,2 + row).
  FOR key IN aiMoveMap:KEYS {
    PRINT " " AT(3 + col,3 + row + aiTypeToNum[key]).
  }
  LOCAL typeChar IS "-".
  LOCAL aiChar IS "-".
  IF level = 1 {
    SET typeChar TO "X".
  }

  IF pData["isHuman"] {
    PRINT typeChar AT(2 + col,1 + row).
  } ELSE {
    PRINT typeChar AT(2 + col,2 + row).
    IF level = 2 {
      SET aiChar TO "X".
    }
  }
  PRINT aiChar AT (3 + col,3 + row + aiTypeToNum[pData["AItype"]]).
}

FUNCTION draw_game_restart {
  PARAMETER col,row,char.
  IF gameData["showOptions"] {
    PRINT char AT(col,row).
    PRINT " " AT(col,row + 1).
  } ELSE {
    PRINT " " AT(col,row).
    PRINT char AT(col,row + 1).
  }
}

//  help menu drawing

FUNCTION draw_help_intro {
  PARAMETER isFirstIntro.
  CLEARSCREEN.
  PRINT "The keys to select an option are the up and down arrows." AT(0,0).
  PRINT "The Enter key is used to confirm selection or continue." AT(0,1).
  PRINT "The O key is used to bring up game options." AT(0,2).
  PRINT "The H key is used to bring up the help menu." AT(0,3).
  PRINT "The Q key is to bring up quit menu." AT(0,4).
  PRINT "Not all menus are accessible at any one time." AT(0,5).
  IF  isFirstIntro {
    PRINT "Press <Enter> to continue to game options so the game can be started." AT(0,7).
  } ELSE {
    PRINT "Press <Enter> to return to help menu." AT(0,7).
  }

}

FUNCTION draw_help_menue {
  PARAMETER col,row.
  CLEARSCREEN.
  PRINT "[ ],Rules" AT(col,row).
  PRINT "[ ],Board Examples" AT(col,row + 1).
  PRINT "[ ],AI Types" AT(col,row + 2).
  PRINT "[ ],Key info" AT(col,row + 3).
  PRINT "[ ],Return" AT(col,row + 4).
  PRINT "Press <Enter> to select [x]" AT(col,row + 5).
}

FUNCTION draw_help_rules {
  PARAMETER pageNum.
  CLEARSCREEN.
  IF pageNum = 1 {
    PRINT "This is the Royal Game Of Ur made using the simpler race rule set.".
    PRINT "This is a two player game, one player is 'X' the other is 'O'.".
    PRINT "There are several AI options should you wish to play by your self.".
    PRINT "To play you roll dice to determine how far you move in a turn.".
    PRINT "The way to Win is to get all 7 of your pieces off the board.".
    PRINT "A player can send an opponent's piece back to the start by landing on".
    PRINT "it with their own piece.".
    PRINT "There are 5 areas on the board and players may only interact directly".
    PRINT "in the main area.".
    PRINT " ".
    PRINT "At the start of your turn you roll four sided dice.".
    PRINT "  Each die has 2 white and 2 black dots with one dot on each face.".
    PRINT "  The number of white dots are added together to get the number of".
    PRINT "  spaces you will move.".
    PRINT "  As you can get zero white dots on your roll it is possible to end up".
    PRINT "  skipping your turn.".
    PRINT "  There are 5 tiles that when landed on allow the player to roll again".
    PRINT "  The probability spread for all possible rolls are:".
    PRINT "    0: 1/16, 1: 2/8 2; 3/8, 3: 2/8, 4: 1/16".
    PRINT " ".
    PRINT "To get a piece off the board you must roll the exact number.".
    PRINT "  For instance if you are on the last tile then you must roll a 1.".
    PRINT " ".
    PRINT "Press <Enter> to see page 2.".
  } ELSE {
    PRINT "A player can only interact with their opponent's pieces in the main".
    PRINT "area of the board.".
    PRINT "  To send an opponent's piece back to the start a player must simply".
    PRINT "  land on the piece they wish to send back.".
	PRINT "  A player can't land on there own pieces.".
    PRINT "  The roll again tile in the main area is a safe tile and a piece".
    PRINT "  on the tile can't be sent back to the start.".
    PRINT " ".
    PRINT "The 5 areas on the board are xStart, oStart, Main, xEnd, oEnd.".
    PRINT "  The tiles are numbered from -4 to 9 along the path of movement.".
    PRINT "  Some tiles have duplicate numbers because each player has their own".
    PRINT "  start and end areas.".
    PRINT "  There are 2 hidden tiles for starting and ending places.".
    PRINT "    The starting area is numbered -5.".
    PRINT "    The ending area is numbered 10.".
    PRINT " ".
    PRINT "For examples on piece moment, the area location, tile numbering,".
    PRINT "  roll again, and the save tile see the 'Board Examples'".
    PRINT "  option in help menu.".
    PRINT "For a more detailed explanation of the various AI types see ".
    PRINT "  the 'AI Types' option in help menu.".
    PRINT " ".
    PRINT "Press <Enter> to return to main help menu.".
  }
}

FUNCTION draw_help_board {
  PARAMETER col,row,boardData.
  CLEARSCREEN.
  draw_board(col,row).
  draw_picses(col,row,boardData,helpPieceData,FALSE).
  SET row TO row + 14.
  PRINT "[ ],Piece Movement" AT(col,row).
  PRINT "[ ],Area Location" AT(col,row + 1).
  PRINT "[ ],Tile Numbers" AT(col,row + 2).
  PRINT "[ ],Roll Again Tiles" AT(col,row + 3).
  PRINT "Press <Enter> to Return to Main Help Menu." AT(col,row + 4).
}

FUNCTION draw_help_board_info {
  PARAMETER col,row,page.
  draw_blank_lines(row,0,4).
  IF page = 0 {
    PRINT "Here you can see the X and O pieces moving along there path towards" AT(col,row).
    PRINT " the end of the board." AT(col,row + 1).
  } ELSE IF page = 1 {
    PRINT "The area marked 'm' is the Main area and is where player pieces can" AT(col,row).
    PRINT " interact with each other." AT(col,row + 1).
    PRINT "The areas marked 's' are the Starting areas there is 1 for each player" AT(col,row + 2).
    PRINT "The areas marked 'e' are the End areas there is 1 for each player." AT(col,row + 3).
    PRINT "The the 'X' and 'O' show which area can only have that player's pieces" AT(col,row + 4).
  } ELSE IF page = 2 {
    PRINT "The displayed numbers are assigned number for each tile." AT(col,row).
    PRINT "There are 2 hidden tiles for each player for the start and end tiles." AT(col,row + 1).
  } ELSE IF page = 3 {
    PRINT "There are 5 roll again tiles shown here with 'R'." AT(col,row).
  } 

}

FUNCTION draw_ai_types_list {
  PARAMETER col,row.
  CLEARSCREEN.
  PRINT "[ ]Hare" AT(col,row).
  PRINT "[ ]Tortoise"AT(col,row + 1).
  PRINT "[ ]Threat Aware"AT(col,Row + 2).
  PRINT "[ ]Random Move"AT(col,row + 3).
  PRINT "[ ]Mutating"AT(col,row + 4).
  PRINT "[ ]Random AI"AT(col,row + 5).
  PRINT "Press <Enter> to Return to Main Help Menu."AT(col,row + 6).
}

FUNCTION draw_ai_types_info {
  PARAMETER col,row,page.
  draw_blank_lines(row,0,3).
  IF page = 0 {
    PRINT "The Hare AI will move it's piece closest to the end." AT(col,row).
  } ELSE IF page = 1 {
    PRINT "The Tortoise will move it's piece closest to the start." AT(col,row).
  } ELSE IF page = 2 {
    PRINT "The Threat Aware mostly moves in response to the threat that it's" AT(col,row).
    PRINT "  opponent's pieces represent to it and tries to minimize said threat." AT(col,row + 1).
  } ELSE IF page = 3 {
    PRINT "The 'Random move' AI will move a piece at random." AT(col,row).
  } ELSE IF page = 4 {
    PRINT "The 'Mutating' AT will play as Hare, Tortoise, Threat Aware, " AT(col,row).
    PRINT "or Random Move AIs for between 1 and 5 turns befor changing" AT(col,row + 1).
    PRINT "to a different AI type." AT(col,row + 2).
  } ELSE IF page = 5 {
    PRINT "The 'Random AI' AI will pick Hare, Tortoise, Threat Aware, or" AT(col,row).
    PRINT "Random move AIs to play as for the duration of the game." AT(col,row + 1).
  }
}

FUNCTION draw_blank_lines {
  PARAMETER row,initial,end.
  FROM { LOCAL i IS initial. } UNTIL i > end STEP {SET i TO i + 1. } DO {
    PRINT blankLine AT(0,row + i).
  }
}

//  game play and board drawing

FUNCTION draw_move_list {
  PARAMETER col,row,moveList.
  FOR move IN moveList {
    LOCAL p1 IS move[0]:PADRIGHT(10).
    //UNTIL p1:LENGTH > 9 { SET p1 TO p1 + " ". }
    LOCAL p2 IS move[1]:PADRIGHT(10).
    //UNTIL p2:LENGTH > 9 { SET p2 TO p2 + " ". }
    PRINT "[ ],From: " + p1 + " To: " +  p2 AT(col,row).
    SET row TO row + 1.
  }
  UNTIL row > 27 {
    PRINT "                                   " AT(col,row).
    SET row TO row + 1.
  }
}

FUNCTION draw_picses {
  PARAMETER col,row,boardData,pieceData,drawData IS TRUE.
  FOR space IN validSpaces {
    LOCAL spaceData IS spacePos[space].
    IF spaceData[0] <> 0 {
      PRINT boardData[space] AT(col + spaceData[0],row + spaceData[1]).
    }
  }
  IF drawData {
    PRINT "X Off Board: " + pieceData["xEnd"] + ", X At Start: " + pieceData["xStart"] AT(col,row - 2).
    PRINT "O Off Board: " + pieceData["oEnd"] + ", O At Start: " + pieceData["oStart"] AT(col,row - 1).
  }
}

FUNCTION draw_board {
  PARAMETER col,row.
  CLEARSCREEN.
  draw_lines( 0 + col,1 + row,5,6,"11001111",draw_h_line@).
  draw_lines( 1 + col,0 + row,3,6,"111011111",draw_v_line@).
  draw_lines( 4 + col,1 + row,5,6,"11111111",draw_h_line@).
  draw_lines( 5 + col,0 + row,3,6,"111111111",draw_v_line@).
  draw_lines( 8 + col,1 + row,5,6,"11111111",draw_h_line@).
  draw_lines( 9 + col,0 + row,3,6,"111011111",draw_v_line@).
  draw_lines(12 + col,1 + row,5,6,"11001111",draw_h_line@).
  FOR spot IN rollAgainSpots {
    draw_rosete (col + spacePos[spot][0],row + spacePos[spot][1]).
  }
}

FUNCTION draw_rosete {
  PARAMETER col,row.
  draw_h_line(col - 1,row - 1,3).
  draw_v_line(col - 2,row + 0,1).
  draw_v_line(col + 2,row + 0,1).
  draw_h_line(col - 1,row + 1,3).
}

FUNCTION draw_lines {
  PARAMETER col,row,lineLength,colSkip,lineString,drawFunc.
  FOR charter IN lineString {
    IF charter = "1" {
      drawFunc(row,col,lineLength).
    }
    SET row TO row + colSkip.
  }
}

FUNCTION draw_h_line {
  PARAMETER col,row,lineLength.
  FROM { LOCAL i IS 0. } UNTIL i >= lineLength STEP { SET i TO i + 1. } DO {
    PRINT "─" AT(col + i,row).
    WAIT 0.
  }
}

FUNCTION draw_v_line {
  PARAMETER col,row,lineLength.
  FROM { LOCAL i IS 0. } UNTIL i >= lineLength STEP { SET i TO i + 1. } DO {
    PRINT "│" AT(col,row + i).
    WAIT 0.
    WAIT 0.
  }
}

//piece movement

FUNCTION move_piece {//will return true when moved piece lands on a re-roll tile
  PARAMETER pType,moveData,boardData,pieceData.
  LOCAL pos IS moveData[0].
  LOCAL newPos IS moveData[1].

  SET boardData[pos] TO " ".

  IF boardData[newPos] <> " " {//handle removing opponent piece
    LOCAL notpType IS otherPlayer[pType].
    LOCAL resetPiece IS notpType + "Start".
    IF pieceData[resetPiece] = 0 {
      SET boardData[notpType + " Start -5"] TO notpType.
    }
    SET pieceData[resetPiece] TO pieceData[resetPiece] + 1.
  }

  IF pos = pType + " Start -5" {//handle placing new piece on board
    SET pieceData[pType + "Start"] TO pieceData[pType + "Start"] - 1.
    IF pieceData[pType + "Start"] > 0 {
      SET boardData[pos] TO pType.
    }
  }

  IF newPos <> pType + " End 10" {//handle for moving a piece off board
    SET boardData[newPos] TO pType.
  } ELSE {
    SET pieceData[pType + "End"] TO pieceData[pType + "End"] + 1.
  }
  RETURN rollAgainSpots:CONTAINS(newPos).
}

FUNCTION is_move_valid {
  PARAMETER pType,pos,dRoll,boardData.
  IF boardData[pos] <> pType {//check if there is a piece of right type at start location
    RETURN FALSE.
  }
  LOCAL newPos IS new_pos_string(pType,pos,dRoll).

  IF NOT validSpaces:CONTAINS(newPos) {//check for move is on board.
    RETURN FALSE.
  }

  IF boardData[newPos] <> " " {
    IF boardData[newPos] = pType {//check for same type in next location
      RETURN FALSE.
    }
    IF rollAgainSpots:CONTAINS(newPos) { //check for other on rosette
      RETURN FALSE.
    }
  }

  RETURN TRUE.
}

FUNCTION new_pos_string {
  PARAMETER pType,pos,dRoll.
  LOCAL newPosNum IS pos_to_num(pos) + dRoll.
  LOCAL newPos IS "".
  IF newPosNum >= 0 {
    IF newPosNum < 8 {
      SET newPos TO "main " + newPosNum.
    } ELSE {
      SET newPos TO pType + " End " + newPosNum.
    }
  } ELSE {
    SET newPos TO pType + " Start " + newPosNum.
  }
  RETURN newPos.
}

FUNCTION pos_to_num {
  PARAMETER pos.
  RETURN pos:SUBSTRING(pos:LENGTH - 2,2):TONUMBER().
}

//game play

FUNCTION dice_roll {
  LOCAL rollValue IS 0.
  FROM { LOCAL i IS 0. } UNTIL i > 3 STEP { SET i TO i + 1. } DO {
    IF RANDOM() > 0.5 {
      SET rollValue TO rollValue + 1.
    }
  }
  RETURN rollValue.
}

FUNCTION set_player_move_first {
  IF RANDOM() > 0.5 {
    SET gameData["curentTurn"] TO "O".
  } ELSE {
    SET gameData["curentTurn"] TO "X".
  }
}

FUNCTION clear_board {
  PARAMETER boardData,pieceData.
  FOR space IN validSpaces {
    SET boardData[space] TO " ".
  }
  SET pieceData["xStart"] TO 7.
  SET pieceData["oStart"] TO 7.
  SET pieceData["xEnd"] TO 0.
  SET pieceData["oEnd"] TO 0.
  SET boardData["X Start -5"] TO "X".
  SET boardData["O Start -5"] TO "O".
}

FUNCTION player_move_list {
  PARAMETER pType,dieRoll,boardData.
  LOCAL moveList IS LIST().
  IF dieRoll > 0 {

    LOCAL pos IS pType + " Start -5".
    FOR pos IN validSpaces {
      IF is_move_valid(pType,pos,dieRoll,boardData) {
        moveList:ADD(LIST(pos,new_pos_string(pType,pos,dieRoll))).
      }
    }
  }
  RETURN moveList.
}

//AI

FUNCTION ai_move {
  PARAMETER pType,pData,moveList.
  RETURN aiMoveMap[pData["AItype"]](pType,pData,moveList).
}

FUNCTION ai_random {
  PARAMETER pType,pData,moveList.
  LOCAL moveMax IS moveList:LENGTH.
  LOCAL move IS moveMax.
  UNTIL move < moveMax {
    SET move TO FLOOR(RANDOM() * moveMax).
  }
  RETURN move.
}

FUNCTION ai_random_ai {
  PARAMETER pType,pData,moveList.
  LOCAL aiState IS pData["AIstate"].
  IF aiState[0] = 0 {
    LOCAL maxType IS 4.
    SET aiState[1] TO FLOOR(RANDOM() * maxType).
    UNTIL aiState[1] < maxType {
      SET aiState[1] TO FLOOR(RANDOM() * maxType).
    }
    SET aiState[0] TO 1.
  }
  RETURN aiMoveMap[aiMoveMap:KEYS[aiState[1]]]( pType,pData,moveList).
}

FUNCTION ai_mutating {
  PARAMETER pType,pData,moveList.
  LOCAL aiState IS pData["AIstate"].
  IF aiState[0] <= 0 {
    LOCAL maxType IS aiMoveMap:KEYS:LENGTH - 3.
    SET aiState[1] TO FLOOR(RANDOM() * maxType).
    UNTIL aiState[1] < maxType {
      SET aiState[1] TO FLOOR(RANDOM() * maxType).
    }
    SET aiState[0] TO FLOOR(RANDOM() * 4).
  } ELSE {
    SET aiState[0] TO aiState[0] - 1.
  }
  RETURN aiMoveMap[aiMoveMap:KEYS[aiState[1]]]( pType,pData,moveList).
}

FUNCTION ai_hare_move {
  PARAMETER pType,pData,moveList.
  RETURN moveList:LENGTH - 1.
}

FUNCTION ai_tortoise_move {
  PARAMETER pType,pData,moveList.
  RETURN 0.
}

FUNCTION ai_threat_map {
  PARAMETER pType,pData,moveList.

  LOCAL moveScore IS LIST().
  LOCAL greatistScore IS -100.
  LOCAL moveNum IS 0.
  IF moveList:LENGTH > 1 {
    FOR move IN moveList {
      LOCAL currentThreat IS threat_at_tile(pType,move[0]).
      LOCAL futureThreat IS threat_at_tile(pType,move[1]).
      LOCAL moveStart IS move[0].
      LOCAL moveEnd IS move[1].

      LOCAL score IS currentThreat - futureThreat.

      IF gameBoardData[moveEnd] = otherPlayer[pType] {
        SET score to score + 0.622 * pos_to_num(moveEnd) + 0.579.
      }

      IF moveStart:CONTAINS("start") {//score based on area
        SET score TO score - 0.5.
        IF moveStart:CONTAINS("start -5") {
          SET score TO score + 0.215.
        }
        IF moveEnd:CONTAINS("start") {
          SET score TO score + 0.02.
        } ELSE {
          SET score TO score - 0.294.
        }
      } ELSE IF moveStart:CONTAINS("main") {
        SET score TO score - 0.742.
        IF moveEnd:CONTAINS("main") {
          SET score TO score + 0.021.
        } ELSE {
          IF moveEnd:CONTAINS("end 10") {
            SET score TO score + -0.041.
          }
          SET score TO score + 0.459.
        }
      } ELSE {
        IF moveEnd:CONTAINS("end 10") {
          SET score TO score + -0.041.
        }
        SET score TO score + 0.007.
      }

      IF rollAgainSpots:CONTAINS(moveStart) {
        SET score TO score + 0.033.
      }

      IF rollAgainSpots:CONTAINS(moveEnd) {
        SET score TO score + 0.52.
      }

      IF score >= greatistScore {
        SET greatistScore TO score.
      }
      moveScore:ADD(score).
    }
    LOCAL shouldMove IS LIST().
    FROM { LOCAL i IS moveScore:LENGTH - 1. } UNTIL i < 0 STEP { SET i TO i - 1. } DO {
      IF moveScore[i] = greatistScore {
        shouldMove:ADD(i).
      }
    }
    RETURN shouldMove[ai_random(0,0,shouldMove)].
  } ELSE {
    RETURN 0.
  }
}

FUNCTION threat_at_tile {
  PARAMETER pType,pos.

  IF NOT pos:CONTAINS("main") OR pos:CONTAINS("main 03") {//only main tiles are a threat save for roll again spot
    RETURN 0.
  }
  LOCAL notpType IS otherPlayer[pType].

  LOCAL hitChance IS 0.
  FROM { LOCAL i IS 0. } UNTIL i > 3 STEP { SET i TO i + 1. } DO {
    LOCAL backDist IS i - 4.
    LOCAL attackPos IS new_pos_string(notpType,pos,backDist).
    IF validSpaces:CONTAINS(attackPos) {

      IF gameBoardData[attackPos] = notpType {
        SET hitChance TO hitChance + rollSpread[i].
      } ELSE IF rollAgainSpots:CONTAINS(attackPos) AND gameBoardData[attackPos] = " " {
        SET hitChance TO hitChance + rollSpread[i] * threat_at_tile(pType,attackPos).
      }
    } ELSE {
      BREAK.
    }
  }
  RETURN hitChance.
}