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
   
 - list contents remote root directory    

     synrest get

 - create a remote directory named foo    

     synrest create-dir foo

 - upload a file to directory foo    

     synrest create-file file.txt foo/

 - list contents remote directory foo   

     synrest get foo

 - list contents remote file foo/file.txt   

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

File creation requires specification of either a remote file name of listable metadata tag.

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

 - upload a file and specify listable metadata tags instead of file name. listable
   metadata consists of a name=value pair. specification of the value is
   optional

     synrest create-file file.txt -i tagged
     synrest create-file file.txt -i tagged=yes,location

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def create_version_examples
  puts <<-EXAMP

#{versioning_things_to_know}

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

#{user_metadata_things_to_know}

Examples

 - delete user metadata for a file by specifying remote file path  

     synrest delete-user-metadata location foo/file.txt
     synrest delete-user-metadata location,capital foo/file.txt

 - delete user metadata for a directory by specifying remote directory path  

     synrest delete-user-metadata building foo
     synrest delete-user-metadata building,location foo

 - delete user metadata for a storage object by specifying OID
   
     synrest delete-user-metadata building -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest delete-user-metadata building,location -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

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

 - get the portion of the file between bytes 50 and 150 specifying byte offsets 
   and file name

     synrest get foo/file.txt -b 50 -d 150

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_acl_examples
  puts <<-EXAMP

#{acl_things_to_know}

Examples

 - get access control list for a file by specifying remote file path  

     synrest get-acl foo/file.txt

 - get access control list for a directory by specifying remote directory path  

     synrest get-acl foo

 - get access control list for a storage object by specifying OID
   
     synrest get-acl -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_all_tags_examples
  puts <<-EXAMP

#{user_metadata_things_to_know}

Examples
   
 - get all listable metadata tags used by account

     synrest get-all-tags

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_by_tag_examples
  puts <<-EXAMP

#{user_metadata_things_to_know}

 - get OIDs for all objects with specified listable metadata tag. only one tag may be specified.

     synrest get-by-tag location

 - get all objects with specified listable metadata tag with extended output
   
     synrest get-by-tag location -e

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_system_metadata_examples
  puts <<-EXAMP

 - get system metadata for a file by specifying remote file path  

     synrest get-system-metadata foo/file.txt

 - get  system metadata for a directory by specifying remote directory path  

     synrest get-system-metadata foo

 - get  system metadata for a storage object by specifying OID
   
     synrest get-system-metadata -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_tags_examples
  puts <<-EXAMP

 - get listable metadata tags for a file by specifying remote file path  

     synrest get-tags foo/file.txt

 - get listable metadata tags for a directory by specifying remote directory path  

     synrest get-tags foo

 - get listable metadata tags for a storage object by specifying OID
   
     synrest get-tags -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_user_metadata_examples
  puts <<-EXAMP

#{user_metadata_things_to_know}


Examples
 
 - get user metadata for a file by specifying remote file path  

     synrest get-tags foo/file.txt

 - get listable metadata tags for a directory by specifying remote directory path  

     synrest get-tags foo

 - get listable metadata tags for a storage object by specifying OID
   
     synrest get-tags -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_versions_examples
  puts <<-EXAMP

#{versioning_things_to_know}

Examples

 - get versions for a file by specifying remote file path  

     synrest get-versions foo/file.txt

 - get versions for a directory by specifying remote directory path  

     synrest get-versions foo

 - get versions for a storage object by specifying OID
   
     synrest get-versions -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30


  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def get_object_url_examples
  puts <<-EXAMP

Things to know about object urls

 Object urls have a specified lifetime.

 The default lifetime of an object url is 5 minutes

Examples

 - get object url by specifying remote file path  

     synrest get-object-url foo/file.txt

 - get object url by specifying remote file path and lifetime of 20  minutes  

     synrest get-object-url foo/file.txt -f 20

 - get object url for a storage object by specifying OID
   
     synrest get-object-url -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30


  EXAMP

end

####---------------------------------------------------------------------------------------------------------
def update_examples
  puts <<-EXAMP

#{updating_things_to_know}

Examples

 - update a file in root directory of the same name as the file. 

     synrest update file.txt

 - update a file in the root directory with a different from source file.

     synrest update file.txt otherfile.text

 - update a file in directory 'foo' with same name as source file.

     synrest update file.txt foo/

 - update a file in directory 'foo' with a name different from source file

     synrest update file.txt foo/otherfile.txt

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

#{acl_things_to_know}

Examples

 - give another user READ access to a file by specifying remote file path  

     synrest update-acl SAM=READ foo/file.txt

 - make a file world readable by specifying remote file path  

     synrest update-acl -g OTHER=READ foo/file.txt

 - update access control list for a directory by specifying remote directory path  

     synrest update-acl SAM=READ foo

 - update access control list for a storage object by specifying OID
   
     synrest update-acl SAM=READ -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-acl SAM=FULL_CONTROL -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-acl -g OTHER=READ -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
 def update_listable_metadata_examples
  puts <<-EXAMP

#{user_metadata_things_to_know}

Examples
 
 - update listable metadata for a file by specifying remote file path  

     synrest update-listbale-metadata town foo/file.txt
     synrest update-listbale-metadata town=annapolis foo/file.txt
     synrest update-listbale-metadata town=annapolis,capital=yes foo/file.txt

 -  update listable metadata for a directory by specifying remote directory path  

     synrest update-listbale-metadata town foo
     synrest update-listbale-metadata town=baltimore foo
     synrest update-listbale-metadata town=baltimore,capital=yes foo

 - update listable metadata tags for a storage object by specifying OID
   
     synrest update-listbale-metadata town -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-listbale-metadata town=columbia -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-listbale-metadata town=columbia,capital=yes -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def update_nonlistable_metadata_examples
  <<-EXAMP

#{user_metadata_things_to_know}

Examples

 - update nonlistable metadata for a file by specifying remote file path  

     synrest update-nonlistbale-metadata building foo/file.txt
     synrest update-nonlistbale-metadata building=house foo/file.txt
     synrest update-nonlistbale-metadata building=house,public=no foo/file.txt

 -  update nonlistable metadata for a directory by specifying remote directory path  

     synrest update-nonlistbale-metadata building foo
     synrest update-nonlistbale-metadata building=store foo
     synrest update-nonlistbale-metadata building=store,public=yes foo

 - update nonlistable metadata tags for a storage object by specifying OID
   
     synrest update-nonlistbale-metadata building -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-nonlistbale-metadata building=bar -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30
     synrest update-nonlistbale-metadata building=bar,public=yes foo -o 4a08bf2ea11f1e0b04a086663866a804a7c60fb30b30

  EXAMP
end

####---------------------------------------------------------------------------------------------------------
def versioning_things_to_know
   <<-KNOW
Things to know about versioning

 File or directory versions can only be accessed by OID.

 Deleting a file or directory will not delete its versions.

 Creating a version of a directory will create a version of all objects 
 in the directory 

 Creating a version of a previous file or directory version will create a version of the 
 current file or directory not the version on which the command was executed. 

 Metadata cannot be modified on file or directory versions.

 Metadata queries ignore meta-data assigned to file of directory versions.
  KNOW
end

####---------------------------------------------------------------------------------------------------------
def user_metadata_things_to_know
  <<-KNOW
Things to know about meta-data

 Metadata comes in two forms listable and nonlistable. Listable metadata is queryable
 with 'get-by-tab' and nonlistable metadata is not queryable.

 Files may be discovered by specifying either a name, listable meta tags or both. 

 File creation requires specification of either a remote file name of listable metadata tag.
 
 The tag is the name part of the listable metadata name=value pair. 

 The value is not required when specifying a listable metadata for object creation.

 Queries are only possible for metadata names (i.e queries for name=value are not supported).

 Meta-data tags cannot be removed from the global tag index.
  KNOW
end

####---------------------------------------------------------------------------------------------------------
def updating_things_to_know
  <<-KNOW
Things to know about updating

 Update does not delete storage objects before overwriting. 

 Update will acquire new storage space as required but will not release storage space.

 Management of a file pointer would be required to know the end of a file if the update 
 decreases the size of the file.
  KNOW
end

####---------------------------------------------------------------------------------------------------------
def acl_things_to_know
  <<-KNOW
Things to know about access control

 The only group access control list available is OTHER.

 User access control is specified with the user's UID.

 User and group access control privileges are only accepted for users with the
 same subtenant ID.

 Changing the access control list for a directory will not change the access
 control list for storage objects within the directory.

 Valid access control values are; NONE, FULL_CONTROL and READ.

 Once a user has been added to the User Access Control List it cannot be removed. Access
 can be disabled by setting the access control for he user to NONE.
  KNOW
end
