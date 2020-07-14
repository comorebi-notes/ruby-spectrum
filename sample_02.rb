# 引数をとった音源に対して、スペクトル解析した結果を描画します。
# 横軸：周波数
# 縦軸：大きさ

require 'open3'
require 'numo/narray'
require 'numo/fftw'
require 'ruby-sox'
require_relative 'lib/plotter'

def read_channel_data(filename, channel_number)
  data = File.read(filename).split("\n")[2..-1].map { |row| row.split.map(&:to_f) }
  duration = data.last[0]
  signal = data.map { |r| r[channel_number] }

  [signal, duration]
end

def calculate_fft(signal, duration, max_points = 3000)
  na = Numo::NArray[signal]
  fc = Numo::FFTW.dft(na, -1)

  fc.real.to_a.flatten.first(na.length / 2).first(max_points).each_with_index.map do |val, index|
    [index / duration, val.abs]
  end
end

dat_file_name = 'tmp/files/sample_02.dat'
Sox::Cmd.new.add_input(ARGV[0]).set_output(dat_file_name).run

signal, duration = read_channel_data(dat_file_name, 1)
spectrum = calculate_fft(signal, duration)

max_frequency = spectrum.sort_by(&:last).last.first.round(2)

spectrum_plot_params = {
  image_name:   'tmp/gnuplot/spectrum.png',
  title:        "spectrum #{max_frequency}Hz",
  x_axis_title: 'Frequency, Hz',
  y_axis_title: 'Magnitude'
}

plotter = GNUPlotter.new(spectrum, spectrum_plot_params)
plotter.plot
