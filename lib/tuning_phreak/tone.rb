require 'tuning_phreak'

module TuningPhreak
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
