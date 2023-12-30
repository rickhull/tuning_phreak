require 'tuning_phreak'

module TuningPhreak
  class Diatonic
    C_MAJOR = {
      c: 1/1r,
      d: 9/8r,
      e: 5/4r,
      f: 4/3r,
      g: 3/2r,
      a: 5/3r,
      b: 15/8r,
      octave: 2/1r,
    }

    A_MINOR = {
      a: 1/1r,
      b: 9/8r,
      c: 6/5r,
      d: 4/3r,
      e: 3/2r,
      f: 8/5r,
      g: 9/5r,
      octave: 2/1r,
    }

    MAJOR_THIRD = C_MAJOR.fetch(:e)
    MINOR_THIRD = A_MINOR.fetch(:c)

    PERFECT_FOURTH = C_MAJOR.fetch(:f)
    PERFECT_FIFTH = C_MAJOR.fetch(:g)

    MINOR_SIXTH = A_MINOR.fetch(:f)
    MAJOR_SIXTH = C_MAJOR.fetch(:a)

    MINOR_SEVENTH = A_MINOR.fetch(:g)
    MAJOR_SEVENTH = C_MAJOR.fetch(:b)

    # we can fill in some black keys
    # this ends up defining the key signature for C-minor and A-major
    C_MAJOR[:e_flat] = MINOR_THIRD
    C_MAJOR[:a_flat] = MINOR_SIXTH
    C_MAJOR[:b_flat] = MINOR_SEVENTH
    A_MINOR[:c_sharp] = MAJOR_THIRD
    A_MINOR[:f_sharp] = MAJOR_SEVENTH
    A_MINOR[:g_sharp] = MAJOR_SEVENTH

    MINOR_PENTATONIC = [1, MINOR_THIRD,
                        PERFECT_FOURTH, PERFECT_FIFTH,
                        MINOR_SEVENTH]

    attr_reader :a4, :c4, :scale, :fundamental

    def initialize(a4: A4, scale: :c_major)
      @a4 = a4
      @c4 = @a4 * A_MINOR.fetch(:c) / 2 # a4 to c5 back down to c4
      # alternatively:
      # @c4 = 1 / C_MAJOR.fetch(:a)

      case scale
      when :a_minor
        @scale = A_MINOR
        @fundamental = @a4
      when :c_major
        @scale = C_MAJOR
        @fundamental = @c4
      else
        raise(BadValue, scale.inspect)
      end
    end

    def frequency(note_sym, octave_num)
      raise(BadValue, note_sym.inspect) unless @scale.key?(note_sym)
      # below C4 is B3, not B4
      if @fundamental == @a4 and ![:a, :b].include?(note_sym)
        octave_num -= 1
      end
      @fundamental *
        @scale.fetch(note_sym) *
        @scale.fetch(:octave) ** (octave_num - 4)
    end

    def freq(note_str)
      note_sym, octave_num = TuningPhreak.parse(note_str)
      self.frequency(note_sym, octave_num)
    end
  end
end
