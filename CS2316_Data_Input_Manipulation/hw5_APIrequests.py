# PE05 - APIs, requests, regex
import requests, re
from pprint import pprint

# API Question Instructions - MUST READ
###############################################################################
"""
It is HIGHLY recommended to use jupyter notebook to create and test
your code for this assignment in order to minimize your API requests.
Steps:
1) Navigate to your desired working directory via command line
2) In the command line type and execute: jupyter notebook
3) Navigate to the openned browser window running jupyter notebook
4) New (top right corner) > Python 3 (select dropdown)
5) Write your code in individual cells (you can insert and delete
cells as necessary). Each cell can contain one or numerous line(s)
of code.
6) jupyter notebook tutorial @5:20: https://www.youtube.com/watch?v=HW29067qVWk
"""

"""
Since APIs are often return very long and complicated JSON objects,
it is advisable to use Python’s built–in module called pprint and
to download and use the JSONView Google Chrome Extension:

https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en

These tools allow users to better visualize the keys and values
of python dicts and JSON objects.
"""
###############################################################################


# API Questions
###############################################################################
# Questions 1-3 use the World Bank Indicators API
###############################################################################
"""
For these questions, you will be utilizing the World Bank API.
This API allows users to access development indicators such as
poverty, education, and finance statistics about numerous countries.
Basic country information and statistics can be accessed by
utilizing various endpoints the API has to offer. For more
infoirmation about this API use the following link:

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation)

To access a country's basic identification information, the
country endpoint will be utilized:

https://api.worldbank.org/v2/country

For this particular endpoint, a response object of this data will
resemeble XML. In order to format the data as JSON, you must add
a query string (indicated by '?' and various paremeters combined
by '&') to the url:

https://api.worldbank.org/v2/country?format=json

Some optional query string parameters for the country endpoint are
'page' and 'per_page'.

For example:
https://api.worldbank.org/v2/country?format=json&per_page=1
https://api.worldbank.org/v2/country?format=json&page=2
https://api.worldbank.org/v2/country?format=json&per_page=1&page=2
https://api.worldbank.org/v2/country?format=json&page=2&per_page=1
"""
def get_countries_txt(num):
    response = requests.get("https://api.worldbank.org/v2/country?per_page="+str(num), 'html.parser')
    return response.content.decode(encoding="ISO-8859-1")
    """
    Question 1
    - Given a number of countries per page (int), write a function that returns
    the text attribute (str) of the response object from the World Bank
    Indicators API at the country endpoint and respective query string parameter.
    - The returned str should resemble XML.

    Args:
        num (int)
    Return:
        str

    >>> txt = get_countries_txt(10)
    >>> print(txt)
    ï»¿<?xml version="1.0" encoding="utf-8"?>
    <wb:countries page="1" pages="30" per_page="10" total="297" xmlns:wb="http://www.worldbank.org">
      <wb:country id="ABW">
        <wb:iso2Code>AW</wb:iso2Code>
        <wb:name>Aruba</wb:name>
        <wb:region id="LCN" iso2code="ZJ">Latin America &amp; Caribbean </wb:region>
    ...
        <wb:capitalCity>Yerevan</wb:capitalCity>
        <wb:longitude>44.509</wb:longitude>
        <wb:latitude>40.1596</wb:latitude>
      </wb:country>
    </wb:countries>

    >>> len(txt)
    5341
    """

def country_codes(astr):
    return re.findall('country id="(.*)"', astr)
    """
    Question 2
    - Given the value of get_countries_txt() (str), write a function that
    returns a list of country ids.
    - This MUST be done in ONE LINE.
    - Hint: Use the re function that returns a list of str.

    Args:
        astr (str)
    Return:
        list of str

    >>> txt = get_countries_txt(10)
    >>> country_codes(txt)
    ['ABW', 'AFG', 'AFR', 'AGO', 'ALB', 'AND', 'ARB', 'ARE', 'ARG', 'ARM']
    """

def country_info(num):
    txt = get_countries_txt(num)
    l1 = country_codes(txt)
    l2 = re.findall('name>(.*)<', txt)
    l3 = re.findall('capitalCity>(.*)<|capitalCity />', txt)
    l4 = re.findall('latitude>(.*)<|latitude />', txt)
    l5 = re.findall('longitude>(.*)<|longitude />', txt)
    dict = {}
    for i in range(len(l1)):
        subdict = {}
        if l4[i] == '' or l5[i] == '':
            continue
        subdict['country'] = l2[i]
        subdict['capitalCity'] = l3[i]
        subdict['longitude'] = float(l5[i])
        subdict['latitude'] = float(l4[i])
        dict[l1[i]] = subdict
    return dict
    """
    Question 3
    - Given a number of countries per page (int), write a function that returns
    a dict that maps country three-character ids to an inner dict of the
    respective country's information ONLY if the information has non-empty
    longitude and latitude coordinate values.
    - The inner dict should map the following keys to their respective value:
    'capitalCity' to the country's capital city (str),
    'id' to the country's three character id (str),
    'latitude' to the latitude of the country's capital city (float),
    'longitude' to the longitude of the country's capital city (float).
    - Hint: Pay attention to your string query parameters. The response object
    should get the API data in a JSON format.

    Args:
        num (int)
    Return:
        dict

    >>> cdict1 = country_info(2)
    {'ABW': {'capitalCity': 'Oranjestad',
         'country': 'Aruba',
         'latitude': 12.5167,
         'longitude': -70.0167},
     'AFG': {'capitalCity': 'Kabul',
             'country': 'Afghanistan',
             'latitude': 34.5228,
             'longitude': 69.1761}}

    >>> cdict2 = country_info(300)
    {'ABW': {'capitalCity': 'Oranjestad',
             'country': 'Aruba',
             'latitude': 12.5167,
             'longitude': -70.0167},
     'AFG': {'capitalCity': 'Kabul',
             'country': 'Afghanistan',
             'latitude': 34.5228,
             'longitude': 69.1761},
     'AGO': {'capitalCity': 'Luanda',
             'country': 'Angola',
             'latitude': -8.81155,
             'longitude': 13.242},
    ...
     'ZAF': {'capitalCity': 'Pretoria',
             'country': 'South Africa',
             'latitude': -25.746,
             'longitude': 28.1871},
     'ZMB': {'capitalCity': 'Lusaka',
             'country': 'Zambia',
             'latitude': -15.3982,
             'longitude': 28.2937},
     'ZWE': {'capitalCity': 'Harare',
             'country': 'Zimbabwe',
             'latitude': -17.8312,
             'longitude': 31.0672}}
    >>> len(cdict2)
    211
    """

###############################################################################
# Questions 4 uses the Sunrise Sunset API
###############################################################################
"""
For this question, you will be utilizing the Sunrise Sunset API.
This API allows users to access a geographic location's daily
daylight information. This ncludes the times of sunset, sunrise,
solar noon, and twilight, etc. Using the json endpoint, the
geographic location's longitude and latitude coordinates must be
specified as 'lat' and 'lng' query string parameters. For more
information on Sunrise Sunset API's guidelines, please use the
following link:

https://sunrise-sunset.org/api

"""

###############################################################################
# Question 5 uses the CryptoCompare API
###############################################################################
"""
For this question, you will be utilizing the CryptoCompare API.
This API allows users to access the trading information of any
cryptocurrency: including the current price of any cryptocurrency,
ts equivalent price in any other currency, the volume of currency
traded, etc. The different trading information can be accessed by
utilizing various endpoints the API has to offer. To access a
currency’s hourly trading volume data, the Hourly Exchange Volume
endpoint will be utilized. You can access the CryptoCompare API
and the Hourly Exchange Volume endpoint DOCUMENTATION here:

https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataExchangeHistoHour

The link above describes the url, respective endpoint, and any
specified query string parameters to use in your request.
"""
def crypto_volume(symbol, limit):
    url = "https://min-api.cryptocompare.com/data/exchange/histohour?tsym=" + symbol + "&limit=" + str(limit)
    response = requests.get(url)
    data = response.json()['Data']
    vol_time = []
    for d in data:
        vol_time.append((d['volume'], d['time']))
    dict = {}
    dict[symbol] = (min(vol_time)[1], min(vol_time)[0])
    return dict
    """
    Question 5
    - Given a cryptocurrency trading symbol and the limit of time data points,
    write a function that returns a dict that maps the cryptocurrency
    symbol to a tuple of the time when the lowest volume of the currency was
    traded and the respective lowest volume.
    - You should use the CryptoCompare API in this function and the
    Hourly Exchange Volume endpoint here:

    https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataExchangeHistoHour

    - Hint: the built-in python min() function may be useful. min() takes in one
    argument that must be an iterable datatype. If its argument is a list of
    tuples, the min funtion will return the tuple with the smallest 0th index
    value.
    - Note: this API updates frequently, so your returned values will differ
    from the test cases.

    Args:
        symbol (str)
        limit (int)
    Return:
        dict

    >>> crypto_volume('BTC', 10)
    {'BTC': (1623988800, 29780.52)}

    >>> crypto_volume('LTC', 12)
    {'LTC': (1623988800, 6801275.16)}

    >>> crypto_volume('ETH', 37)
    {'ETH': (1623963600, 431273.64)}
    """

if __name__ == '__main__':
    pass # replace this line of code with your test cases
