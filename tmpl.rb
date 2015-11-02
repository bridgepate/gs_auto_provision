#!/usr/bin/ruby
require 'fileutils'
require 'yaml'
require './config'
class Initialsettings
#test revert
  def fillvalues(initial_val,m)
#fill the hash with null values related to the lines on the phone so that we can remove all the previous settings from the phone
    if m == "gxp2140"
      initial_val = {"P270" => "","P271" => "0","P47" => "","P35" => "","P34" => "","P3" => "",  "P33" => "", "P337" => "", "P352" => "","P417" => "", "P401" => "0","P402" => "","P404" => "","P406" => "","P407" => "", "P426" => "", "P517" => "", "P501" => "0", "P502" => "","P504" => "","P506" => "", "P507" => "","P526" => "", "P617" => "","P601" => "0","P602" => "","P604" => "","P606" => "","P607" => "", "P626" => ""}
    else
      initial_val = {"P270" => "","P271" => "0","P47" => "","P35" => "","P34" => "","P3" => "",  "P33" => "", "P337" => "", "P352" => "","P417" => "", "P401" => "0","P402" => "","P404" => "","P406" => "","P407" => "", "P426" => "", "P517" => "", "P501" => "0", "P502" => "","P504" => "","P506" => "", "P507" => "","P526" => ""}
    end
#    return initial_val
  end
end
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
        dn = bb[:dn]
        d_name = bb[:displayname]
        # Fill has with values it adds settings for the relevant mac address 
        phones[macaddr][c_file]["account #{l_no}"]["settings"] = [ext,l_no,d_name,dn]
      end
    end
    return phones #return hash
  end
end
class Readfiles
  def read_firstline(filename)
    first_line = File.open(filename, &:readline)
    return first_line #return first line of the file
  end

  # Read the whole file
  def read_files(f,h)
    f =  f.reverse # reverse array we want to apply config of the supplied config from the main config file and because we are using hash it will take value from last config and overwrite it.
 #   conf = Hash.new
    #    i =  f.length
puts f
    i = 0
    f.each do |ff|
      file_read = YAML.load_file(ff)
      #    i =  i - 1
      file_read.each_with_index do |line,index|
        #read the whole file of the first file in the passed array of files otherwise leave the first line as it would not have any attribute

#        if index == 0 && i > 0
#          next
 #       else
          # attr = line.split("=")[0]
          # val = line.split("=")[1].gsub(/^\'/,"").gsub(/\'$/,"") #get the value with removed quotes       
        attr = line[0]
        val = line[1] #get the value with removed quotes
        if attr == "config"
          
          next
        else
          h[attr] = val
        end
        #end
      end
      i = i + 1 #counter for the array of files
    end
    return h #return the hash 
  end
end
#Class which creates config file each mac address
class Writefile
  def write_file
    sip_server = "pbx"
    pass = "xmscnuf3k8"
    vm = "*97"
    p = Person.new()
#    pp = p.ret_hash
    rf = Readfiles.new() # Object for reading files recursively
    #Iterate through nested hash First get the macaddr
    init_val = Initialsettings.new()
    CONFIG.each do | key ,value |
#    pp.each do | key ,value |
      model = key.to_s
      model = model.split("-")[0]
      mainconf = Hash.new #hash for putting initial values from config.rb
      mainconf = init_val.fillvalues(mainconf,model) #fill the hash with null values 
      mac = value[:macaddress].downcase
      kkk = value[:config]
      open("/tmp/confnew/cfg#{mac}.xml",'w') do |f|
        #write the header
        puts "Generating cfg#{mac}.xml file"
        f.puts "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        f.puts "<gs_provision version=\"1\">"
        f.puts "<mac>#{mac}</mac>"
        f.puts  "<config version=\"1\">"
        #now get the config filename from nested hash
        #value.each do | kk,vv|
#          kkk =  kk.chomp #get the config file specified in the masterfile(param.txt)
          #          puts "kkk is #{kkk}"
          recursive = true #variable to read each file recursively
          @files = [] #Array to hold files to be read
        @files << kkk #initiate array from the main config file
          while recursive == true #Loop untill there is no more files to load
            cffile = YAML.load_file(kkk) 
            cf = cffile["config"] # read config 
            if cf 
              cf.each do | cff|
              @files << cff #Append array
              kkk = cff
            end
            else
              recursive = false
            end
#            fl = rf.read_firstline(kkk) #Get the first line
#            ff =  fl.split(" ")[0] #split the fields
#            fn = fl.split(" ")[1] #filename variable
#            if ff != 'load' #if no more files to read from within then exit the loop
              #              puts "no more recursion"
  
 #           end
            #  puts ff,fn
              #kkk = cffile #read firstline of the included file(load 'xxxxx') in the next iteration
          end
        ac =  value[:accounts]
        ac.each do | aa, bb|
          #if empty line go to next
          #next if line == "\n"
          ext = bb[:extension]
          l_no = aa
          dn = bb[:dn]
          d_name = bb[:displayname]
        # vv.each do |k,v|
        
          #   acct = v["settings"][0] # All the values are inside settings so take one by one
          #   line = v["settings"][1]
          #   d_name = v["settings"][2].chomp
          #   dn = v["settings"][3]
          #   #      value.values.each do |v|
          #   #set the value according to the account no 
            if l_no == '1'
              mainconf["P270"] = "#{d_name}"
              mainconf["P271"] = "1"
              mainconf["P47"] = "#{sip_server}"
              mainconf["P35"] = "#{ext}"
              mainconf["P34"] = "#{pass}"
              mainconf["P3"] = "#{d_name}"
              mainconf["P33"] = "#{vm}"
              if dn != nil #no vm for places and shared phone should also remove vm 
                 mainconf["P337"] = "#{sip_server}/phone/vm/mail/#{ext}/"
                 mainconf["P352"] = "VoiceMail"
              end
            elsif l_no == '2'
              mainconf["P417"] = "#{d_name}"
              mainconf["P402"] = "#{sip_server}"
              mainconf["P401"] = "1"
              mainconf["P404"] = "#{ext}"
              mainconf["P406"] = "#{pass}"
              mainconf["P407"] = "#{d_name}"
              mainconf["P426"] = "#{vm}"
            elsif l_no == '3'
              mainconf["P517"] = "#{d_name}"
              mainconf["P501"] = "1"
              mainconf["P502"] = "#{sip_server}"
              mainconf["P504"] = "#{ext}"
              mainconf["P506"] = "#{pass}"
              mainconf["P507"] = "#{d_name}"
              mainconf["P526"] = "#{vm}"
            elsif l_no == '4'
              mainconf["P617"] = "#{d_name}"
              mainconf["P601"] = "1"
              mainconf["P602"] = "#{sip_server}"
              mainconf["P604"] = "#{ext}"
              mainconf["P606"] = "#{pass}"
              mainconf["P607"] = "#{d_name}"
              mainconf["P626"] = "#{vm}"
            end
            
          # end
        end
        final_conf = rf.read_files(@files,mainconf) #get the hash from all the config file it ould be one or multiple files
          final_conf.each do | kkkk,vvvv |
            next if kkkk == "\n"
            vvvv = vvvv
            #            puts "vvvv is #{kkkk.inspect}"
            f.puts "<#{kkkk}>#{vvvv}</#{kkkk}>"
          end
          #now get the settings
        #end
        #write the footer
        f.puts "</config>"
        f.puts "</gs_provision>"
        
      end
    end
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
