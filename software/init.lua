dofile("config.lua")

gpio.mode(0, gpio.INPUT, gpio.PULLUP) --Config mode button
gpio.mode(4, gpio.OUTPUT) --Config mode LED

if gpio.read(0)==0 then --Config mode
    gpio.write(4, gpio.LOW)
    dofile("config-mode.lua")
else --Normal mode (Send values)
    gpio.write(4, gpio.HIGH)
    dofile("error-timeout.lua")
    dofile("measurement.lua")
end
