#!/usr/bin/expect

if {[llength $argv] < 3} {

puts "usage: username password repository"

exit 1

}

proc svn_list {} {
   expect {
       "*(p)ermanently?" {
           send "p\r"
           expect {
               "*unencrypted (yes/no)?" {
                   send "no\r"
                   return 0
               }
           }
       }
   }
   # timed out
   return 1
}

set username [lindex $argv 0]
set password [lindex $argv 1]
set repo [lindex $argv 2]
spawn svn list --username $username --password $password $repo
if {[svn_list] > 0} {
    puts "Expect timed out!"
} else {
    expect eof
}
