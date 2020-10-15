# Purpose: library_ksm folder
This folder **must not** contain files people can compile locally from .ks files of your library. It is only for files made or modified by external programs to allow stuff that isn't possible in Kerboscript but is possible in opcode. It is **highly recommended** to minimize the amount of code placed in here because:
* Backwards compatibility for .ksm files is not guarantied (e.g. some significant parser changes might break all old .ksm files).
* It is a lot more difficult to modify and improve .ksm files when compared to .ks scripts.

---
Copyright © 2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).