## lib_file_exists.

``lib_file_exists.ks`` Is a means of checking for optional dependencies. Or checking whether a file exists before attempting to run it. 


### file_exists

args:
  * File name.
  
returns:
  * True or false depending on whether the file in question is on the current volume.
  
description:
  * This is intended to be used as a means to check if an attempt to run a file will succeed or fail before attempting do do so. Example uses are optional dependencies (adding options to a menu if relevant scripts are available) and checking if log files that only exist in certain events are present (can be used to pass instructions between cores or for saved variables in the event of a reboot). 

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).