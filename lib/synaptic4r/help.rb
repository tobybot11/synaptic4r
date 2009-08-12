####---------------------------------------------------------------------------------------------------------
def get_started
  puts <<-EXAMP

Get Started

Save credentials to #{ENV['HOME']}/.synaptic4

 single account

   subtenant: SubtenantID 
   uid:       UserID
   key:       SecretKey
   site:      https://storage.synaptic.att.com/rest

 multiple accounts (the first is used by default, the dashes must 
 be included in the file)

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
   
 -list contents remote root directory    

   synrest get

 -create a remote directory named foo    

   synrest create-dir foo

 -upload a file to directory foo    

  synrest create-file file.txt foo/

 -list contents remote directory foo   

   synrest get foo

 -list contents remote file foo/file.txt   

  synrest get foo/file.txt

 - show more examples for a command

   synrest command examples

 - execute command for account other than default

   synrest command args [options] -u myotheracct

Diagnostic Options

 diagnostic options are supported by all commands

   -q, --dump        do not send request but print headers and service url to STDOUT
   -p, --payload     do not send request print payload to STDOUT if present
   -l, --log [file]  log request to file (by default file is synaptic4r.log)
   -h, --help        command help

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_dir_examples
  puts <<-EXAMP

 - create a directory named foo  

     synrest create-dir foo

 - create directory foo/bar automatically creating directories if not present

     synrest create-dir foo/bar

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_file_examples
  puts <<-EXAMP

 - upload a file to root directory and preserve the file name  

     synrest create-file file.txt

 - upload a file to root directory and change the file name

     synrest create-file file.txt otherfile.text

 - upload a file to directory and preserve the file name

     synrest create-file file.txt foo/

 - upload a file to directory and change the file name

     synrest create-file file.txt foo/otherfile.txt

 - upload a file to directory automatically creating 
   directories if not present

     synrest create-file foo/bar/file.txt

 - upload file in 500 byte increments.

     synrest create-file file.txt -b 0 -d 499
     synrest update file.txt -b 500  -d 999
     synrest update file.txt -b 1000 -d 1499
     synrest update file.txt -b 1500 -d 1999

 - upload a file and specify listable metadata tags instead of file name.
   files may be discovered by specifying either a name, listable meta tags or both
   (see 'synrest get-all-tags', 'synrest get-by-tag', 'synrest get-tags' and 'synrest update-listable-metadata'). 
   the tag is the name part of the listable metadata name=value pair. 
   currently queries are only possible for over metadata names. queries over name=value are not supported. 
   the value may be omitted when specifying a tag.

     synrest create-file file.txt -i tagged
     synrest create-file file.txt -i tagged=yes,location

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_version_examples
  puts <<-EXAMP

Things to know about versioning

 File or directory versions can only be accessed by OID.

 Deleting a file or directory will not delete its versions.

 Creating a version of a directory will create a version of all objects 
 in the directory 

 Creating a version of a previous file or directory version will create a version of the 
 current file or directory not the version on which the command was executed. 

 Meta-data cannot be modified on file or directory versions.

 Meta-data queries ignore meta-data assigned to file of directory versions.
 
Examples

 - create a version of a file by specifying remote file path

     bin/synrest create-version file.txt

 - create a version of a directory and all contained files and directories
   by specifying remote directory path

     bin/synrest create-version foo

 - create a version of a storage object by specifying OID

     bin/synrest create-version -o 4a08bf2ea11f1e0b04a08c466666a804a806bfc20387 


  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def delete_examples
  puts <<-EXAMP

 - delete file by specifying remote file path  

     synrest delete foo/file.txt

 - delete directory by specifying remote directory path. delete of a director will fail
   unless the directory is empty.  

     synrest delete foo

 - delete storage object by specifying OID
   
     synrest delete -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def delete_user_metadata_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_examples
  puts <<-EXAMP

 - get remote root directory listing

     synrest get

 - get remote directory listing by specifying directory name
 
     synrest get foo

 - get remote directory listing by specifying OID

     synrest get -o 4a08bf2ea11f1e0b04a08c4bb666a804a7c5d32a2c63 

 - get file by remote file name

     synrest get foo/file.txt

 - get file by specifying OID

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

Things to know about listable meta-data tags

 Files may be discovered by specifying either a name, listable meta tags or both
 (see 'synrest get-all-tags' and 'synrest get-by-tag'). 

 The tag is the name part of the listable metadata name=value pair. 

 The value is not required when specifying a listable metadata for object creation.

 Queries are only possible for metadata names (i.e queries for name=value are not supported).

 Meta-data tags cannot be removed from the global tag index.
   
 - get all listable metadata tags used by account

     synrest get-all-tags

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_by_tag_examples
  puts <<-EXAMP

 - get all objects with specified listable metadata tag

     synrest get-by-tag location

 - get all objects with specified listable metadata tag with extended output
   
     synrest get-by-tag location -e

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_system_metadata_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_tags_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_user_metadata_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_versions_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def update_examples
  puts <<-EXAMP

Update does not delete storage objects before overwriting. Update will acquire new storage space
as required but will not release storage space.

 - update a file

     synrest update file.txt
    

 - upload file in 500 byte increments.

     synrest create-file file.txt -b 0 -d 499
     synrest update file.txt -b 500  -d 999
     synrest update file.txt -b 1000 -d 1499
     synrest update file.txt -b 1500 -d 1999

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def update_acl_examples
  puts <<-EXAMP

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def update_listable_metadata_examples
  puts <<-EXAMP

Things to know about listable meta-data tags

 Files may be discovered by specifying either a name, listable meta tags or both
 (see 'synrest get-all-tags' and 'synrest get-by-tag'). 

 The tag is the name part of the listable metadata name=value pair. 

 The value is not required when specifying a listable metadata for object creation.

 Queries are only possible for metadata names (i.e queries for name=value are not supported).

 Meta-data tags cannot be removed from the global tag index.

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def update_nonlistable_metadata_examples
  puts <<-EXAMP

  EXAMP
end
