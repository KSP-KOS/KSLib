# Summary
This repository is created from libraries submitted by multiple kOS users. All contributions are accepted as long as they satisfy the set requirements. As such there may be multiple libraries that provide the same functionality but take different approaches to it.

This is an attempt at summarising and categorising the libraries by their use cases.

### Control
1. [lib_pid.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_pid.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_pid.md) : provides functions for creating a PID controller. This functionality has been superseded by kOS buil-in `PIDLoop()`.
2. [lib_raw_user_input.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_raw_user_input.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_raw_user_input.md) : Listens for action groups in a list and returns the index of the activated action group.

### Data Structures
1. [lib_enum.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_enum.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_enum.md) : provides functions to manipulate structures like lists, stacks, queues etc.

### External Mod Compatibility
1. [lib_realchute.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_realchute.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_realchute.md) : Provides a way to (dis)arm, deploy and cut chutes if the RealChute mod is installed.

### File I/O
1. [lib_file_exists.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_file_exists.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_file_exists.md) : checks whether a given file exists or not on the current volume. This functionality has been superseded by kOS built-in `VOLUME:EXISTS()`.

### Maths and Statistics
1. [lib_running_average_filter.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_running_average_filter.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_running_average_filter.md) : gives a running average of a given list of numbers.

### Navigation
1. [lib_circle_nav.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_circle_nav.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_circle_nav.md) : provides functions to help with great circle / geodesic navigation while in atmosphere or the surface. For example, finding out the compass heading of a waypoint to fly there along the shortest path.
2. [lib_navball.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_navball.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_navball.md) : provides various navball state values (heading, pitch, roll, etc) of several kOS structures that can be considered to have such state.
3. [lib_navigation.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_navigation.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_navigation.md) : provides a range of functions to used in calculations of both space, atmospheric and surface navigation.

### Programming Utilities
1. [lib_exec.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_exec.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_exec.md) : allows executing commands and evaluating expressions from strings.

### Space Navigation
1. [lib_lazcalc.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_lazcalc.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_lazcalc.md) : does launch azimuth calculation.

### Terminal Utilities
1. [lib_gui_box.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_gui_box.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_gui_box.md) : draws ASCII boxes in the terminal.
2. [lib_input_string.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_input_string.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_input_string.md) : creates an on-screen keyboard inside the terminal.
3. [lib_list_dialog.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_list_dialog.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_list_dialog.md) : helps with long list navigation.
4. [lib_menu.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_menu.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_menu.md) : draws an interactive menu in the terminal.
5. [lib_num_to_formatted_str.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_num_to_formatted_str.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_num_to_formatted_str.md) : provides functions to format numbers and date-time values in standard formats. For example, numbers with given digit precision and SI unit, time broken into years, months, days etc.
6. [lib_num_to_str.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_num_to_str.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_num_to_str.md) : formats numbers to specified number of digits.
7. [lib_number_dialog.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_number_dialog.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_number_dialog.md) : draws a dialog box for numerical input in the terminal.
8. [lib_seven_seg.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_seven_seg.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_seven_seg.md) : creates a seven segment display to show single digit numbers.
9. [lib_str_to_num.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_str_to_num.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_str_to_num.md) : converts numerical strings into numbers. This has been superseded by kOS built-in `STRING:TONUMBER()`.
10. [lib_term.ks](https://github.com/KSP-KOS/KSLib/blob/master/library/lib_term.ks) / [docs](https://github.com/KSP-KOS/KSLib/blob/master/doc/lib_term.md) : a primitive terminal ASCII graphics library. Helps with drawing straight lines, circles and elliptical arcs.
