// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_gui_box

This library contains functions to draw boxes like this:
```
+=====+
|     |
|     |
+=====+
```
in the terminal.

### draw_gui_box

args:
  * x - number, the first column of the box starting with zero (left)
  * y - number, the first row of the box starting with zero (top)
  * w, h - width and height of the box

returns:
  * Nothing.

description:
  * `draw_gui_box(0, 0, 6, 4).` draws this:
  ```
  +====+
  |    |
  |    |
  +====+
  ```

### draw_one_char_gui_box

  args:
    * x - number, the first column of the box starting with zero (left)
    * y - number, the first row of the box starting with zero (top)
    * w, h - width and height of the box
    * border_char - character, the character to draw outline with

  returns:
    * Nothing.

  description:
    * `draw_one_char_gui_box(0, 0, 6, 4, "#").` draws this:
    ```
    ######
    #    #
    #    #
    ######
    ```

### draw_custom_gui_box

args:
  * x - number, the first column of the box starting with zero (left)
  * y - number, the first row of the box starting with zero (top)
  * w, h - width and height of the box
  * horizontal_char - character, the character to draw top and bottom with
  * vertical_char - character, the character to draw sides with
  * corner_char - character, the character to draw corner

returns:
  * Nothing.

description:
  * `draw_custom_gui_box(0, 0, 6, 4, "h", "v", "c").` draws this:
  ```
  chhhhc
  v    v
  v    v
  chhhhc
  ```
