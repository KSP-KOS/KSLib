// This file is distributed under the terms of the MIT license, (c) the KSLib team

Authored by Dunbaratu, adapted by space_is_hard.

## lib_draw_axes

``lib_draw_axes.ks`` provides the user with a visual representation of the X, Y, and Z axes of a direction that the user inputs using the ``VECDRAW()`` abilities of kOS.

## drawAxes()

args:
  * A direction (e.g. UP, NORTH, PROGRADE, etc).
  * A color.
  * A scalar that represents the scale that the function should draw the ``VECDRAW`` arrows to.
  * A string that the arrows should be labelled with.

returns:
  * Three ``VECDRAW`` arrows representing the input's X, Y, and Z components.

description:
  * Provided a direction, drawAxes() will display three arrows to represent the X, Y, and Z components of that direction. The arrows will be slightly color offset from the input color, will be scaled to the input scale, and will be labelled with the input label *plus* the component (i.e. when the input label is "Mylabel", the X-axis arrow is labelled "Mylabel X").

## drawAxesUndo()

args:
  * None

returns:
  * None

description:
  * Will remove from display the most recent drawAxes() command that was issued. If none are displayed, this function does nothing.