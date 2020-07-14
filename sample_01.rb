# 引数をとった音源に対して、波形を描画します。
# 横軸：時間
# 縦軸：大きさ

require 'open3'
require 'ruby-sox'
require_relative 'lib/plotter'

dat_file_name = 'tmp/files/sample_01.dat'
Sox::Cmd.new.add_input(ARGV[0]).set_output(dat_file_name).run

sound_data = File.read(dat_file_name)
                 .split("\n")[2..-1]
                 .map { |row| row.split.map(&:to_f) }
                 .map { |r| r.first(2) }
plot_params = {
  image_name:   'tmp/gnuplot/waveform.png',
  title:        'sound',
  x_axis_title: 'Time, s',
  y_axis_title: '.wav signal'
}

plotter = GNUPlotter.new(sound_data, plot_params)
plotter.plot
