# Tuning Phreak

## aka Tuning Freq(uency)

This library provides some routines to determine the proper audio frequency
for a given musical note.  The proper frequency depends greatly on tuning
systems and so-called temperaments, as well as a reference frequency for some
baseline note in any system.

## The Gist

A piano keyboard.  "Middle C" is `C4`, 4 octaves above `C0`.  `CDEFGAB` gives
the C Major scale.  `C5` is one octave above `C4`.  The audio frequency of
`C5`, given in Hz (Hertz, or cycles per second), is twice that of `C4`.

Given a reference note and a reference frequency, like `A4 = 440 Hz`, we can
construct a tuning system that will provide useful frequencies for different
musical notes.  Certain important musical intervals, like thirds, fourths,
fifths, and octaves, will sound "good" in these systems, with some objective,
mathematical sense of "good" that lends itself to comparison.  Some systems
sound better than others in different situations.  There will be tradeoffs.
