// This file is distributed under the terms of the MIT license, (c) the KSLib team
// This file is based on lib_window.ks from akrOS by akrasuski1.

function draw_custom_gui_box {
	parameter
		x, y, w, h,
		horizontal_char,
		vertical_char,
                corner_char.

  // Start Input Sanitization
        if x < 0 or x >= terminal:height {
         set x to max(0,min(teminal:height-1,x)).
         HUDTEXT("Error: [draw_custom_gui_box] X value outside terminal.", 10, 2, 30, RED, FALSE).
        }
        
        if y < 0 or y >= (terminal:width - 2 ) { 
         set y to max(0,min(terminal:width-3,y)).
         HUDTEXT("Error: [draw_custom_gui_box] Y value outside terminal", 10, 2, 30, RED, FALSE).
        }
        
        if w < 2 or x + w >= termianl:width { 
         set w to max(2,min(terminal:width - 1 - x,w)).
         HUDTEXT("Error: [draw_custom_gui_box] W value outside terminal.", 10, 2, 30, RED, FALSE).
        }
        
        if h < 0 or y + h >= termianl:height { 
         set w to max(2,min(terminal:height - 1 - y,h)).
         HUDTEXT("Error: [draw_custom_gui_box] H value outside terminal.", 10, 2, 30, RED, FALSE).
        }
        
        if h < 2 { 
         set w to 2.
         HUDTEXT("Error: [draw_custom_gui_box] W cannot be less than 2.", 10, 2, 30, RED, FALSE).
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
