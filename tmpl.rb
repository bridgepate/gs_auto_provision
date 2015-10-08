#!/usr/bin/ruby
require 'fileutils'
require './config'
class Person
  #Class which will return a has containing all the values from a given file
  attr_accessor :name,:account,:extension,:mac
  #default initiator(should remove all the accessor in future)
  def initialize()
    @name = name
    @account = account
    @extension = extension
    @mac = mac
  end
  #This will return a hash(nested hash)
  def ret_hash
#    f = File.open(fn, "r")
    #Create a hash object. &hash.default_proc is necessary for unlimited nested hash
    phones = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc)}
    CONFIG.each do |key,value|
      # puts value[:hostname]
      # puts value[:ipaddress]
      # puts value[:macaddress]
      ac =  value[:accounts]
      ac.each do | aa, bb|
            #if empty line go to next
      #next if line == "\n"
        macaddr = value[:macaddress].downcase
        c_file = value[:config]
        ext = bb[:extension]
        l_no = aa
        d_name = bb[:displayname]
        # macaddr = line.split(":")[0].downcase #assign values 
      # l_no = line.split(":")[1]
      # acct = line.split(":")[2]
      # d_name= line.split(":")[3]
      # c_file = line.split(":")[4]
      #  phones= Hash[]
      # Fill has with values it adds settings for the relevant mac address 
        phones[macaddr][c_file]["account #{l_no}"]["settings"] = [ext,l_no,d_name]
        puts phones
      end
    end
    #loop through
#    f.each_line do |line|

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
 #   end
    return phones #return hash
  end
end
class Readfiles
  def read_firstline(filename)
    first_line = File.open(filename, &:readline)
    return first_line #return first line of the file
  end

  # Read the whole file
  def read_files(f)
    f =  f.reverse # reverse array we want to apply config of the supplied config from the main config file and because we are using hash it will take value from last config and overwrite it.
    conf = Hash.new
#    i =  f.length
    #    puts i
    i = 0
    f.each do |ff|
      file_read = File.open(ff,'r')
      #    i =  i - 1
      file_read.each_with_index do |line,index|
        #read the whole file of the first file in the passed array of files otherwise leave the first line as it would not have any attribute

        if index == 0 && i > 0
          next
        else
          attr = line.split("=")[0]
          val = line.split("=")[1].gsub(/^\'/,"").gsub(/\'$/,"") #get the value with removed quotes
          conf[attr] = val
        end
      end
      i = i + 1 #counter for the array of files
    end
    return conf #return the hash 
  end
end
#Class which creates config file each mac address
class Writefile
  def write_file
    sip_server = "pbx1.ashs.internal"
    pass = 9065
    vm = 7999
    p = Person.new()
    pp = p.ret_hash
    rf = Readfiles.new() # Object for reading files recursively
    #Iterate through nested hash First get the macaddr

    pp.each do | key ,value |
      open("cfg#{key}.xml",'w') do |f|
        #write the header
        puts "Generating cfg#{key}.xml file"
        f.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        f.puts "<gs_provision version=\"1\">"
        f.puts "<mac>#{key}</mac>"
        f.puts  "<config version=\"1\">"
        #now get the config filename from nested hash
        value.each do | kk,vv|
          kkk =  kk.chomp #get the config file specified in the masterfile(param.txt)
#          puts "kkk is #{kkk}"
          recursive = true #variable to read each file recursively
          @files = [] #Array to hold files to be read
          while recursive == true #Loop untill there is no more files to load
            @files << kkk #Append array
            fl = rf.read_firstline(kkk) #Get the first line
            ff =  fl.split(" ")[0] #split the fields
            fn = fl.split(" ")[1] #filename variable
            if ff != 'load' #if no more files to read from within then exit the loop
#              puts "no more recursion"
              recursive = false
            end
            #  puts ff,fn
            kkk = fn #read firstline of the included file(load 'xxxxx') in the next iteration
          end
          final_conf = rf.read_files(@files) #get the hash from all the config file it ould be one or multiple files
          final_conf.each do | kkkk,vvvv |
            next if kkkk == "\n"
              vvvv = vvvv.chomp
#              kkkk = kkkk.chomp
#            puts "vvvv is #{kkkk.inspect}"
            f.puts "<#{kkkk}>#{vvvv}</#{kkkk}>"
          end
#          puts kk
          #now get the settings
          vv.each do |k,v|

            acct = v["settings"][0] # All the values are inside settings so take one by one
            line = v["settings"][1]
            d_name = v["settings"][2].chomp
            #      value.values.each do |v|
            #set the value according to the account no 
            if line == '1'
              f.puts "<P270>#{d_name}</P270>"
              f.puts "<P47>#{sip_server}</P47>"
              f.puts "<P35>#{acct}</P35>"
              f.puts "<P34>#{pass}</P34>"
              f.puts "<P3>#{d_name}</P3>"
              f.puts "<P33>#{vm}</P33>"
            elsif line == '2'
              f.puts "<P417>#{d_name}</P417>"
              f.puts "<P402>#{sip_server}</P402>"
              f.puts "<P404>#{acct}</P404>"
              f.puts "<P406>#{pass}</P406>"
              f.puts "<P407>#{d_name}</P407>"
              f.puts "<P426>#{vm}</P426>"
            elsif line == '3'
              f.puts "<P517>#{d_name}</P517>"
              f.puts "<P502>#{sip_server}</P502>"
              f.puts "<P504>#{acct}</P504>"
              f.puts "<P506>#{pass}</P506>"
              f.puts "<P507>#{d_name}</P507>"
              f.puts "<P526>#{vm}</P526>"
            end
          end
        end
        #write the footer
        f.puts "</config>"
        f.puts "</gs_provision>"
        
      end
    end
    #    end
  end
  #       text = text.gsub(/# P270 =/, "P270 = #{person.name}").gsub(/P47 =/, "P47 = #{sip_server}").gsub(/P35 =/, "P35 = #{person.extension}").gsub(/P34 =/, "P34 = #{pass}").gsub(/P3 =/, "P3 = #{person.name}").gsub(/P33 =/, "P33 = #{person.extension}")    
  #      text = text.gsub(/# P417 =/, "P417 = #{person.name}").gsub(/P402 =/, "P402 = #{sip_server}").gsub(/P404 =/, "P404 = #{person.extension}").gsub(/P406 =/, "P406 = #{pass}").gsub(/P407 =/, "P407 = #{person.name}").gsub(/P426 =/, "P426 = #{person.extension}")    

end

fh = Writefile.new() #object for writing file
fh.write_file

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
