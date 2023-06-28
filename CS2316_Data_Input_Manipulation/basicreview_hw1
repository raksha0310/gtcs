
def welcome_to_2316():
    print ("School's back for summer!")
    
def get_digits(astr):
    string=""
    for char in astr:
        if char in "1234567890":
            string+=char
    return string

def combine_list(word_list):
    return ' '.join([w.upper() for w in word_list if len(w)%2==1])


def remove_duplicates(dup_list):
    return sorted(set(dup_list))


def reverse_it(iterable):
    return iterable[-1::-1]


def characters_in_season(adict, season_num):
    l=[]
    for i in adict:
        if season_num in adict.get(i):
            l.append(i)
    return(set(l))

def create_usernames(name_list):
    usernames = []
    for name in name_list:
        words = name.split()
        usernames.append((words[0][0] + words[1] + str(len(words[0]))).lower())
    return usernames
