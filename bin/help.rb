####---------------------------------------------------------------------------------------------------------
def get_started
  puts <<-EXAMP

Create $HOME/.synaptic4r

 subtenant: SubtenantID 
 uid:       UserID
 key:       SecretKey
 site:      https://storage.synaptic.att.com/rest

Examples

 - write a file to remote storage site      

     synrest create -f file.txt
     OID:      4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02
     uploaded: 3695 bytes

 - write a file to remote storage site and specify a remote file name      

     synrest create -f file.txt -r file.txt

 - retrieve file by OID (Object Identifier)

     synrest read -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest read -r file.txt

 - delete file by OID

     synrest delete -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest delete -r file.txt

 - retrieve user metadata by OID

     synrest list-user-metadata -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest list-user-metadata -r file.txt

 - retrieve system metadata by OID

     synrest list-system-metadata -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest list-system-metadata -r file.txt

 - retrieve access control list by OID

     synrest list-acl -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest list-acl -r file.txt

 - create an immutable copy of an object by OID

     synrest version -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest version -r file.txt

 - list OIDs of all versions of an object by OID

     synrest list-versions -o 4a08bf2ead1f2e1904a4cd0bd62f9604a5f7932b8e02

   by remote file name

     synrest list-versions -r file.txt

EXAMP
end

