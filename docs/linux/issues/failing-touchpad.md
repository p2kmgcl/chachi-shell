# Failing touchpad

My touchpad is failing sometimes, it is detected as a _regular_ mouse with no
multitouch support and no _disable while typing_ features. This last thing is
specially annoying when I need to use the laptop keyboard, because I
accidentally click on random places while writing.

At the moment, the only temporary “solutions” I have are:

- Suspend and wake up system, which for some reason fixes the problem.
- Using `xinput` and `xinput --disable [ID]` to disable touchpad.
