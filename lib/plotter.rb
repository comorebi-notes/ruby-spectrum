class GNUPlotter < Struct.new(:data, :params, :xrange, :yrange)
  def plot
    Open3.capture2('gnuplot', stdin_data: gnuplot_commands, binmode: true)
    # system "open #{params[:image_name]}"
  end

  private

  def gnuplot_commands
    commands = %(
      set terminal png font "/Library/Fonts/Arial.ttf" 14
      set title "#{params[:title]}"
      set xrange [0:#{xrange}]
      set yrange [0:#{yrange}]
      set xlabel "#{params[:x_axis_title]}"
      set ylabel "#{params[:y_axis_title]}"
      set output "#{params[:image_name]}"
      set key off
      plot "-" with lines lw 2 lt rgb 'red'
    )

    data.each do |x, y|
      commands << "#{x} #{y}\n"
    end

    commands << "e\n"
  end
end
