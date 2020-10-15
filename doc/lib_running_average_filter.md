//Authored by space_is_hard

## lib_running_average_filter

``lib_running_average_filter.ks`` provides a function that will filter out noise from a dataset by storing a number of previous values of that dataset and outputting the average (mean) of those values. It's useful for removing noise from a dataset that is expected to remain relatively stable. It will lag behind any large or continuous changes in the dataset.

**Note: When feeding values into the filter, be sure to include a small `WAIT` command to ensure that the game has advanced at least one physics tick in between. This will prevent you from sampling the same value twice before the game can update it.**

### running_average_filter_init

args:
  * An integer - The number of historical values that should be kept and used in obtaining the average value.
  * An integer - A placeholder value that should be used to fill each index of the historical value list when it is initialized

returns:
  * A list - To be fed into the filter

description:
  * Use this function to create a list that will be input into ``running_average_filter()``

### running_average_filter

args:
  * A list - The list that we built with ``running_average_filter_init()``
  * A number - The next value to append to the list
  
returns:
  * A number
  
description:
  * Outputs the running average of the latest input value and all of the historical values in the list

---
Copyright © 2015 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).