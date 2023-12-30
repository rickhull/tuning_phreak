module TuningPhreak
  class BadValue < RuntimeError; end

  # Hz; just a default; provide via e.g. Temperament.new(a4: 442)
  A4 = 440

  # accepts: A4, E0, Ab3, E#2
  # rejects: a4, bb2, As4, Bf6
  NOTE_PATTERN = /\A([A-G])([#b])?(\d+)\z/

  # returns e.g.: [:a_sharp, 4], [:b, 0], [:d_flat, 9], etc
  def self.parse(note_str)
    matches = NOTE_PATTERN.match(note_str) or raise(BadValue, note_str.inspect)
    note = matches[1].downcase
    if matches[2]
      # sharp or flat
      sym = case matches[2]
            when '#'
              (note + '_sharp').to_sym
            when 'b'
              (note + '_flat').to_sym
            else
              raise(BadValue, matches[2].inspect)
            end
    else
      sym = note.to_sym
    end
    [sym, matches[3].to_i]
  end

  class Temperament
    # this is premised upon the definition chromatic and diatonic semitones:
    # chromatic semitone (A - A#) = 5 commas
    # diatonic  semitone (A - Bb) = 4 commas
    # an octave is 5 tones and 2 semitones, aka 12 semitones
    # 5 chromatic semitones and 7 diatonic semitones
    # 5*5 + 7*4 = 53 commas per octave
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

    # here we have 12 semitones of equal width
    # this provides equal temperament tuning
    # note that e.g. b_flat and a_sharp are defined to be the same
    # this matches how a piano is laid out
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

    def self.structure(name = nil)
      case name
      when nil
        COMMAS
      when :equal
        EQUAL_SEMITONES
      else
        raise(BadValue, name.inspect)
      end
    end

    def self.frequency(note_sym, octave_num, a4: A4, name: nil)
      # below C4 is B3, not B4
      adjusted_octave = /\A[c-g]/.match(note_sym) ? octave_num - 1 : octave_num
      structure = self.structure(name)
      octave = structure.fetch(:octave) # 53 commas? 12 semitones?
      commas = structure.fetch(note_sym) + (adjusted_octave - 4) * octave
      a4 * 2 ** (commas.to_f / octave)
    end

    attr_reader :a4, :name

    def initialize(a4: A4, name: nil)
      @a4 = a4
      @name = name
    end

    def freq(note_str)
      note_sym, octave_num = TuningPhreak.parse(note_str)
      self.frequency(note_sym, octave_num)
    end

    def frequency(note_sym, octave_num)
      Temperament.frequency(note_sym, octave_num, a4: @a4, name: @name)
    end
  end

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

    attr_reader :a4, :c4, :scale, :fundamental

    def initialize(a4: A4, scale: :c_major)
      @a4 = a4
      @c4 = @a4 * A_MINOR.fetch(:c) / 2 # a4 to c5 back down to c4
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

  # 6 tones, 12 semitones
  # no frequencies considered
  # this is not used, just a spike
  class Tone
    SEMITONE = 1/2r

    attr_reader :baseline

    def initialize(baseline)
      @baseline = baseline.to_r
    end

    def flat
      @baseline - SEMITONE
    end
    alias_method :f, :flat

    def natural
      @baseline
    end
    alias_method :n, :natural
    alias_method :b, :baseline

    def sharp
      @baseline + SEMITONE
    end
    alias_method :s, :sharp

    A = self.new(0)
    B = self.new(1)   # semitone from B to C
    C = self.new(1.5)
    D = self.new(2.5)
    E = self.new(3.5) # semitone from E to F
    F = self.new(4)
    G = self.new(5)

    OCTAVE = 6

    Do = self.new(0)
    Re = self.new(1)
    Mi = self.new(2)   # semitone from Mi to Fa
    Fa = self.new(2.5)
    So = self.new(3.5)
    La = self.new(4.5)
    Ti = self.new(5.5) # semitone from Ti to Do
  end
end
