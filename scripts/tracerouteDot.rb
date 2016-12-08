#!/usr/bin/ruby

# A script to take the output of a group of traceroute calls and generate
# a dot file specifying the connectivity graph represented by the
# traceroute output.

# This is based on a script by Melissa Helgeson from Fall, 2009.

def print_header(output_file)
  output_file.puts("digraph network {")
end

def print_footer(output_file)
  output_file.puts("}")
end

def construct_entry_regex
  # Regular expressions to match the output of "traceroute"
  # Each line is a number, address, and timings
  address_rx = /\w+\s+(\S+)/
  ip_address_rx = /\s+(\(\d+\.\d+\.\d+\.\d+\))/
  
  entry_regex = /#{address_rx}#{ip_address_rx}/
  
  return entry_regex
end

def get_entries(domain_name)
  # Run the command and split the result (which is one big string) on newlines
  entries = `traceroute -m 60 #{domain_name}`.split("\n")
  return entries
end

def parse_entry(entry, entry_regex)
  match = entry.match(entry_regex)
  if (match == nil) 
    return ""
  else
    address = "\"" + match[1]
    ip_address =  " " + match[2] + "\""
    return address + ip_address
  end
end

def parse_entries_to_dot(output_file, entries, entry_regex)
  output_file.puts("\n")
  #remove the first (header) line & use it as a comment
  headerLine = entries.shift
  output_file.puts("// #{headerLine}")
  output_file.write("\"Dungeon\" -> ")
  i = 0
  while i < entries.length do
    full_address = parse_entry(entries[i], entry_regex)
    if (full_address != "")
      output_file.puts("#{full_address};")
      output_file.write("#{full_address} -> ")
    end
    #This will cause it to either end on the original input or a self-loop of that input
    if i == (entries.length-1) then
      end_rx = /\S+\s+\(\d+\.\d+\.\d+\.\d+\)/
      endLocation = headerLine[end_rx]
      output_file.puts("\"#{endLocation}\";")
    end
    i = i + 1
  end
end

output_file_name = "network_graph.dot"
output_file = File.open(output_file_name, "w")

print_header(output_file)
entry_regex = construct_entry_regex

ARGV.each do |domain_name|
  puts "Processing #{domain_name}"
  entries = get_entries(domain_name)
  parse_entries_to_dot(output_file, entries, entry_regex)
end
print_footer(output_file)

output_file.close
