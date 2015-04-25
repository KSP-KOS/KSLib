// This file is distributed under the terms of the MIT license, (c) the KSLib team

function open_number_dialog
{
  parameter
    title,
    number,
    increment.


  clearscreen.

  print title at (0, 0).
  print "ag6/ag7 - increase/decrease number by increment" at (0, 5).
  print "ag8/ag9 - multiply/divide increment by 10" at (0, 6).
  print "ag10 - enter" at (0, 7).

  local old_increase is ag6.
  local old_decrease is ag7.
  local old_mul10 is ag8.
  local old_div10 is ag9.
  local old_enter is ag10.

  until old_enter <> ag10
  {
    print "number: " + number + "                " at (0, 2).
    print "increment: " + increment + "                " at (0, 3).

		if old_increase <> ag6
    {
      set old_increase to ag6.
			set number to number + increment.
		}
		if old_decrease <> ag7
    {
      set old_decrease to ag7.
      set number to number - increment.
		}
		if old_mul10 <> ag8
    {
      set old_mul10 to ag8.
      set increment to increment * 10.
		}
    if old_div10 <> ag9
    {
      set old_div10 to ag9.
      set increment to increment / 10.
		}
  }

  clearscreen.

  return number.
}
