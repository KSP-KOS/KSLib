# Summary
This repository is created from libraries submitted by multiple kOS users. All 
contributions are accepted as long as they satisfy the set requirements. As 
such there may be multiple libraries that provide the same functionality but 
take different approaches to it.

This is an attempt at summarising and categorising the libraries by their use 
cases.

### Atmospheric Navigation
1. lib_circle_nav.ks : provides functions to help with great circle / geodesic 
   navigation while in atmosphere or the surface. For example, finding out the 
   compass heading of a waypoint to fly there along the shortest path.

### Data Structures
1. lib_enum.ks : provides functions to manipulate structures like lists, stacks,
   queues etc.

### External Mod Compatibility
1. lib_realchute.ks : Provides a way to (dis)arm, deploy and cut chutes if the 
   RealChute mod is installed.

### File I/O
1. lib_file_exists.ks : checks whether a given file exists or not on the 
   current volume. This functionality has been superseded by kOS built-in 
   `VOLUME:EXISTS()`.

### Maths and Statistics
1. lib_running_average_filter.ks : gives a running average of a given list of 
   numbers.

### Navigation
1. lib_navball.ks : provides various state values of a vessel like compass 
   heading, pitch, roll etc.
2. lib_pid.ks : provides functions for creating a PID controller. This 
   functionality has been superseded by kOS buil-in `PIDLoop()`.

### Space Navigation
1. lib_lazcalc.ks : does launch azimuth calculation.

### Terminal Utilities
1. lib_gui_box.ks : draws ASCII boxes in the terminal.
2. lib_input_string.ks : creates an on-screen keyboard inside the terminal.
3. lib_list_dialog.ks : helps with long list navigation.
4. lib_menu.ks : draws an interactive menu in the terminal.
5. lib_num_to_formatted_str.ks : provides functions to format numbers and 
   date-time values in standard formats. For example, numbers with given digit 
   precision and SI unit, time broken into years, months, days etc.
6. lib_num_to_str.ks : formats numbers to specified number of digits.
7. lib_raw_user_input.ks : currently broken. Listens for action groups in a 
   list and returns the index of the activated action group.
8. lib_seven_seg.ks : creates a seven segment display to show single digit 
   numbers.
9. lib_str_to_num.ks : converts numerical strings into numbers. This has been 
    superseded by kOS built-in `STRING:TONUMBER()`.
10. lib_term.ks : a primitive terminal ASCII graphics library. Helps with 
    drawing straight lines, circles and elliptical arcs.
11. spec_char.ksm : provides a way to insert a new line, a quote mark and a 
    beep into strings. This is now unnecessary and probably broken.
