require 'tuning_phreak'

module TuningPhreak
  class Temperament
    # This is premised upon the definition chromatic and diatonic semitones:
    #   Chromatic semitone (A - A#) = 5 commas
    #   Diatonic  semitone (A - Bb) = 4 commas
    # An octave is 5 tones and 2 semitones, aka 12 semitones
    #   5 chromatic semitones and 7 diatonic semitones
    #   5*5 + 7*4 = 53 commas per octave
    COMMAS = {
      a_flat: -5,  # chromatic -5
      a: 0,
      b_flat: 4,   # diatonic  +4
      a_sharp: 5,  # chromatic +5
      b: 9,        # +9 = 9
      c: 13,       # diatonic  +4 = 13
      d_flat: 17,  # diatonic  +4
      c_sharp: 18, # chromatic +5
      d: 22,       # +9 = 22
      e_flat: 26,  # diatonic  +4
      d_sharp: 27, # chromatic +5
      e: 31,       # diatonic  +4 = 31
      f: 35,       # diatonic  +4 = 35
      g_flat: 39,  # diatonic  +4
      f_sharp: 40, # chromatic +5
      g: 44,       # diatonic  +4 = 44
      g_sharp: 49, # chromatic +5
      octave: 53,  # diatonic  +4 = 53
    }

    # Here we have 12 semitones of equal width aka Equal Temperament
    # Note that e.g. b_flat and a_sharp are defined to be the same
    # This matches how a piano is laid out
    EQUAL_SEMITONES = {
      a_flat: -1,
      a: 0,
      b_flat: 1,
      a_sharp: 1,
      b: 2,
      c: 3,
      d_flat: 4,
      c_sharp: 4,
      d: 5,
      e_flat: 6,
      d_sharp: 6,
      e: 7,
      f: 8,
      g_flat: 9,
      f_sharp: 9,
      g: 10,
      g_sharp: 11,
      octave: 12,
    }

    # just a default
    SYSTEM = :semitones # Equal Temperament

    def self.structure(system)
      case system
      when :commas
        COMMAS
      when :equal, :semitones
        EQUAL_SEMITONES
      else
        raise(BadValue, system.inspect)
      end
    end

    def self.frequency(note_sym, octave_num, a4: A4, system: SYSTEM)
      # below C4 is B3, not B4
      adjusted_octave = /\A[c-g]/.match(note_sym) ? octave_num - 1 : octave_num
      structure = self.structure(system)
      octave = structure.fetch(:octave) # 53 commas? 12 semitones?
      commas = structure.fetch(note_sym) + (adjusted_octave - 4) * octave
      a4 * 2 ** (commas.to_f / octave)
    end

    attr_reader :a4, :system

    def initialize(a4: A4, system: SYSTEM)
      @a4 = a4
      @system = system
    end

    def freq(note_str)
      note_sym, octave_num = TuningPhreak.parse(note_str)
      self.frequency(note_sym, octave_num)
    end

    def frequency(note_sym, octave_num)
      Temperament.frequency(note_sym, octave_num, a4: @a4, system: @system)
    end
  end
end
