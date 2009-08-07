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
def create_file_examples
  puts <<-EXAMP

 - upload a file to root directory and preserve name  

     synrest create-file file.txt

 - upload a file to root directory and change name

     synrest create-file file.txt otherfile.text

 - upload a file to directory foo and preserve name

     synrest create-file file.txt foo/

 - upload a file to directory foo and change name

     synrest create-file file.txt foo/otherfile.txt

 - upload a file to directory foo/bar automatically creating 
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
def get_examples
  puts <<-EXAMP

 - create a directory named foo  

     synrest create-dir foo

 - create directory foo/bar automatically creating 
   directories if not present

     synrest create-dir foo/bar

EXAMP
end
