#!/usr/bin/python3

# PEP Guidelines:
################################COMMENT################################
#####################################CODE#####################################   

#############################
# We got company.           #
# Imports?                  #
# How many?                 #
# Uh, all of them, I think. #
#############################

import sys
import os
import re
import argparse
import urllib.request
import xml.etree.ElementTree as ET 
import math
import unicodedata
from datetime import datetime, timedelta
from ast import literal_eval

DATE_FORMAT = "%d/%m/%Y"
FULL_FORMAT = "%d/%m/%Y %H.%M"


""" PROJECT ASSUMPTIONS

 -> All arguments are separated just by commas ','
    and NOT by comma and space ', ' !!!

 -> Metros can only go in lists, and checks for all metro stations
    that come as an argument. Lists are disjunctive (OR).

 -> Dates are parsed as a list. Each list can contain either a string
    (single date) or a tuple (interval of dates). No lists are allowed
    inside dates, as it would be pointless for its evaluation.
    Also, It doesn't matter if the interval numbers are positive 
    or negative, dates will be normalized.

 -> The top 5 metro stations are sorted by their exits. Also, other 
    public transport services (bus, tram...) won't be parsed, 
    excluding FGC (they a part of the metro network!)
 
 -> The script will automatically open the generated XML with Firefox
    on (at least) GNU/Linux, not any other browsers or OSs. 
    If you don't have it installed, you'll have to open the file
    <index.html> manually.

 -> Children are people under 18 y.o. Note that sometimes the keywords
    may produce unsuitable results. These are NEVER intended!

"""

####################
# Argument parsing #
####################

parser = argparse.ArgumentParser()
parser.add_argument('--key', 
    help='select items containing keys', 
    type=str
)
parser.add_argument('--date', 
    help='get items on date (or interval of dates)', 
    type=str
)
parser.add_argument('--metro', 
    help='get metro stations from BCN\'s metro. Range: 1..11', 
    type=str
)
args = parser.parse_args()

Args_Keys  = []
Args_Dates = []
Args_Metro = []


###########
# Classes #
###########
 
class Address:
    def __init__(self, locRoot):
        asimp = locRoot.find('.//adreca_simple')
        self.name = asimp.find('carrer').text
        self.numero = int(asimp.find('numero').text)
        self.barri = asimp.find('barri').text
        self.coord = self._Process_Coord(locRoot.find('.//coordenades'))
            
    def _Process_Coord(self, coord): # PRIVATE
        gMaps = coord.find('googleMaps')
        lontxt = gMaps.get('lon')
        lattxt = gMaps.get('lat')
        try:
            lon = float(lontxt)
            lat = float(lattxt)
            return (lat, lon)
        except :
            return (-1.0, -1.0) # Unknown location -> No metro for you


    def __repr__(self):
        return self.name + " \n   " + self.barri + "\n   C " + str(self.coord) 

    def getName(self): 
        return self.name + ', ' + str(self.numero)
    
    def getNumber(self): 
        return self.numero

    def getBarri(self): 
        return self.barri

    def getLongitude(self): 
        return self.coord[1]
    
    def getLatitude(self): 
        return self.coord[0]


class Event:
    def __init__(self, act, ageRange):
        self.name = act.find('nom').text
        self.address = Address(act.find('.//lloc_simple'))
        self.age = ageRange

        day = act.find('.//data_proper_acte').text
        self.date = datetime.strptime(day, FULL_FORMAT)


    def getName(self): 
        return self.name
    
    def getAddress(self): 
        return self.address

    def getAge(self): 
        return self.age

# ADD/SUBTRACT TIME IN days USING TODAY AS A REFERENCE: 
# datetime.today() {+|-} timedelta(days=5)
#
    
    def getFullDate(self):
        return self.getDateAsDTDT().strftime(FULL_FORMAT)
    
    def getDate(self):
        return self.getDateAsDTDT().strftime(DATE_FORMAT)

    def getDateAsDTDT(self):
        return self.date


    def __repr__(self):
        name = self.name 
        addr = "\n  " + self.address.__repr__()
        age  = "\n    " + self.age
        date = "\n    " + self.date.strftime(DATE_FORMAT) + "\n"
        return name + addr + age + date


    def getLongitude(self):
        return self.address.getLongitude()
    

    def getLatitude(self):
        return self.address.getLatitude()


""" 
    Note: Metro stations appear several times, but on the
    ranking there (may not) be any stations repeated!
"""
class Metro:
    def __init__(self, act):
        self.name = clean(act.find('Tooltip').text)[:-1] #remove '-'
        self.lat = float(act.find('Coord').find('Latitud').text)
        self.lon = float(act.find('Coord').find('Longitud').text)
    

    def __repr__(self):
        return self.name + " [" + str(self.lat) + ", " + str(self.lon) + "]"


    def getFullName(self):
        return self.name


    def getStationName(self):
        return self.name[:string.index(" (")]
    

    def getLongitude(self):
        return self.lon
    

    def getLatitude(self):
        return self.lat


####################################################
# Functions: data parsing, maths, cleaning, etc... #
####################################################



def fillKeys(Keys):
    return literal_eval(Keys)

def fillDate(Dates):
    rgx = "([0-3][0-9]/[0-1][0-9]/[0-9][0-9][0-9][0-9])"
    regex_dates = re.sub(rgx, "\"\g<1>\"", Dates)
    return literal_eval(regex_dates)

def fillMetro(Metros):
    return Metros[1:-1].split(',')

    
# Get all current activities suitable for children 
def Children_Activities():
    Dict = dict()
    # Expressions that will (or may) return activities for kids
    # Assumed these age ratings per filter found *at first*
    filters = [
        ('famil', "Per a tots els públics"), 
        ('nadal', "Per a tots els públics"), 
        ('infant', "De 3 a 11 anys"),
        ('titell', "De 0 a 8 anys"),
        ('petit', "De 2 a 10 anys"),
        ('escol', "De 3 a 16 anys"), 
        ('jug', "De 5 a 15 anys"),
        ('sport', "De 7 a 18 anys"),
        ('jove', "De 10 a 18 anys")
    ]

    for fltr in filters:
        for act in root_events.findall('.//acte'):
            name = clean( act.find('nom').text ) 

            llocsimp = act.find('.//lloc_simple')
            lloc = clean( llocsimp.find('nom').text ) 

            adrec = llocsimp.find('.//adreca_simple')
            if (adrec.find('barri').get('codi') != ""): 
                barri = clean( adrec.find('barri').text )
                if fltr[0] in (name or lloc or barri):
                    Dict[name] = Event(act, fltr[1]) 

    return Dict

## Filters for keys ##

# Checks if word is in event
def findWord(event, word):
    name = clean(event.getName())
    lloc = clean(event.getAddress().getName())
    barri = clean(event.getAddress().getBarri())
    return word in (name or lloc or barri)

def check(event, Expr_Filter):
    #BASE CASE:
    if type(Expr_Filter) is str:
        return findWord(event, Expr_Filter)
    
    #LIST CASE, recursive AND
    elif type(Expr_Filter) is list:
        return all(check(event, item) for item in Expr_Filter)
    
    #TUPLE CASE, recursive OR
    elif type(Expr_Filter) is tuple:
        return any(check(event, item) for item in Expr_Filter)

    #Debug case, should never happen.
    else: return False



## Filters for dates ##

def findDate(event, datestr):
    tmpDate = datetime.strptime(datestr, DATE_FORMAT).date()
    EventDate = event.getDateAsDTDT().date()
    
    return (EventDate == tmpDate)


def findDateTuple(event, datetup):
    tmpDate = datetime.strptime(datetup[0], DATE_FORMAT).date()
    DateMin = tmpDate - timedelta(days = abs(datetup[1]))
    DateMax = tmpDate + timedelta(days = abs(datetup[2]))
    EventDate = event.getDateAsDTDT().date()
    
    return (DateMin <= EventDate  <= DateMax)

def dateCheck(event, DateList):
    #BASE CASE => One item, check if event matches day:
    if type(DateList) is str:
        return findDate(event, DateList)
    
    #TUPLE CASE (Base case 2), check interval
    elif type(DateList) is tuple:
        return findDateTuple(event, DateList)
    
    #LIST CASE, recursive OR
    elif type(DateList) is list:
        return any(dateCheck(event, item)  for item in DateList )
    
    #Debug case, should never happen.
    else: return False


# Only parse stations from the lines chosen
def parseMetroArgs(Args_Metro):
    getMetro = dict()
    for fm in Args_Metro:
        for metroBoca in root_metro.findall('Punt'):
            station = metroBoca.find('Tooltip').text
            if fm in station :
                if 'METRO' in station:
                    getMetro[station] = Metro(metroBoca)
                elif 'FGC' in station:
                    getMetro[station] = Metro(metroBoca) 
    return getMetro


# Parse each and every metro station!
def parseMetro():
    getMetro = dict()
    for metroBoca in root_metro.findall('Punt'):
        station = metroBoca.find('Tooltip').text
        if 'METRO' in station:
                getMetro[station] = Metro(metroBoca) 
        elif 'FGC' in station:
                getMetro[station] = Metro(metroBoca) 
    return getMetro


# Get best 5 metro exits per event
def EventsWithTop5Metro(Dict, Metro):
    MetroDict = dict()
    for i in Dict:  
        LisTop = list()
        for j in Metro:
            k = distances(Dict[i], Metro[j])
            if (k < 500):
                LisTop.append( (k, Metro[j].getFullName()) )

        ListFilt = sorted(LisTop)[:5]
        MetroDict[i] = ListFilt[:5]
    return MetroDict


##########################
# Functions: maths + aux #
##########################


#Calculating distance: First vals from origin point,
# next vals from (potential) destination
def getDistance(lat_ori, lon_ori, lat_dest, lon_dest):
    Earth_radius = 6371000
    
    #Radians
    rad_lat1  = math.radians(lat_ori)
    rad_lat2 = math.radians(lat_dest)

    #Deltas for latitude and longitude
    DLat = math.radians(lat_dest - lat_ori) 
    DLon = math.radians(lon_dest - lon_ori)
    
    #Math stuff
    sin_lat = math.sin(DLat/2) ** 2
    mults = math.cos(rad_lat2) * math.cos(rad_lat1) *math.sin(DLon/2) ** 2
    merge = sin_lat + mults
    tgs = 2*( math.atan2(math.sqrt(merge), math.sqrt(1-merge)) )

    return Earth_radius * tgs


def distances(Cand, Metro):
    lat_ori = Cand.getLatitude()
    lon_ori = Cand.getLongitude()
    lat_dest = Metro.getLatitude()
    lon_dest = Metro.getLongitude()

    return getDistance(lat_ori, lon_ori, lat_dest, lon_dest)

#Get dictionary intersection
def dict_intersect(*dicts):
    comm_keys = dicts[0].keys()
    for d in dicts[1:]:
        comm_keys &= d.keys()

    result = { key : 
        {d[key] for d in dicts} 
        for key in comm_keys
    }
    return result

def clean(str):
    # NFKD for ensuring max compatibility
    normal = unicodedata.normalize('NFKD', str.lower()) 
    ascii_str =  normal.encode('ascii', 'ignore').decode('ascii')
    return ascii_str


def loadXML(N):
    if (N == 'events'):
        link = "http://w10.bcn.es/APPS/asiasiacache/peticioXmlAsia?id=199"
    elif (N == 'metro'):
        link0 = "http://opendata-ajuntament.barcelona.cat/"
        link = link0 + "resources/bcn/TRANSPORTS GEOXML.xml"
    
    socket = urllib.request.urlopen(link)
    xml_Source = socket.read()
    socket.close()
    return ET.fromstring(xml_Source)


##############################
# Functions: HTML generation #
##############################

def inflateTable(MStats, Dict):
    strng = ""
    try:
        for i in Dict:
            name = Dict[i].getName()
            strng += "<tr><td>" + name + """</td>
            <td>""" + Dict[i].getAddress().getName() + """</td> 
            <td>""" + Dict[i].getFullDate() + """</td>
            <td>""" + Dict[i].getAge() + "</td><td><ul>"
            for j in MStats[i]:
                num = str(j[0])[:7]
                plc = str(j[1])
                strng +=  "<li>" + num + " m <br>" + plc + "</li>"
            strng += "</ul></td></tr>"
        return strng
    except Exception as e:
        print("FATAL ERROR: ", e)
        return ""



def createHTML(MStats, Dict):
    try:
        website = open("index.html", "w")
        headr = "<!DOCTYPE html><meta charset=\"utf-8\"/>\
        <html><head><title>BCN Events [LP]</title></head><body><div>\
        <h2> Events pròxims: </h2><table><tr><th>NOM</th><th>ADREÇA\
        </th><th>DATA I HORA</th><th>EDAT RECOMANADA</th><th>\
        SORTIDA DE METRO A < 500 m</th></tr>"

        inflate = inflateTable(MStats, Dict)
        bottom = "</table></div></body></html>"
        website.write(headr + inflate + bottom)
        website.close()
        return True
    except Exception as e:
        print("FATAL ERROR: ", e)
        return False

# PRE-REQUIREMENT: Firefox installed
def launchHTML():
    print("Launching HTML on Firefox... :-)")
    args = "firefox  index.html &"
    os.system(args)

###############################################
# Main, except it's not defined as such (yet) #
###############################################

# XML Parsing
root_events = loadXML('events')
root_metro = loadXML('metro')

if __name__ == "__main__":
    debug = False

    if (args.key):   Args_Keys  = fillKeys(args.key) 
    if (args.date):  Args_Dates = fillDate(args.date) 
    if (args.metro): Args_Metro = fillMetro(args.metro) 

    if debug:

        print("--------< List Debug >--------")
        print(Args_Keys)
        print(Args_Dates)
        print(len(Args_Dates))
        print(Args_Metro)
        print("--------< /List Debug >-------")
    

    print("Getting all activities suitable for children...")

    Candidates = Children_Activities()
    
    if debug:
        for i in Candidates: 
            print(Candidates[i])

    print("Filtering by keys (if any) ...")

    Dict = dict()
    if (len(Args_Keys) > 0): 
        Dict = { i : 
            Candidates[i] for i in Candidates
            if check(Candidates[i], Args_Keys)
        }
    else: 
        Dict = Candidates

    if debug:
        for i in Dict: print(i)

    print("Filtering by dates (if any) ...")

    DictD = dict()
    if (len(Args_Dates) != 0): 
        Dict = { i : 
            Dict[i] for i in Dict
            if dateCheck(Dict[i], Args_Dates)
        }

    if debug:
        for i in Dict: print(i)

    print("Filtering selected metro lines (if any) ...")

    DictM = dict()
    if (len(Args_Metro) != 0): 
        DictM = parseMetroArgs(Args_Metro)
    else:
        DictM = parseMetro()


    print("Getting 5 nearest metro stations by event")
    Top5 = EventsWithTop5Metro(Dict, DictM)
    

    print("Generating HTML with data")
    web_success = createHTML(Top5, Dict)
    if web_success: 
        launchHTML()
