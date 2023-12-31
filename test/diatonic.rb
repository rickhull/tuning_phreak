require 'tuning_phreak/diatonic'
require 'minitest/autorun'

include TuningPhreak

describe Diatonic do
  it "uses whole number ratios to describe perfect intervals" do
    d = Diatonic.new(a4: 440, scale: :c)
    c4 = d.freq('C4')
    e4 = d.freq('E4')
    f4 = d.freq('F4')
    g4 = d.freq('G4')
    a4 = d.freq('A4')

    expect(a4).must_equal 440.0
    expect(e4 / c4).must_equal Diatonic::C.fetch(:e)
    expect(f4 / c4).must_equal Diatonic::C.fetch(:f)
    expect(g4 / c4).must_equal Diatonic::C.fetch(:g)
  end

  it "determines the frequency of any white key on a piano" do
    d = Diatonic.new(a4: 440, scale: :a)
    prior = 0
    %w[C4 D4 E4 F4 G4 A4 B4].each { |wk|
      freq = d.freq(wk)
      expect(freq).must_be_kind_of Numeric
      expect(freq).must_be :>=, 0
      expect(freq).must_be :<, 50_000
      expect(freq).must_be :>, prior
      prior = freq
    }
  end

  [:c, :a].each { |scale|
    it "accepts any value for the frequency of A4" do
      d = Diatonic.new(a4: 440, scale: scale)
      expect(d.freq('A4')).must_equal 440.0
      expect(d.freq('A5')).must_equal 880.0

      d = Diatonic.new(a4: 500, scale: scale)
      expect(d.freq('A4')).must_equal 500.0
      expect(d.freq('A3')).must_equal 250.0
    end
  }

  it "determines some sharps and flats based on minor and major intervals" do
    # we know C minor and A major, based purely on interval analysis
    c_minor = [:c, :d, :e_flat, :f, :g, :a_flat, :b_flat]
    a_major = [:a, :b, :c_sharp, :d, :e, :f_sharp, :g_sharp]

    # get every frequency for C Minor
    d = Diatonic.new(a4: 440, scale: :c)
    c_minor.each { |note|
      expect(d.frequency(note, 4)).must_be_kind_of Numeric
    }

    expect(d.frequency(:e_flat, 4)).must_be :<, d.frequency(:e, 4)
    expect(d.frequency(:a_flat, 5)).must_be :<, d.frequency(:a, 5)
    expect(d.frequency(:b_flat, 2)).must_be :<, d.frequency(:b, 2)

    # get every frequency for A Major
    d = Diatonic.new(a4: 441, scale: :a)
    a_major.each { |note|
      expect(d.frequency(note, 3)).must_be_kind_of Numeric
    }
  end
end
