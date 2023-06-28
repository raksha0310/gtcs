# PE02 - OOP and Comprehensions

# DO NOT CHANGE IMPORTS
#######################
import copy
#######################

class Team:
    """
    Question 1
    - Initialize and complete the Team class.
    """
    def __init__(self,mascot,city,league,seed=0):
        self.mascot=mascot
        self.city=city
        self.league=league
        self.seed=seed
        """
        Question 1a
        - An instance of the Team class should be initialized with the following
        attributes:
            mascot (str)
            city (str)
            league (str)
            seed (int, default = 0)

        >>> team = Team("Hornets", "Charlotte", "NBA", 10)
        >>> team.mascot
        'Hornets'
        >>> team.city
        'Charlotte'
        >>> team.league
        'NBA'
        >>> team.seed
        10
        """
    
    def __eq__(self,o):
        return True if self.mascot==o.mascot and self.city==o.city else False


        """
        Question 1b
        - Two Teams objects are equal if and only if they share the same mascot
        and the same city.
        - This MUST be done in ONE LINE.

        >>> team1 = Team("Hornets", "Charlotte", "NBA", 10)
        >>> team2 = Team("Hornets", "Charlotte", "WNBA", 1)
        >>> team1 == team2
        True

        >>> team1 = Team("Hornets", "Charlotte", "NBA", 10)
        >>> team2 = Team("Hornets", "Charleston", "NBA", 10)
        >>> team1 == team2
        False
        """
        

    def __lt__(self,o):
        return True if self.seed>o.seed else False
        """
        Question 1c
        - A Team object is less than another Team object if and only if its seed
        is greater than the other. (This is because 1 is the highest and best seed.)
        - This MUST be done in ONE LINE.

        >>> dream_team = Team("Dream", "Atlanta", "WNBA", 7)
        >>> lib_team = Team("Liberty", "New York", "WNBA", 1)
        >>> dream_team < lib_team
        True
        """

    def __str__(self):
        return "GO {} {}!".format(self.city,self.mascot).upper()
        """
        Question 1d
        - Printing a Team object should output the following str:
            "GO {city} {mascot}!" #all characters in this str should be uppercase
        - This MUST be done in ONE LINE.

        >>> print(Team("Dream", "Atlanta", "WNBA", 7))
        GO ATLANTA DREAM!
        """

    def __repr__(self):
        return "The {} {} are the {} seed in the {}.".format(self.city,self.mascot,self.seed,self.league)
        """
        Question 1e
        - A Team object should be officially and unambiguously represented as the
        following str:
            "The {city} {mascot} are the {seed} seed in the {league}."
        - This MUST be done in ONE LINE.

        >>> alist = [Team("Jazz", "Utah", "NBA", 1), Team("Hornets", "Charlotte", "NBA", 10)]
        >>> alist
        [The Utah Jazz are the 1 seed in the NBA., The Charlotte Hornets are the 10 seed in the NBA.]
        """

def assign_teams_to_owners(owners_list, team_list):
    return {owner.split()[1]:team.city[:3].upper() for owner,team in zip(owners_list, team_list)}
    """
    Question 2
    - Given a list of owners as strs and a list of corresponding Team objects,
    write a function that returns a dict that maps the owner's last name to
    their team abbreviation. The team abbreviation should be the first three
    characters of the Team object's city (all capitalized).
    - This MUST be done in ONE LINE. Hint: use a dict comprehension!

    Args:
        owners_list (list)
        team_list (list)

    Returns:
        dict

    >>> owners = ["Micky Arison", "Michael Jordan", "Mark Cuban"]

    >>> team_arison = Team("Heat", "Miami", "NBA", 6)
    >>> team_jordan = Team("Hornets", "Charlotte", "NBA", 10)
    >>> team_cuban = Team("Mavericks", "Dallas","NBA", 5)
    >>> teams = [team_arison, team_jordan, team_cuban]

    >>> assign_teams_to_owners(owners, teams)
    {"Arison": "MIA", "Jordan": "CHA", "Cuban": "DAL"}
    """

def playoff_cutoff(playoff_teams, losing_team):
    return [team if team.seed==1 else Team(team.mascot,team.city,team.league,team.seed-1) for team in playoff_teams if team!= losing_team]


    """
    Question 3
    - Given a list of playoff Team objects and a losing Team object, write a
    function that returns a new list of playoff Teams that does not contain the
    losing Team object.
    - The Team objects in the new playoff list should better (decrease)
    their seed by 1 only if their original seed is greater than 1.
    - This MUST be done in ONE LINE. Hint: use a list comprehension!

    Args:
        playoff_teams (list)
        removal_target (Team)
    Returns:
        list

    Example:
        >>> hawk_team = Team("Hawks", "Atlanta", "NBA", 5)
        >>> horn_team = Team("Hornets", "Charlotte", "NBA", 10)
        >>> nug_team = Team("Nuggets", "Denver", "NBA", 1)
        >>> winning_teams = [hawk_team, horn_team, nug_team]

        >>> playoff_cutoff(winning_teams, horn_team)
        [The Atlanta Hawks are the 4 seed in the NBA., The Denver Nuggets are the 1 seed in the NBA.]
    """


def move_team(team, new_city):
    team_object = copy.deepcopy(team);
    team_object.city=new_city
    return team_object
    """
    Question 4
    - Suppose you are a team manager and your team gets moved to a different
    city, but you want to keep the record of the old Team object.
    - Create a deep copy of the given Team object and change their
    city to the new city.

    Args:
        team (Team)
        new_city (str)
    Return:
        Team object

    >>> old_record = Team("Clippers", "Los Angeles", "NBA", 4)
    >>> new_record = move_team(old_record, "San Diego")

    >>> old_record
    The Los Angeles Clippers are the 4 seed in the NBA.
    >>> new_record
    The San Diego Clippers are the 4 seed in the NBA.

    >>> team2 == team1
    False
    """


################################################################################
if __name__ == "__main__":
    """
    This is the if __name__ == "__main___": code block that you learned in class.
    Remember the pyhton interpreter will only read the code below if the statement
    above evaluates to True. Therefore, the code below will only execute if
    this .py file is run as a script (i.e. running it through the command line
    via python PE02.py). This code will not execute when run via the Gradescope
    autograder because the autograder grades your code by importing your PE
    .py file (i.e. import PE02.py). This implies that you can test your code
    in this code block, and the function calls below will neither execute nor
    error in Gradescope when run via the autograder. Good luck!

    Note: You should be able to trace and understand the code below. If you have
    any questions in regards to this code, please make a public post on the ED
    Discussion Board, so everyone can benefit.
    """

    #q1a
    team = Team("Hornets", "Charlotte", "NBA", 10)
    print('q1a', 'PASSED' if team.mascot == 'Hornets' and team.city == 'Charlotte' and team.league == 'NBA' and team.seed == 10 else False)

    #q1b
    team1 = Team("Hornets", "Charlotte", "NBA", 10)
    team2 = Team("Hornets", "Charlotte", "WNBA", 1)
    print('q1b', 'PASSED' if team1 == team2 else False)

    team1 = Team("Hornets", "Charlotte", "NBA", 10)
    team2 = Team("Hornets", "Charleston", "NBA", 10)
    print('q1b', 'PASSED' if not (team1 == team2) else False)

    #q1c
    dream_team = Team("Dream", "Atlanta", "WNBA", 7)
    lib_team = Team("Liberty", "New York", "WNBA", 1)
    print('q1c', 'PASSED' if dream_team < lib_team else False)

    #q1d
    print('q1d', 'PASSED' if str(Team("Dream", "Atlanta", "WNBA", 7)) == 'GO ATLANTA DREAM!' else False)

    #q1e
    alist = [Team("Jazz", "Utah", "NBA", 1), Team("Hornets", "Charlotte", "NBA", 10)]
    print('q1e', 'PASSED' if [repr(t) for t in alist] == ['The Utah Jazz are the 1 seed in the NBA.', 'The Charlotte Hornets are the 10 seed in the NBA.'] else False)

    #q2
    owners = ["Micky Arison", "Michael Jordan", "Mark Cuban"]
    team_arison = Team("Heat", "Miami", "NBA", 6)
    team_jordan = Team("Hornets", "Charlotte", "NBA", 10)
    team_cuban = Team("Mavericks", "Dallas","NBA", 5)
    teams = [team_arison, team_jordan, team_cuban]
    print('q2', 'PASSED' if assign_teams_to_owners(owners, teams) == {"Arison": "MIA", "Jordan": "CHA", "Cuban": "DAL"} else False)

    #q3
    hawk_team = Team("Hawks", "Atlanta", "NBA", 5)
    horn_team = Team("Hornets", "Charlotte", "NBA", 10)
    nug_team = Team("Nuggets", "Denver", "NBA", 1)
    winning_teams = [hawk_team, horn_team, nug_team]
    print('q3', 'PASSED' if [repr(t) for t in playoff_cutoff(winning_teams, horn_team)]
        == ['The Atlanta Hawks are the 4 seed in the NBA.', 'The Denver Nuggets are the 1 seed in the NBA.'] else False)

    #q4
    old_record = Team("Clippers", "Los Angeles", "NBA", 4)
    new_record = move_team(old_record, "San Diego")
    print('q4', 'PASSED' if repr(old_record) == 'The Los Angeles Clippers are the 4 seed in the NBA.' else False)
    print('q4', 'PASSED' if repr(new_record) == 'The San Diego Clippers are the 4 seed in the NBA.' else False)
    print('q4', 'PASSED' if not(team2 == team1) else False)
