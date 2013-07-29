# run with :%!ruby gem_sorter.rb
# buffer = VIM::Buffer.current
buffer = STDIN.read.split "\n"

current_line = 0

tree = {
  :gems => [],
  :groups => {}
}

current_node = tree[:gems]

while current_line < buffer.length do
  line = buffer[current_line]

  if line =~ /group [':"]([^":']+) do/
    group_name = $~[1]
    tree[:groups][group_name.to_sym] = []
    current_node = tree[:groups][group_name.to_sym]

  elsif line =~ /end/
    current_node = tree[:gems]

  elsif line =~ /gem [':"]([^":']+)[':"]/
    gem_name = $~[1]
    current_node << gem_name
  end

  current_line += 1
end

tree[:gems].sort.each do |gem|
  puts "gem '#{gem}'"
end

puts "\n# gem groups"

tree[:groups].sort_by do |group_name, gems|
  group_name
end.each do |group_name, gems|
  puts "\ngroup '#{group_name}' do"

  gems.each do |gem|
    puts "  gem '#{gem}'"
  end

  puts "end"
end
