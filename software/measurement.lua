print("Send values")

connection_attempts = 0

tmr.alarm(1,1000, 1, function()
    if wifi.sta.getip()==nil then
        connection_attempts = 1 + connection_attempts
        print("Wait for IP address")

        if (connection_attempts > RETRIES) then --Connection failed
            print("Connection could not be established. Going to sleep")
            node.dsleep(SLEEP_PERIOD)
        end
    else
        print("Connected. Reading sensor")
        supply_voltage = 3.3 / 65536 * adc.readvdd33()

        status, temp, humi, temp_dec, humi_dec = dht.read(DHT11_PIN)
        if status == dht.OK then
    

         print("DHT Temperature:"..temp..";".."Humidity:"..humi)
        elseif status == dht.ERROR_CHECKSUM then
            print( "DHT Checksum error." )
        elseif status == dht.ERROR_TIMEOUT then
            print( "DHT timed out." )
        end

        sent = 0
        m = mqtt.Client("clientid", 120)

        m:on("connect", function(client) print ("connected") end)
        m:on("offline", function(client)
            print ("offline") 
        end)
        tmr.stop(1)
        m:connect("test.mosquitto.org", 1883, 0, function(client)
          print("connected")
        
          client:publish("/smartnoob/temperatur", temp, 0, 1, function(client)
            print("Published temperature")
            SENT_TEMP = true
            client:publish("/smartnoob/feuchtigkeit", humi, 0, 1, function(client)
                print("Published humidity")
                SENT_HUMI = true
                client:publish("/smartnoob/voltage", supply_voltage, 0, 1, function(client)
            print("Published voltage")
            SENT_VOLTAGE = true
            m:close()
          end)
              end)
          end)
          
          
          
          

        end,
        function(client, reason)
          print("failed reason: " .. reason)
        end)
        
        m:close()

    
        
    end
end)