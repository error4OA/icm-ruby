require 'optparse'
require 'net/http'
require 'json'
require 'clipboard'
require 'emojis'

lookalikes = JSON.parse(Net::HTTP.get(URI('https://gist.githubusercontent.com/StevenACoffman/a5f6f682d94e38ed804182dc2693ed4b/raw/fa2ed09ab6f9b515ab430692b588540748412f5f/some_homoglyphs.json')))
leet_dict = {
  'A' => '4', 'a' => '4', 'B' => '8', 'b' => '8', 'E' => '3', 'e' => '3', 'G' => '6', 'g' => '6', 'I' => '1', 'i' => '1',
  'O' => '0', 'o' => '0', 'S' => '5', 's' => '5', 'T' => '7', 't' => '7', 'Z' => '2', 'z' => '2',
  'C' => '(', 'c' => '(', 'D' => '|)', 'd' => '|)', 'F' => '|=', 'f' => '|=', 'H' => '#', 'h' => '#', 'K' => '|<', 'k' => '|<',
  'L' => '1', 'l' => '1', 'M' => '|\\/|', 'm' => '|\\/|', 'N' => '|\\|', 'n' => '|\\|', 'P' => '|*', 'p' => '|*', 'Q' => '(,)',
  'q' => '(,)', 'R' => '|2', 'r' => '|2', 'U' => '|_|', 'u' => '|_|', 'V' => '\\/', 'v' => '\\/', 'W' => '\\/\\/', 'w' => '\\/\\/',
  'X' => '><', 'x' => '><', 'Y' => '`/', 'y' => '`/'
}

options = {}

puts "ICM Ruby version\nMade by: podemb\nVersion: beta1"

OptionParser.new do |parser|
  parser.on('--text [TEXT]', 'The text to use') do |text_param|
    options[:text] = text_param || "podemb"
  end
  parser.on('--emoji [EMOJI]', 'The emoji to use; this doesnt use the same library as the python version') do |emoji_param|
    options[:emoji] = emoji_param.to_sym || :cat_head
  end
  parser.on('--style [STYLE_NUMBER]', 'The style to use') do |style_param|
    options[:style] = style_param.to_i
  end
  parser.on('--debug', 'Enable debug output if passed; only use this if you are messing with this script') do
    options[:debug] = true
  end
  parser.on('--text-style [TEXT_STYLE_NUMBER]', 'The style to use for the text') do |text_style_param|
    options[:text_style] = text_style_param.to_i
  end
  parser.on('--to-clipboard', 'Copy result to clipboard if passed') do
    options[:to_clipboard] = true
  end
end.parse!

puts options if options[:debug]

if options[:style] == 1
  style = "「」"
elsif options[:style] == 2
  style = "〘〙"
elsif options[:style] == 3
  style = "  "
end

text = ""

if options[:text_style] == 1
  text = options[:text]
elsif options[:text_style] == 2
  options[:text].to_s.chars.each do |char|
    if leet_dict.has_key?(char)
      text << leet_dict[char]
    else
      text << char
  end
end
elsif options[:text_style] == 3
  options[:text].to_s.chars.each do |char|
    if lookalikes.has_key?(char.downcase)
      text << lookalikes[char].sample
    else
      text << char
    end
  end
end


result = style[0] + Emojis.new[options[:emoji]][0] + style[1] + text

if options[:to_clipboard]
  Clipboard.copy(result)
end

puts "Your result is: #{result}\nDont be worried if some of the text doesnt appear, it is normal"
