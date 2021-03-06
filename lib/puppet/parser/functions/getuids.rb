#
#
#
module Puppet::Parser::Functions
  newfunction(:getuids, :type => :rvalue, :doc =><<-EOS
This function queries the password file and filters for grid pool accounts.
it returns a two dimensional hash containing uids and gids for these accounts

EOS
              ) do |args|
    
    require 'rubygems'
    require 'etc'
    require 'yaml'
    require 'net/ldap'
    
    def populateFromPasswd 
      getUIDof = Hash.new()
      getUIDof["uid"] = Hash.new()
      getUIDof["gid"] = Hash.new()
      Etc.passwd {|u| 
        if (u.gecos =~ /Grid-User/)
          uname = u.name
          getUIDof["uid"][uname.to_s()] = u.uid.to_s() 
          getUIDof["gid"][uname.to_s()] = u.gid.to_s() 
        end
      }
      return getUIDof
    end
    
    def populateFromLdap
      getUIDof = Hash.new()
      getUIDof["uid"] = Hash.new()
      getUIDof["gid"] = Hash.new()
      ldap = Net::LDAP.new
      ldap.host = "xldap.cern.ch"
      ldap.port = "389"
      
      is_authorized = ldap.bind
      filter = "displayname = *Grid-User*"
      attrs = ["name", "uidNumber", "gidNumber", "displayName"]
      ldap.search( :base => "ou=Users,ou=Organic Units,dc=cern,dc=ch", :attributes => attrs, :filter => filter, :return_result => true ) do |entry|
        name = ""
        uid  = ""
        gid  = ""
        entry.attribute_names.each do |n|
          case "#{n}"
          when "name"
            name = "#{entry[n]}"
          when "uidnumber"
            uid = "#{entry[n]}"
          when "gidnumber"
            gid = "#{entry[n]}"
          end
        end
        getUIDof["uid"][name] = uid.to_s()
        getUIDof["gid"][name] = gid.to_s() 
      end  
      return getUIDof
    end
    
    
    filename = '/var/cache/poolaccounts/uids.yaml'
    if (File.exists?(filename))
      getUIDof = YAML.load(File.open(filename)) 
    else
      getUIDof = populateFromLdap()
    end
    return getUIDof
  end
end
