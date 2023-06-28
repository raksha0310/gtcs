# PE06 - regex, BeautifSoup, Final Project Phase II help
#############################
#Do not change imports
from bs4 import BeautifulSoup
import re
import pandas as pd
from pprint import pprint
#############################

################################################################################
# Questions 1-4 use regex
################################################################################
def find_dates(target):
    return( re.findall(r'07-[012][0-9]-[0-9]{4}|07-[3][01]-[0-9]{4}', target))

    """
    Question 1
    - Given a str (target), return a list of dates (str) that are in July. The
    days must be in the range [0,31] inclusive, but the year can be any number.
    - The date will be in format MM-DD-YYYY.
    - This MUST be done in ONE LINE.
    - Do NOT use list comprehensions.

    Args:
        target (str)
    Return:
        list of str

    >>> find_dates("Outer-Banks: Release 07-30-2021 New Season")
    ['07-30-2021']
    >>> find_dates("The Mysterious06-29-2021:Benedict Society!! 07-49-2001")
    []
    >>> find_dates("Gossip:Girl 07-80-1990-07-08-2021, Imprac07-23-1999tical Jokers")
    ['07-08-2021', '07-23-1999']
    """

def atl_hawks(target):
    return re.findall(r"(\d+)", target)[0:-1:2]
    """
    Question 2
    - Given a str containing game scores information of the NBA playoffs, return
    a list of points (str) scored by the Atlanta Hawks.
    - The Hawks' points will always be listed first.
    - Each team's scores will be seperated by spaces and a dash.
    - Each game will be seperated by a comma.
    - This MUST be done in ONE LINE.
    - Do NOT use list comprehensions.

    Args:
        target (str)
    Return:
        list of str

    >>> atl_hawks("Hawks vs. Bucks: 116 - 113, Hawks vs. Sixers: 103 - 96")
    ['116', '103']

    >>> atl_hawks("Hawks vs. Sixers: 99 - 104")
    ['99']
    """
