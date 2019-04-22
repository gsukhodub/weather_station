#!/usr/bin/env python
import thingspeak
import time
import Adafruit_DHT
 
channel_id = 648344 # PUT CHANNEL ID HERE
write_key  = 'B19FJE06TA36V9PE' # PUT YOUR WRITE KEY HERE
read_key   = 'C6YFHEP08CPAPN4R' # PUT YOUR READ KEY HERE
pin = 5
pin2 = 6
sensor = Adafruit_DHT.DHT22
 
def measure(channel):
    try:
        humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
        humidity2, temperature2 = Adafruit_DHT.read_retry(sensor, pin2)
	# write
        response = channel.update({'field1': temperature, 'field2': 
humidity,'field3': temperature2, 'field4': humidity2})
        
        # read
        read = channel.get({})
        print("Read:", read)
        
    except:
        print("connection failed")
 
 
if __name__ == "__main__":
    channel = thingspeak.Channel(id=channel_id, write_key=write_key, api_key=read_key)
    while True:
        measure(channel)
        # free account has an api limit of 15sec
        time.sleep(180)

