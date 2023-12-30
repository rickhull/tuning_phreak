require 'tuning_phreak/temperament'
require 'minitest/autorun'

include TuningPhreak

describe Temperament do
  [nil, :equal].each { |name|
    it "converts musical notes to audio frequencies" do
      t = Temperament.new(name: name)
      a4 = t.freq('A4')
      b4 = t.freq('B4')

      expect(a4).must_equal 440.0
      expect(b4).must_be :>, a4
    end

    it "allows any frequency for A4" do
      t = Temperament.new(a4: 442, name: name)
      expect(t.freq('A4')).must_equal 442.0
      expect(t.freq('A5')).must_equal 884.0
      expect(t.freq('A3')).must_equal 221.0
    end

    it "respects octave doubling" do
      t = Temperament.new(name: name)
      c3 = t.freq('C3')
      c4 = t.freq('C4')
      c5 = t.freq('C5')

      expect(c4).must_equal c3 * 2
      expect(c5).must_equal c4 * 2
    end
  }

  describe "the 4/5 comma system" do
    it "has chromatic semitones at 5 commas wide" do
    end

    it "has diatonic semitones at 4 commas wide" do
    end

    it "has 53 commas per octave" do
    end
  end

  describe "equal temperament" do
    it "has 12 semitones of equal width" do
    end
  end
end
