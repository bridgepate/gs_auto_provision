# gs_auto_provision
This will create auto_provisioning xml files for multiple accounts on same phone
This program is intended to create auto_provisioning xml files for each mac address specified in the params.txt file.
The params.txt files can have multiple lines each line consist of 4 parameters 

macaddr:extension no:lineno(on the phone):AccountName
The macaddr is MAC address of the phone(without colon)
extension no is the sip account no
lineno is line no on the phone so if you have GXP2140 you can have 1,2,3 or 4
Account Name( Account name you want to display on the phone)

This script is tested on GXP2140. Please let me know if you have any problems.
