#!/usr/bin/ruby

require 'fileutils'
class Person
  attr_accessor :name,:account,:extension,:mac
  def initialize()
    @name = name
    @account = account
    @extension = extension
    @mac = mac
  end
  def ret_hash
    f = File.open('params.txt', "r")
    phones = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc)}

    f.each_line do |line|
      next if line == "\n"

      macaddr = line.split(":")[0].downcase
      ext = line.split(":")[1]
      acct = line.split(":")[2]
      d_name= line.split(":")[3]
      #  phones= Hash[]
      
      phones[macaddr]["account #{acct}"]["settings"] = [acct,ext,d_name]
      #  phones[macaddr][:accounts][:params1] = ["1","dfdf"]
      # Create and add a subhash.
      # accounts = Hash[]
      # accounts["sip no #{acct}"] = acct
      # phones[macaddr] = accounts
      # settings = Hash[]
      # settings["account no #{acct}"] = ext
      # settings["Display Name"] = d_name
      # accounts["params"] = settings

      # accounts1 = Hash[]
      # accounts1["sip no 2"] = acct
      # phones[macaddr] = accounts1
      # settings1 = Hash[]
      # settings1["account no 7921"] = ext
      # settings1["Display Name"] = d_name
      # accounts1["params"] = settings1
      #  puts params["macaddr"]
      end
    return phones
  end
end
class Writefile
  def write_file(filename)
    p = Person.new()
    pp = p.ret_hash
    pp.each do | key ,value |
        open("cfg#{key}.xml",'w') do |f|
          f.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
          f.puts "<gs_provision version=\"1\">"
          f.puts "<mac>#{key}</mac>"
          f.puts  "<config version=\"1\">"
          value.each do | k,v|
            line = v["settings"][0]
            acct = v["settings"][1]
            d_name = v["settings"][2].chomp
            #      value.values.each do |v|
            if line == '1'
              f.puts "<P270>#{d_name}</P270>"
              f.puts "<P47>abc.com</P47>"
              f.puts "<P35>#{acct}</P35>"
              f.puts "<P34>1111</P34>"
              f.puts "<P3>#{d_name}</P3>"
              f.puts "<P33>7999</P33>"
            elsif line == '2'
              f.puts "<P417>#{d_name}</P417>"
              f.puts "<P402>abc.com</P402>"
              f.puts "<P404>#{acct}</P404>"
              f.puts "<P406>1111</P406>"
              f.puts "<P407>#{d_name}</P407>"
              f.puts "<P426>7999</P426>"
            elsif line == '3'
              f.puts "<P517>#{d_name}</P517>"
              f.puts "<P502>abc.com</P502>"
              f.puts "<P504>#{acct}</P504>"
              f.puts "<P506>1111</P506>"
              f.puts "<P507>#{d_name}</P507>"
              f.puts "<P526>7999</P526>"

            end
          end
          f.puts "</config>"
          f.puts "</gs_provision>"
          
        end
      end
#    end
  end
 #       text = text.gsub(/# P270 =/, "P270 = #{person.name}").gsub(/P47 =/, "P47 = abc.com").gsub(/P35 =/, "P35 = #{person.extension}").gsub(/P34 =/, "P34 = 1111").gsub(/P3 =/, "P3 = #{person.name}").gsub(/P33 =/, "P33 = #{person.extension}")    
  #      text = text.gsub(/# P417 =/, "P417 = #{person.name}").gsub(/P402 =/, "P402 = abc.com").gsub(/P404 =/, "P404 = #{person.extension}").gsub(/P406 =/, "P406 = 1111").gsub(/P407 =/, "P407 = #{person.name}").gsub(/P426 =/, "P426 = #{person.extension}")    

end

fh = Writefile.new()
#data = fh.open_file('extlist.txt')
#filename = "cfg#{macaddr}.xml"
# f = File.open('params.txt', "r")
p = Person.new()

fh.write_file('params.txt')
#   if mac.include?(macaddr)
#     fh.fh_write_file(filename,'a',p)
#   else
#     #    puts "no mac going to entering now"
#     #Add entry into array
#     puts "else called"
#     puts @mac
#     mac << macaddr
#     FileUtils.cp('gxp21xx_config_1.0.8.4.txt', filename)
#     fh.fh_write_file(filename,'w',p)
# #      puts mac
#   end
  # data += line
#  puts "#{p.name} #{p.account} #{p.extension}"

#  puts phones
#end
#   return data
#puts data
