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

## Pianos

Pianos traditionally have 12 "keys"
(a piano key -- as opposed to a musical key -- is a physical button or lever
which triggers a unique note) or notes per octave.
Of those 12 piano keys, 7 are white, and 5 are black,
laid out in a particular pattern.
The pattern is tangentially important, but what is more important is that
these 12 keys provide a simple ordering.
In 99% of all uses of a piano, we just need a 12 step simple ordering.

### 12 Steps?

These 12 steps can be referred to mainly as "semitones" but also sometimes as
"half steps".
A "whole step" always refers to exactly two "half steps".
A "tone" is always composed of exactly two "semitones".
"Tones" and "steps" may be used somewhat interchangeably, but keep in mind
that "tone" is more of theoretical term, while "step" is more of a pedogogical
term.
We will prefer "tone".

### Semitones

So technically we have 12 semitones, or half-steps, which correspond, roughly,
to 6 tones.  7 white keys and 5 black keys.  One complication is that we can,
but don't have to, distinguish between two types of semitones:

* Chromatic semitone: a semitone "within a note" (e.g. A to A-sharp)
* Diatonic semitone: a semitone "across two different notes" (e.g. A to B-flat)

In this view, a tone is defined as a chromatic semitone plus a diatonic
semitone.  Similarly to how a piano has 7 white keys and 5 black keys, an
octave has 7 diatonic and 5 chromatic semitones.  Since there is an imbalance,
we can only match 5 chromatic semitones to 5 diatonic semitones, we can think
of an octave as 5 tones plus two diatonic semitones.
