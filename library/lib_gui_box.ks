// This file is distributed under the terms of the MIT license, (c) the KSLib team
// This file is based on lib_window.ks from akrOS by akrasuski1.

function draw_custom_gui_box {
	parameter
		x, y, w, h,
		top_char,
		side_char,
    corner_char.

  // to-discuss: should we sanitize the input?
  // x >= 0, y >= 0, w >= 2, h >= 0, x + w <= terminal:width, y + h <= terminal:height

	local horizontal_str is corner_char.
	local i is 0.
	until i >= w - 2 {
		set horizontal_str to horizontal_str + top_char.
		set i to i + 1.
	}
	set horizontal_str to horizontal_str + corner_char.
	print horizontal_str at(x, y).
	print horizontal_str at(x, y + h - 1).
	set i to 1.
	until i >= h - 1 {
		print side_char at(x , y + i).
		print side_char at(x + w - 1, y + i).
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
