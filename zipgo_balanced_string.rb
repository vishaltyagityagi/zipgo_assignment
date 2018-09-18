require 'byebug'
def check_balanced?(string)
  return false if string.length.odd?
  return false if string =~ /[^\[\]\(\)\{\}]/

  pairs = { '{' => '}', '[' => ']', '(' => ')' }
  stack = []
  match_string(string,pairs,stack)
end

def match_string(string,pairs,stack)
  string.chars do |bracket|
    if expectation = pairs[bracket]
      stack << expectation
    else
      return false unless stack.pop == bracket
    end
  end
  stack.empty?
end



puts check_balanced?("()[]{}")
puts check_balanced?("([{}])")
puts check_balanced?("([]{})")
puts check_balanced?("([)]")
puts check_balanced?("([]")
puts check_balanced?("[])")
puts check_balanced?("([})")