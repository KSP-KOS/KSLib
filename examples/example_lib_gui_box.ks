// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_gui_box.

clearscreen.

wait 1.

draw_custom_gui_box(0, 0, terminal:width, terminal:height - 1, "$", "^", "%").
draw_gui_box(2, 2, terminal:width - 4, terminal:height - 5).
draw_one_char_gui_box(4, 4, terminal:width - 8, terminal:height - 9, "#").

wait 4.

clearscreen.
