require 'tuning_phreak'

module TuningPhreak
  class Diatonic
    # only C major here; white keys
    C = {
      c: 1/1r,
      d: 9/8r,
      e: 5/4r,
      f: 4/3r,
      g: 3/2r,
      a: 5/3r,
      b: 15/8r,
      octave: 2/1r,
    }

    # only A minor here; white keys
    A = {
      a: 1/1r,
      b: 9/8r,
      c: 6/5r,
      d: 4/3r,
      e: 3/2r,
      f: 8/5r,
      g: 9/5r,
      octave: 2/1r,
    }

    MAJOR_THIRD = C.fetch(:e)
    MINOR_THIRD = A.fetch(:c)

    PERFECT_FOURTH = C.fetch(:f)
    PERFECT_FIFTH = C.fetch(:g)

    MINOR_SIXTH = A.fetch(:f)
    MAJOR_SIXTH = C.fetch(:a)

    MINOR_SEVENTH = A.fetch(:g)
    MAJOR_SEVENTH = C.fetch(:b)

    # we can fill in some black keys
    # this ends up defining the key signature for C-minor and A-major
    C[:e_flat] = MINOR_THIRD
    C[:a_flat] = MINOR_SIXTH
    C[:b_flat] = MINOR_SEVENTH
    A[:c_sharp] = MAJOR_THIRD
    A[:f_sharp] = MAJOR_SEVENTH
    A[:g_sharp] = MAJOR_SEVENTH

    MINOR_PENTATONIC = [1, MINOR_THIRD,
                        PERFECT_FOURTH, PERFECT_FIFTH,
                        MINOR_SEVENTH]

    # just a default; override with Diatonic.new
    SCALE = :c

    attr_reader :a4, :c4, :scale, :root

    def initialize(a4: A4, scale: SCALE)
      @a4 = a4
      @c4 = @a4 * A.fetch(:c) / 2 # a4 to c5 back down to c4
      # alternatively:
      # @c4 = 1 / C.fetch(:a)

      case scale
      when :a
        @scale = A
        @root = @a4
      when :c
        @scale = C
        @root = @c4
      else
        raise(BadValue, scale.inspect)
      end
    end

    def frequency(note_sym, octave_num = 4)
      raise(BadValue, note_sym.inspect) unless @scale.key?(note_sym)
      # below C4 is B3, not B4
      if @root == @a4 and ![:a, :b].include?(note_sym)
        octave_num -= 1
      end
      @root *
        @scale.fetch(note_sym) *
        @scale.fetch(:octave) ** (octave_num - 4)
    end

    def freq(note_str)
      note_sym, octave_num = TuningPhreak.parse(note_str)
      self.frequency(note_sym, octave_num)
    end
  end
end
