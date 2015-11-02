#This script will take a config file as an input and gives a yaml file as output. Argument 1 is input file and 2 is output file
#!/usr/bin/ruby
in_file = ARGV[0]
out_file = ARGV[1]
open("#{out_file}","w") do | f|
  f.puts "---"
  f_read = File.open("#{in_file}","r")
  arr = ["P270" ,"P271","P47","P35","P34","P3","P33","P337", "P352","P417", "P401","P402","P404","P406","P407", "P426","P517","P501", "P502","P504","P506", "P507","P526", "P617","P601","P602","P604","P606","P607", "P626"]
  f_read.each do | l|
    if  (l.match(/^#/)) || (l == "\n")
      next
    else
      ll = l.split("=",2)
      attr = ll[0]
      val = ll[1]
      val = val.chomp
      special = "?<>',?[]}{=-)(*&^%$#`~{}@"
      regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
      if val =~ regex
        val = "\"#{val}\""
      end
       if arr.include?(attr)
         puts "found"
       else
         f.puts "#{attr}: #{val}"
      end
    end

  end

end
