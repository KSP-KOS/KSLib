// This file is distributed under the terms of the MIT license, (c) the KSLib team
// This file is based on lib_window.ks from akrOS by akrasuski1.

function draw_custom_gui_box {
	parameter
		x, y, w, h,
		horizontal_char,
		vertical_char,
    corner_char.

  // Start Input Sanitization
        if x < 0 or x >= terminal:width - 2 {
         set x to max(0,min(terminal:width - 3,x)).
         HUDTEXT("Error: [draw_custom_gui_box] X value outside terminal.", 10, 2, 30, RED, FALSE).
        }
        
        if y < 0 or y >= (terminal:height ) {
         set y to max(0,min(terminal:height - 1,y)).
         HUDTEXT("Error: [draw_custom_gui_box] Y value outside terminal", 10, 2, 30, RED, FALSE).
        }
        
        if x + w >= terminal:width { //no need to check for w < 2 as the script already handles this
         set w to min(terminal:width - 1 - x,w).
         HUDTEXT("Error: [draw_custom_gui_box] W value outside terminal.", 10, 2, 30, RED, FALSE).
        }
        
        if y + h >= terminal:height { //no need to check for h < 1 as the script already handles this
         set h to min(terminal:height - y,h).
         HUDTEXT("Error: [draw_custom_gui_box] H value outside terminal.", 10, 2, 30, RED, FALSE).
        }
// End Input Sanitization
        
	local horizontal_str is corner_char.
	local i is 0.
	until i >= w - 2 {
		set horizontal_str to horizontal_str + horizontal_char.
		set i to i + 1.
	}
	set horizontal_str to horizontal_str + corner_char.
	print horizontal_str at(x, y).
	print horizontal_str at(x, y + h - 1).
	set i to 1.
	until i >= h - 1 {
		print vertical_char at(x , y + i).
		print vertical_char at(x + w - 1, y + i).
		set i to i + 1.
	}
}

function draw_gui_box
{
  parameter x, y, w, h.
  draw_custom_gui_box(x, y, w, h, "=", "|", "+").
}

function draw_one_char_gui_box
{
  parameter
    x, y, w, h,
    border_char.
  draw_custom_gui_box(x, y, w, h, border_char, border_char, border_char).
}
