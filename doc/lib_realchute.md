## lib_realchute

``lib_realchute.ks`` can be used to activate chutes when using the RealChute mod.

### R_chutes

args:
  * string.
   * ``Arm parachute"``
   * ``Disarm parachute"``
   * ``Deploy chute``
   * ``Cut chute``

returns:
  * deployed chutes.
  
description:
  * This lets you use ``R_chutes("deploy chute").`` similar to how you would use ``Chutes on.``
    * Note: This will obey any rules that realchute sets for these chutes eg. they wont deploy on the way up if you have ticked ``Must go down to deploy``.

---
Copyright © 2015,2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).