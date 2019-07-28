// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_num_to_formatted_str.ks

``lib_num_to_formatted_str.ks`` provides several functions for changing numbers (scalers) into strings with specified formats

### padding

Args:

  1. A number (scaler), The number be formatted
  2. A number (scaler), The minimum number of digits to the left of the decimal point.
  3. A number (scaler), The number of digits to the right of the decimal point.
  4. A boolean,         If True there will be a space at the front of the returned string when the number to be formatted is positive
      * defaulted to True
  5. A number (scaler), Sets if function will round, floor, or ceiling the number to be formatted. 0 = rounding, 1 = floor, 2 = ceiling, NOTE: if not one of the 3 expected values cieling will be used
      * defaulted to 0

Returns:
  * a String of arg 1 formatted based on args 2,3, and 4

Description:
  * This function will return a string matching the format defined by the parameters.

#### Examples of use for padding:

    basic use
    padding(1,2,2).   // will return the string " 01.00"
    padding(-1,2,2).  // will return the string "-01.00"

    results of parameter 2
    padding(1,1,2).   // will return the string " 1.00"
    padding(-1,1,2).  // will return the string "-1.00"
    padding(10,1,2).  // will return the string " 10.00" NOTE: because the input number is larger than the minimum defined by the returned string is also longer

    results of parameter 3
    padding(1,2,1).   // will return the string " 01.0"
    padding(1.1,2,2). // will return the string " 01.10"
    padding(1.1,2,0). // will return the string " 01"    NOTE: if there are more decimal points than specified by parameter 3 then function will shorten the number using the method spesfied by parameter 5

    results of parameter 4
    padding(1,2,2,TRUE).   // will return the string " 01.00"
    padding(1,2,2,FALSE).  // will return the string "01.00"
    padding(-1,2,2,TRUE).  // will return the string "-01.00"
    padding(-1,2,2,FALSE). // will return the string "-01.00"

    results of parameter 5
	padding(1.1,2,2,TRUE,0).   // will return the string " 01.00"
	padding(1.9,2,2,TRUE,0).   // will return the string " 02.00"
	padding(1.1,2,2,TRUE,1).   // will return the string " 01.00"
	padding(1.9,2,2,TRUE,1).   // will return the string " 01.00"
	padding(1.1,2,2,TRUE,2).   // will return the string " 02.00"
	padding(1.9,2,2,TRUE,2).   // will return the string " 02.00"

### si_formatting

Args:
  1. A number (scaler), the number be formatted,  Must be with the range of 10^-24 to 10^24 or else return will not be formatted correctly 
  2. A string for the unit ("m", "m/s", "g")

Returns:
  * Returns a string in standard SI notation

Description:
  * This function will return a string formatted to match standard SI notation with 4 significant digits.

#### Examples of use for si_formatting:

    si_formatting(70000,"m").  will return the string " 70.00 km"
    si_formatting(0.1,"m").    will return the string " 100.0 mm"
    si_formatting(1000.1,"m"). will return the string " 1.000 km"
    si_formatting(500,"m/s").  will return the string " 500.0  m/s"

### time_formatting

Args:
  1. A number (scaler), The number be formatted
  2. A number (scaler), Selects type of format to be used, Range from 0 to 6
      * Defaulted to 0
  3. A number (scaler), The rounding for the seconds place, Range from 0 to 2
      * Defaulted to 0
  4. A boolean,         If True the return uses "T+" or "T-" to denote positive or negative else it will use " " or "-"
      * Defaulted to False

Returns:
  * Returns a String of arg 1 formatted based on args 2,3, and 4

Description:
  * Converts number of seconds into a 1 of 7 formatted strings for time
  * Will detect if you are using the 6 hour KSP day or the 24 hour earth day and change the day and year to match
    * For easy of calculation this function is using one year is 426 or 365 (Kerbin year or earth year).
      *  If you wish to change this look at changing the LOCAL ``FUNCTION time_converter``
      *  NOTE: you will need to keep the return the same format or else you will brake other functions

#### Examples of use for time_formatting:

    time_formatting(120).           will return the string " 02m 00s"
    time_formatting(120,0,2).       will return the string " 02m 00.00s"
    time_formatting(-120,0,2).      will return the string "-02m 00.00s"
    time_formatting(-120,0,2,true). will return the string "T- 02m 00.00s"
    time_formatting(120,0,2,true).  will return the string "T+ 02m 00.00s"

The 7 format types have different results

Formats 0,1,2 will not show higher units than are what is needed for the given input

    time_formatting(1,0).   will return the string " 01s"
    time_formatting(100,0). will return the string " 1m 40s"


    time_formatting(31536000,0). will return the string " 001y 000d 00h 00m 00s"
    time_formatting(31536000,1). will return the string " 001 Years, 000 Days, 00:00:00"
    time_formatting(31536000,2). will return the string " 001 Years, 000 Days, 00 Hours, 00 Minutes, 00 Seconds"

Format 3,4 will only display hours, minutes, and seconds,

Format 3 will truncate the length in the same way as formats 0,1,2,

Format 4 will always display the hour, minute, second places

    time_formatting(3600,3). will return the string " 01:00:00"
    time_formatting(60,3).   will return the string " 01:00"

    time_formatting(3600,4). will return the string " 01:00:00"
    time_formatting(60,4).   will return the string " 00:01:00"

Format 5,6 will display only the 2 highest units for the passed in time they also try to keep the return string the exact same length regardless of input.  Parameter 3 is set to 0 for theses formats and can't be change with out editing the code

    time_formatting(31536000,5). will return the string " 001y 000d "
    time_formatting(86400,5).    will return the string " 001d 00h  "
    time_formatting(3600,5).     will return the string " 01h  00m  "

    time_formatting(31536000,6). will return the string " 001 Years   000 Days    "
    time_formatting(86400,6).    will return the string " 001 Days    00 Hours    "
    time_formatting(3600,6).     will return the string " 01 Hours    00 Minutes  "
