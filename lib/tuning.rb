class Tuning
  # Hz; just a default; provide via e.g. Tuning#new(a4: 442)
  A4 = 440

  # this is premised upon the definition chromatic and diatonic semitones:
  # chromatic semitone (A - A#) = 5 commas
  # diatonic  semitone (A - Bb) = 4 commas
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

  # accepts: A4, E0, Ab3, E#2, etc; rejects: a4, bb2, asdf
  NOTE_PATTERN = /\A([A-G])([#b])?(\d+)\z/

  def self.temperament(sym = nil)
    case sym
    when nil
      COMMAS
    when :equal
      EQUAL_SEMITONES
    else
      raise "unexpected: #{sym.inspect}"
    end
  end

  # returns: [:a_sharp, 4], [:b, 0], [:d_flat, 9]
  def self.parse(note_str)
    matches = NOTE_PATTERN.match(note_str) or raise("unexpected: #{note_str}")
    note = matches[1].downcase
    if matches[2]
      # sharp or flat
      sym = case matches[2]
            when '#'
              (note + '_sharp').to_sym
            when 'b'
              (note + '_flat').to_sym
            else
              raise "unexpected: #{matches[2]}"
            end
    else
      sym = note.to_sym
    end
    [sym, matches[3].to_i]
  end

  def self.freq(note_sym, octave_num, a4: A4, temperament: nil)
    # below C4 is B3, not B4
    adjusted_octave = /\A[c-g]/.match(note_sym) ? octave_num - 1 : octave_num
    temperament = Tuning.temperament(temperament)
    octave = temperament.fetch(:octave) # 53 commas? 12 semitones?
    commas = temperament.fetch(note_sym) + (adjusted_octave - 4) * octave
    a4 * 2 ** (commas.to_f / octave)
  end

  def initialize(a4: A4, temperament: nil)
    @a4 = a4
    @temperament = temperament
  end

  def freq(note_str)
    note_sym, octave_num = Tuning.parse(note_str)
    Tuning.freq(note_sym, octave_num, a4: @a4, temperament: @temperament)
  end
end





# 6 tones, 12 semitones
# no frequencies considered

class Tone
  SEMITONE = 1/2r

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

  def sharp
    @baseline + SEMITONE
  end
  alias_method :s, :sharp
end

A = Tone.new(0)
B = Tone.new(1)   # semitone from B to C
C = Tone.new(1.5)
D = Tone.new(2.5)
E = Tone.new(3.5) # semtione from E to F
F = Tone.new(4)
G = Tone.new(5)
