require 'tuning_phreak/temperament'
require 'tuning_phreak/diatonic'

include TuningPhreak

commas = Temperament.new(system: :commas)
semitones = Temperament.new(system: :semitones)

notes = {
  a: {
    second: :b,
    minor_third: :c,
    major_third: :c_sharp,
    fourth: :d,
    fifth: :e,
    minor_sixth: :f,
    major_sixth: :f_sharp,
    minor_seventh: :g,
    major_seventh: :g_sharp,
  },

  c: {
    second: :d,
    minor_third: :e_flat,
    major_third: :e,
    fourth: :f,
    fifth: :g,
    minor_sixth: :a_flat,
    major_sixth: :a,
    minor_seventh: :b_flat,
    major_seventh: :b,
  },
}

octave_num = 4

notes.each { |root, intervals|
  puts
  puts "Key: #{root.upcase}"
  puts "==="
  diatonic = Diatonic.new(scale: root)

  diatonic_root = diatonic.frequency(root, octave_num)
  commas_root = commas.frequency(root, octave_num)
  semitones_root = semitones.frequency(root, octave_num)

  commas_points = 0
  semitones_points = 0

  ddiff = diatonic_root - diatonic_root
  cdiff = commas_root - diatonic_root
  sdiff = semitones_root - diatonic_root

  dpct = 100.0 * diatonic_root / diatonic_root
  cpct = 100.0 * commas_root / diatonic_root
  spct = 100.0 * semitones_root / diatonic_root

  puts format("%s\t(%s)", root, 'root')
  puts '---'
  puts format(" Diatonic: %.3f Hz\t   %.1f Hz\t %.1f%%",
              diatonic_root, ddiff, dpct)
  puts format("   Commas: %.3f Hz\t   %.1f Hz\t %.1f%%",
              commas_root, cdiff, cpct)
  puts format("Semitones: %.3f Hz\t   %.1f Hz\t %.1f%%",
              semitones_root, sdiff, spct)
  puts

  intervals.each { |type, key|
    # account for B3 - C4 increment
    onum = if root == :a and /\A[c-g]/.match(key)
             octave_num + 1
           else
             octave_num
           end

    df = diatonic.frequency(key, onum) rescue 0
    cf = commas.frequency(key, onum)
    sf = semitones.frequency(key, onum)

    ddiff = (df - df).abs
    cdiff = (cf - df).abs
    sdiff = (sf - df).abs

    dpct = 100.0 * df / diatonic_root
    cpct = 100.0 * cf / commas_root.to_f
    spct = 100.0 * sf / semitones_root.to_f

    dpoints = (dpct - dpct).abs
    cpoints = (cpct - dpct).abs
    spoints = (spct - dpct).abs

    commas_points += cpoints
    semitones_points += spoints

    puts format("%s\t(%s)", key, type)
    puts '---'
    puts format(" Diatonic: %.3f Hz \t %.3f%% \t %.3f \t %.1f Hz",
                df, dpct, dpoints, ddiff)
    puts format("   Commas: %.3f Hz \t %.3f%% \t %.3f \t %.1f Hz",
                cf, cpct, cpoints, cdiff)
    puts format("Semitones: %.3f Hz \t %.3f%% \t %.3f \t %.1f Hz",
                sf, spct, spoints, sdiff)
    puts
  }

  puts "Error relative to pure diatonic intervals:"
  puts "---"
  puts format("   Commas: %.3f percentage points per octave", commas_points)
  puts format("Semitones: %.3f percentage points per octave", semitones_points)
  puts
}
