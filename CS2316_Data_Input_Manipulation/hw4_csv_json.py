# PE04 - csv and json
import csv, json
#only imports allowed
from pprint import pprint


def read_txt(input_file):
    output=[]
    fin= open(input_file, "r")
    for line in fin:
        c= line.split(",")
        output.append(c[:2]+c[3:-1])
    return output
        
    """
    Question 1
    - The menu.txt file contains google trend data about the popularity of
    fine dining menus.
    - Read menu.txt with File I/O or CSV.
    - Return a list of lists where each nested list contains the str values
    delimited by commas of a single line of text. Each of the str values should
    exclude any trailing or leading whitespace.
    - Exclude the columns "Olive Garden Menu" and "Red Lobster Menu"

    Args:
        input_file (str)
    Returns:
        list

    >>> mylist1 = read_txt("menu.txt")
    >>> pprint(mylist1)
    [['Month', "Chili's Menu", "Applebee's Menu", 'Outback Steakhouse Menu'],
     ['2004-01', '2', '2', '2'],
     ['2004-02', '2', '2', '1'],
     ['2004-03', '1', '2', '1'],
     ['2004-04', '1', '1', '1'],
     ['2004-05', '0', '2', '1'],
    ...
    ]
    >>> len(mylist1)
    210

     with open ("menu.txt","r") as fin:
        lines=fin.readlines()
        stripped_newlines=[line.strip() for line in lines]
        split_data = [line.split(",") for line in stripped_newlines]
        return split_data
    """


def write_to_json(cleaned_list, output_file):
    a_dict = {}
    for i in range(1, len(cleaned_list)):
        month, current_month= "", {}
        for j in range(len(cleaned_list[0])):
            if(cleaned_list[0][j] == 'Month'):
                month = cleaned_list[i][j]
            else:
                current_month[cleaned_list[0][j]] = cleaned_list[i][j]
        a_dict[month] = current_month

    with open(output_file, "w") as fin:
        fin.write(json.dumps(a_dict))
        fin.close()
    return a_dict
    """
    Question 2
    - Given the returned list from Question 1 as cleaned_list, create a dict
    that maps the month to an inner dict that maps menus to their respective
    popularity. This means that the inner dict keys should be
    "Chili's Menu", "Applebee's Menu", "Outback Steakhouse Menu"
    with their values being the digit str values to which they correspond.
    - Write this dict to a JSON file whose complete filename is passed in
    as the output_file parameter.
    - Return the dict.

    Args:
        cleaned_list (list)
        output_flie (str)
    Returns:
        dict

    >>> mydict2 = write_to_json(read_txt("menu.txt"), "outq2.txt")
    >>> pprint(mydict2)
    {'2004-01': {"Applebee's Menu": '2',
                 "Chili's Menu": '2',
                 'Outback Steakhouse Menu': '2'},
    '2004-02': {"Applebee's Menu": '2',
                "Chili's Menu": '2',
                'Outback Steakhouse Menu': '1'},
    '2004-03': {"Applebee's Menu": '2',
                "Chili's Menu": '1',
                'Outback Steakhouse Menu': '1'},
    ...
    }
    >>> len(mydict2)
    209
    """
