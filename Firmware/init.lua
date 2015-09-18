gpio.mode(4,gpio.OUTPUT) -- RED LED - Set as OUTPUT
gpio.mode(5,gpio.OUTPUT) -- White/blue LED - Set as OUTPUT
gpio.mode(7,gpio.INPUT) -- Push button input pin - Set as INTPUT

gpio.write(4, gpio.HIGH)  -- Turn off Red LED, Active LOW
gpio.write(5, gpio.LOW)   -- Turn off White/blue LED

--CONFIG 
api_key = "xxxxxxxxx" --Enter Your thingspeak api KEY Here

--Wifi Details, your wifi router or AP credentials 
ssid= "mySSID" -- Enter Your WIFI SSID Here
pswrd= "mywifiPWD" -- Enter Your WIFI Password Here

--Meter Details 
--Ex. 1000 imp/kHw => imp=1000 and kWh=1
--Ex. 3200 imp/kHw => imp=3200 and kWh=1
--Ex. 1000 imp/kHw => imp=1000 and kWh=1
imp=1000
kWh=1

--Vars
tE = 0 
last = 0
last_sent = 0
count= 0

function test_wifi()
    print("test wifi ") 
    if (wifi.sta.status() == 5) then     
            gpio.write(4, gpio.HIGH) 
    else
            gpio.write(4, gpio.LOW) 
    end
end

function launch()
  test_wifi()
  gpio.mode(6,gpio.INT,gpio.PULLUP) 
  gpio.trig(6, "down",counter) --set a trigger on the falling edge.
end

function send_counter(count,tempo)
    test_wifi()
    power=(3600000*imp/tempo)  
    power=power*count*kWh
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print("Pd: "..payload) conn:close() end)         
    conn:connect(80,"184.106.153.149") -- thingspeak IP
    conn:send("GET /update?key="..api_key.."&field1="..power.." \r\n Host:api.thingspeak.com\r\n"
    .."Connection: close\r\nAccept: */*\r\n\r\n")
    conn:on("sent",function(c) conn:close() end)
end

function counter(level)
    if level==1 then  -- "debounce" only falling edge is to be considered.
        return 
    end  
    if  ((tmr.now()<tE) or (tmr.now()-tE > 10000)) then        
        tE=tmr.now() 
        count=count+1
        tempo=(tE-last) 
        if (last == 0) then
            last=tmr.now()
            count=0
        end

        gpio.write(5, gpio.HIGH) --blink to indicate the pulse
        tmr.delay(1000)
        gpio.write(5, gpio.LOW) 

        if (((tmr.now()-last_sent<0) or  (tmr.now()-last_sent) >= 15500000) and count>0) then   
            send_counter(count,tempo)
            last=tE 
            last_sent=tmr.now()
            count=0
        end 
    end
end

--CODE

print("set wifi ") 
wifi.setmode(wifi.STATION) -- Set Wifi mode as Station, to connect the the rou
wifi.sta.config(ssid,pswrd)
wifi=nil
ssid=nil

--Start listening for pulses
print("set trigger ")
launch() 


       