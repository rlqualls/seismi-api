seismi-api 
========== 

Description 
-----------

seismi-api is a library for interacting with the seismi.org API, which 
returns information about earthquakes. 

Installation 
------------ 

TODO: INSTALLATION 

Examples 
-------- 

    client = Seismi::API::Client.new 
    client.yearly_total(2011) 
    client.monthly_total(2009, 11) 

    client.during_year(2013).each do |quake| 
      puts "#{quake.timedate}: #{quake.magnitude}" 
    end 

    client.during_month(2009, 11).each do |quake| 
      puts "#{quake.lat}, #{quake.lon}" 

Copyright 
---------

Copyright (c) 2013 Robert Qualls. See LICENSE.txt for
further details.

