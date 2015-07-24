##lib_seven_seg.

``lib_seven_seg.ks`` provides a set of functions that use Great Circle equations. On the surface of a sphere the shortest path between 2 points does not have a constant bearing. Use of these functions either on their own or combined can give you all sorts of details about the "as the crow flies" path between 2 points. Including which way you need to go, how far it is and what you will fly over.


###circle_bearing

args:
  * Input ``Number``. This should be between 0 and 9 (or `"b"` to blank the display and `"-"` for minus).
  * Column ``Number``. The left most column of the display (it is 3 columns wide).
  * Line ``Number``. The top line of the display (it is 3 lines hight).
  
description:
  * Prints a seven segmant display on the terminal showing the input value at the location specified.
