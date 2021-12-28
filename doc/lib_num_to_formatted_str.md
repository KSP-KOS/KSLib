## lib_num_to_formatted_str.ks

``lib_num_to_formatted_str.ks`` provides several functions for changing numbers (scalers) into strings with specified formats

### padding
#### Description
This function will return a string matching the format defined by the parameters.


| parameter        | type    | default | description                                                                                                                                                                     |
| ---------------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| *num*            | Scalar  |         | The number to be formatted.                                                                                                                                                     |
| *leadingLength*  | Scalar  |         | The minimum number of digits to the right of the decimal point.                                                                                                                 |
| *trailingLength* | Scalar  |         | The number of digits to the right of the decimal point.                                                                                                                         |
| *leadingSpace*   | Boolean | True    | If True there will be a space at the front of the returned string when the number to be formatted is positive                                                                   |
| *roundType*      | Scalar  | 0       | Sets if function will round, floor, or ceiling the number to be formatted. 0 = rounding, 1 = floor, 2 = ceiling, NOTE: if not one of the 3 expected values the function will crash |

**Returns** A String with num formatted based on the parameters


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
	padding(1.1,2,0,TRUE,0).   // will return the string " 01"
	padding(1.9,2,0,TRUE,0).   // will return the string " 02"
	padding(1.1,2,0,TRUE,1).   // will return the string " 01"
	padding(1.9,2,0,TRUE,1).   // will return the string " 01"
	padding(1.1,2,0,TRUE,2).   // will return the string " 02"
	padding(1.9,2,0,TRUE,2).   // will return the string " 02"



### si_formatting
#### Description
This function will return a string formatted to match standard SI notation with 4 significant digits.

| parameter | type   | default | description                                                                                                                            |
| --------- | ------ | ------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| *num*     | Scalar |         | A number in the range 10^-24 to 10^24 (otherwise result will not be formatted correctly)                                               |
| *unit*    | String |         | A unit for which the [SI prefixes](https://en.wikipedia.org/wiki/Metric_prefix#List_of_SI_prefixes) will be appended ("m", "m/s", "g") |

**Returns** A String in standard SI notation with 4 significant digits


#### Examples of use for si_formatting:

    si_formatting(70000,"m").  will return the string " 70.00 km"
    si_formatting(0.1,"m").    will return the string " 100.0 mm"
    si_formatting(1000.1,"m"). will return the string " 1.000 km"
    si_formatting(500,"m/s").  will return the string " 500.0  m/s"



### time_formatting
#### Description
This function will return a time string formatted according to the following rules:
  * Converts number of seconds into one of seven different time formats
  * Will detect if you are using the 6 hour KSP day or the 24 hour Earth day and change the day and year to match
    * For ease of calculation this function defines 1 year as 426 Kerbin days or 365 Earth days.
      * If you with to change this consider modifying `FUNCTION time_converter`
      * NOTE: you will need to keep the return the same format or else you will break other functions

| parameter    | type    | default    | description                                                                     |
| ------------ | ------- | ---------- | ------------------------------------------------------------------------------- |
| *timeSec*    | Scalar  |            | The number to be formatted                                                      |
| *formatType* | Scalar  |            | Selects type of format to be used, Range from 0 to 6                            |
| *rounding*   | Scalar  | 0          | The rounding used for the seconds place, Range from 0 to 2                      |
| *prependT*   | Boolean | False      | If True prepend "T± " to the format ("T  " if positive and *showPlus* is False) |
| *showPlus*   | Boolean | *prependT* | If True positive values will show "+", otherwise " "                            |

**Returns** A String with *timeSec* formatted based on the parameters


#### Examples of use for time_formatting:

    time_formatting(120).                 will return the string " 02m 00s"
    time_formatting(120,0,2).             will return the string " 02m 00.00s"
    time_formatting(-120,0,1).            will return the string "-02m 00.0s"
    time_formatting(-120,0,0,true).       will return the string "T- 02m 00s"
    time_formatting(120,0,2,true).        will return the string "T+ 02m 00.00s"
    time_formatting(120,0,1,false,true).  will return the string "+02m 00.0s"
    time_formatting(120,0,0,false,false). will return the string " 02m 00s"

The 7 format types have different results

Formats 0,1,2 will not show higher units than are what is needed for the given input

    time_formatting(1,0).   will return the string " 01s"
    time_formatting(100,0). will return the string " 01m 40s"


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

---
Copyright © 2019,2020,2021 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).