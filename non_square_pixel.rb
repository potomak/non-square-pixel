require 'bundler'

Bundler.setup
Bundler.require

include Magick

puts "non square pixel"

images = ImageList.new('images/test_1.jpg', 'images/test_2.png')

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
  end

  Image.constitute(cols*3, rows*3, "RGB", pixels).write("images/non_square_#{File.basename(image.filename)}.png")
end

puts "done"