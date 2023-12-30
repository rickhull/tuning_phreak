require 'tuning_phreak'
require 'minitest/autorun'

describe TuningPhreak do
  it "defines a default for A4's frequency" do
    expect(TuningPhreak::A4).must_be_kind_of Numeric
  end

  it "defaults to A4 = 440 Hz" do
    expect(TuningPhreak::A4).must_equal 440
  end

  it "parses note strings like: C#3" do
    note_sym, octave_num = TuningPhreak.parse('C#3')
    expect(note_sym).must_equal :c_sharp
    expect(octave_num).must_equal 3

    note_sym, octave_num = TuningPhreak.parse('Bb7')
    expect(note_sym).must_equal :b_flat
    expect(octave_num).must_equal 7

    note_sym, octave_num = TuningPhreak.parse('C0')
    expect(note_sym).must_equal :c
    expect(octave_num).must_equal 0
  end

  it "rejects note strings like: bb4 or Bf4" do
    expect { TuningPhreak.parse 'bb4' }.must_raise
    expect { TuningPhreak.parse 'Bf4' }.must_raise
  end
end
