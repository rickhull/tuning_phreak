require 'tuning'
require 'minitest/autorun'

describe Tuning do
  it "converts musical notes to audio frequencies" do
    t = Tuning.new
    expect(t.freq('A4')).must_equal 440.0

    t = Tuning.new(a4: 442)
    expect(t.freq('A4')).must_equal 442.0
    expect(t.freq('A5')).must_equal 884.0
    expect(t.freq('A3')).must_equal 221.0
  end
end
