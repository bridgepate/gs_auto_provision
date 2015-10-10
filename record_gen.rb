#!/usr/bin/ruby
require 'fileutils'
require './config'
dhcp = Hash[]
CONFIG.each do |key,value|
  mac = value[:macaddress]
  revip = value[:ipaddress]

  mac = mac.gsub(/(.{2})(?=.)/,'\1:\2') #add : at every third char
  macip = "#{mac};#{value[:ipaddress]}"
  #print dhcp file
  dhcp[key] = macip
   #print dns record

   #print reverse dns record
#   printf "#{rip}\t\tPTR\t#{key}\n"

end
dhcp_file ="/tmp/phones.conf"
  open(dhcp_file,'w') do  |d|
    dhcp.each do | k,v|
      m = v.split(";")[0]
      i = v.split(";")[1]
        d.puts "host #{k} {"
       d.printf "\thardware ethernet #{m}; fixed-address #{i};\n"
       d.puts "}"
       d.puts
    end
  end
  dns_file ="/tmp/dns.conf"
  open(dns_file,'w') do  |d|
    dhcp.each do | k,v|
      i = v.split(";")[1]
      d.printf "#{i}\t\tA\t#{k}\n"
    end
  end
    rev_dns_file ="/tmp/rev_dns.conf"
  open(rev_dns_file,'w') do  |d|
    dhcp.each do | kk,vv|
      i = vv.split(";")[1]
      rip = i.split(".")[2]
      revip = vv.split(".") #this req if you want to use revip.last
      rip =  "#{revip.last}.#{rip}"
      d.printf "#{rip}\t\tPTR\t#{kk}\n"
    end
  end

CONFIG.each do |k,v|
  dn=""
  acc = v[:accounts]
  acc.each do | k,v|
    dn =  v[:dn].to_s
    if !(dn.empty?)
      ext = v[:extension]
      cmd = "ldapsearch -xh ldap-0000.ashs.internal -b 'uid=#{dn},ou=People,dc=ashs,dc=internal' telephoneNumber| grep -w '^telephoneNumber'"
      cmd_out =  system(cmd)
      if cmd_out == true
        puts "dn: uid=#{dn},ou=People,dc=ashs,dc=internal"
        puts "changetype: modify" 
        puts "replace: telephoneNumber" 
        puts "telephoneNumber: #{ext}"
      else
        puts "dn: uid=#{dn},ou=People,dc=ashs,dc=internal"
        puts "changetype: modify" 
        puts "add: telephoneNumber" 
        puts "telephoneNumber: #{ext}"
      end
      puts "-"
    end
  end
end