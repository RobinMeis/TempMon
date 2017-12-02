-- Error timeout ensures re-entering sleep mode if connection failed. Call this function, when timeout is reached

seconds_running = 0
tmr.alarm(2,1000, 1, function()
    if (seconds_running >= MAX_TIME) then
        print("Timeout! Going to sleep")
        node.dsleep(SLEEP_PERIOD)
    end

    if (SENT_TEMP and SENT_HUMI and SENT_VOLTAGE) then
        print("All done! Going to sleep")
        node.dsleep(SLEEP_PERIOD)
    end
    seconds_running = seconds_running + 1
    
end)