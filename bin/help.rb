####---------------------------------------------------------------------------------------------------------
def get_started
  puts <<-EXAMP

Get Started

Save credentials to #{ENV['HOME']}/.synaptic4r

 - single account

   subtenant: SubtenantID 
   uid:       UserID
   key:       SecretKey
   site:      https://storage.synaptic.att.com/rest

 - multiple accounts (the - must be included with 1 space indentation for data)

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

 - create a remote directory named foo    

     synrest create-dir foo

 - list contents remote root directory    

     synrest get

 - upload a file to directory foo    

     synrest create-file file.txt foo/file.text

Diag
EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_file_examples
  puts <<-EXAMP

 - upload a file to directory foo    

     synrest create-file file.txt foo/file.text

EXAMP
end
