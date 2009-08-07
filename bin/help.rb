####---------------------------------------------------------------------------------------------------------
def get_started
  puts <<-EXAMP

Get Started

Save credentials to #{ENV['HOME']}/.synaptic4r

 single account

   subtenant: SubtenantID 
   uid:       UserID
   key:       SecretKey
   site:      https://storage.synaptic.att.com/rest

 multiple accounts (the first is used by default)

   -
    account:   myacct
    subtenant: SubtenantID 
    uid:       UserID
    key:       SecretKey
    site:      https://storage.synaptic.att.com/rest

   -
    account:   myotheracct
    subtenant: OtherSubtenantID 
    uid:       OtherUserID
    key:       OtherSecretKey
    site:      https://storage.synaptic.att.com/rest

Basic Commands
   
 list contents remote root directory    

   synrest get

 create a remote directory named foo    

   synrest create-dir foo

 upload a file to directory foo    

   synrest create-file file.txt foo/

 list contents remote directory foo   

   synrest get foo

 list contents remote file foo/file.txt   

   synrest get foo/file.txt

 show more examples for a command

   synrest command examples

 execute command for account other than default

   synrest command args [options] -u myotheracct

Diagnostic Options

 diagnostic options are supported by all commands

    -q, --dump        do not send request but print headers and service url
    -p, --payload     do not send request print payload if present
    -l, --log [file]  log request to file (by default file is synaptic4r.log)
    -h, --help        command help

Diag
EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_dir_examples
  puts <<-EXAMP

 - create a directory named foo  

     synrest create-dir foo

 - create directory foo/bar automatically creating 
   directories if not present

     synrest create-dir foo/bar

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_file_examples
  puts <<-EXAMP

 - upload a file to root directory and preserve name  

     synrest create-file file.txt

 - upload a file to root directory and change name

     synrest create-file file.txt otherfile.text

 - upload a file to directory and preserve name

     synrest create-file file.txt foo/

 - upload a file to directory and change name

     synrest create-file file.txt foo/otherfile.txt

 - upload a file to directory automatically creating 
   directories if not present

     synrest create-file foo/bar/file.txt

 - upload a file and specify listable metadata tags instead of file name

     synrest create-file file.txt -i junk=yes
     synrest create-file file.txt -i junk=yes,useful=no

 - upload only the first 500 bytes of file

      synrest create-file file.txt -b 0 -d 499

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_examples
  puts <<-EXAMP

 - get remote root directory listing

     synrest get

 - get remote directory listing by specifing directory name
 
     synrest get foo

 - get remote directory listing by specifing OID

     synrest get -o 4a08bf2ea11f1e0b04a08c4bb666a804a7c5d32a2c63 

 - get file by remote file name

     synrest get foo/file.txt

 - get file by specifing OID

     synrest get -o 4a08bf2ea11f1e0b04a6664b3866a804a7c60fb30b30

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_acl_examples
  puts <<-EXAMP

 - get access control list by specifying remote file path  

     synrest get-acl foo/file.txt

 - get access control list by specifying remote directory path  

     synrest get-acl foo

 - get access control list by specifying OID
   
     synrest get-acl -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_all_tags_examples
  puts <<-EXAMP

 - get all listable metadata tags used by account

     synrest get-all-tags

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_by_tag_examples
  puts <<-EXAMP

 - get all objects with specified listable metadata tag

     synrest get-by-tag junk

 - get all objects with specified listable metadata tag with extended output
   
     synrest get-by-tag junk -e

EXAMP
end

