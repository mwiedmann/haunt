# TODO List

Now that the line of sight is handled on L0, a few things are broken

- Draw guy
- When x/y start pos is negative, it draws junk to screen. I think the starting drawing location is correct for these (I have code to start them near the bottom of map as it wraps), but when it reaches bottom it has to wrap back to the top.
- When drawing goes beyond the bottom it probably is wrong as well