#!/usr/bin/ruby
require 'fileutils'
class Person
  attr_accessor :name,:account,:extension
  def initialize(extension,account,name)
    @name = name
    @account = account
    @extension = extension
  end
end
class Writefile
  def fh_write_file(filename,person)

    append_file(filename,'a',person)
    
  end
  def append_file(filename,mode,person)
      open(filename,mode) do |f|
        f.puts "account.#{person.account}.enable = 1"
        f.puts "account.#{person.account}.label = #{person.name}"
        f.puts "account.#{person.account}.display_name = #{person.name}"
        f.puts "account.#{person.account}.auth_name = #{person.extension}"
        f.puts "account.#{person.account}.password = 1111"
        f.puts "account.#{person.account}.user_name = #{person.extension}"
        f.puts "account.#{person.account}.sip_server_host = abc.com"
        f.puts "voice_mail.number.#{person.account} = #{person.extension}"
        f.puts "account.#{person.account}.subscribe_mwi_to_vm = 1"
        f.close
      end
    
  end
end
fh = Writefile.new()
#data = fh.open_file('extlist.txt')
data = ''
mac = Array.new
f = File.open('params.txt', "r")
f.each_line do |line|
  macaddr = line.split(":")[0].downcase
  ext = line.split(":")[1]
  acct = line.split(":")[2]
  d_name= line.split(":")[3]
  filename = "cfg#{macaddr}"
  p = Person.new(ext,acct,d_name)

  if mac.include?(macaddr)
    fh.fh_write_file(filename,p)
  else
    #    puts "no mac going to entering now"
    #Add entry into array
    mac << macaddr
    FileUtils.cp('gxp21xx_config_1.0.8.4.txt', filename)
    fh.fh_write_file(filename,p)
#      puts mac
  end

  # data += line
#  puts "#{p.name} #{p.account} #{p.extension}"
  
end
#   return data
#puts data
