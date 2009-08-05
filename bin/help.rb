####---------------------------------------------------------------------------------------------------------
def get_started
  puts <<-EXAMP

Get Started

Save credentials to $HOME/.synaptic4r

  subtenant: SubtenantID 
  uid:       UserID
  key:       SecretKey
  site:      https://storage.synaptic.att.com/rest

Basic Commands

 - create a remote directory named foo    

     synrest create-dir foo

 - list contents remote root directory    

     synrest get

 - upload a file to directory foo    

     synrest create-file file.txt foo/file.text

EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_file_examples
  puts <<-EXAMP

 - upload a file to directory foo    

     synrest create-file file.txt foo/file.text

EXAMP
end
