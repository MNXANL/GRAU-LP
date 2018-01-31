#!/usr/bin/python3
import urllib.request
import xml.etree.ElementTree as ET


sock = urllib.request.urlopen("http://wservice.viabicing.cat/getstations.php?v=1") 
xmlSource = sock.read()                            
sock.close()

#print(xmlSource)                              

root = ET.fromstring(xmlSource)


def printEmAll():
    for station in root.findall('station'):
        # Get all child values from a station
        for childs in station:
            print(childs.text)

        
#for acte in root.findall('*//acte'):
    ##print('acte')
    #fnom = acte.find('nom')
    #if 'visit' in fnom.text.lower():
        #print(fnom.text) # Name
        ##print(acte.find('*//data_proper_acte').text) # Time


def StationsWithMoreThanXBikes(n):
    for station in root.findall('station'):
        nums = int( station.find('slots').text )
        street = station.find('street')
        if (n > nums):
            print(street.text)

def OpenStations():
    for station in root.findall('station'):
       street = station.find('street')
       status = station.find('status')
       if 'OPN' in status.text.upper():
            print(street.text)

printEmAll()
print("----------------")
StationsWithMoreThanXBikes(3)
print("----------------")
OpenStations()
