require 'bundler'
require 'progressbar'

Bundler.setup
Bundler.require

include Magick

puts "non square pixel"

images = ImageList.new(*Dir['images/[^non_square]*.{png,jpg}'])

image_average_weight = images.to_a.reduce(0) {|s, i| s + (i.columns * i.rows)/images.size}
puts "image_average_weight: #{image_average_weight}"

progress = ProgressBar.new("working", images.to_a.reduce(0) {|s, i| s + (i.columns * i.rows)} + (images.size*image_average_weight))
progress.bar_mark = '#'

images.each do |image|
  rows = image.rows
  cols = image.columns
  pixels = []

  rows.times do |i|
    3.times do |n|
      cols.times do |j|
        pixel = image.pixel_color(j, i)

        pixels << pixel.red
        pixels << 0
        pixels << 0

        pixels << 0
        pixels << pixel.green
        pixels << 0

        pixels << 0
        pixels << 0
        pixels << pixel.blue
      end
    end

    progress.inc(cols)
  end

  # constitute image from pixels array
  new_image = Image.constitute(cols*3, rows*3, "RGB", pixels)
  progress.inc(image_average_weight/3)

  # more brightness
  new_image = new_image.modulate(1.5)
  progress.inc(image_average_weight/3)

  # write image file
  new_image.write("images/non_square_#{File.basename(image.filename)}.png")
  progress.inc(image_average_weight/3)
end

progress.finish

puts "done"