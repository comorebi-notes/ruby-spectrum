# 引数をとった音源に対して、スペクトル解析した動画を生成します。
# 横軸：周波数
# 縦軸：大きさ

require 'open3'
require 'numo/narray'
require 'numo/fftw'
require 'ruby-sox'
require 'amazing_print'
require_relative 'lib/plotter'

FPS = 24
BUFFER_SIZE = 44100 / FPS

def read_channel_data(filename, channel_number)
  data = File.read(filename).split("\n")[2..-1].map { |row| row.split.map(&:to_f) }
  data.each_slice(BUFFER_SIZE).map { |data_unit| [data_unit.map { |r| r[channel_number] }, data_unit.first[0], data_unit.last[0]] }
end

def calculate_fft(signal, duration, max_points = 3000)
  na = Numo::NArray[signal]
  fc = Numo::FFTW.dft(na, 1)

  fc.real.to_a.flatten.first(na.length / 2).first(max_points).each_with_index.map do |val, index|
    [index / duration, val.abs]
  end
end

puts 'Converting WAV file to DAT file...'

dat_file_name = 'tmp/files/sample_03.dat'
Sox::Cmd.new.add_input(ARGV[0]).set_output(dat_file_name).run

data = read_channel_data(dat_file_name, 1)

data.each_with_index do |data_unit, index|
  puts "#{index} / #{data.size}"
  signal = data_unit[0]
  duration = data_unit[2] - data_unit[1]

  spectrum = calculate_fft(signal, duration)
  # max_frequency = spectrum.sort_by(&:last).last.first.round(2)

  spectrum_plot_params = {
    image_name: "tmp/gnuplot/spectrum_#{'%04d' % index}.png",
    title: "spectrum (#{data_unit[1].ceil(2)} - #{data_unit[2].ceil(2)}s)"
  }

  plotter = GNUPlotter.new(spectrum, spectrum_plot_params, 4096, 192)
  plotter.plot
end

puts 'Converting PNG files to GIF Animation...'
system 'convert -delay 10 -loop 0 tmp/gnuplot/spectrum_*.png tmp/gnuplot/spectrum.gif'

system "ffmpeg -r #{FPS} -i tmp/gnuplot/spectrum.gif -movflags faststart -pix_fmt yuv420p -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' tmp/gnuplot/spectrum.tmp.mp4"
system "ffmpeg -i tmp/gnuplot/spectrum.tmp.mp4 -i #{ARGV[0]} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 tmp/gnuplot/spectrum#{Time.now.strftime("%Y%m%d%H%M%S")}.mp4"

system 'rm tmp/gnuplot/spectrum_*.png'
system 'rm tmp/gnuplot/spectrum.gif'
system 'rm tmp/gnuplot/spectrum.tmp.mp4'
