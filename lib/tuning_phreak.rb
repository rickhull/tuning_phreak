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
end
