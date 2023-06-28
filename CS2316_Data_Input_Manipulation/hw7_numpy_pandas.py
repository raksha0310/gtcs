#PE07 - numpy & some pandas

########################
# Do NOT change imports
import numpy as np
import pandas as pd
########################


def team_performance(game_points, shooting_accuracy, injured_players):

    return game_points*shooting_accuracy- injured_players
    """
    Question 1
    - The Hawks, currently playing in the Eastern Conference finals, are having
    a fantastic playoff run. We want to see how the Hawks and other Eastern
    Conference teams have perfomed in the playoffs.
    - Given a 2D numpy array of a team's game points in playoff games per week
    (game_points), the team's average shooting accuracy (shooting_accuracy),
    and the team's number of injured players (injured_players), return a numpy
    array of the team's calculated performance per game.
    - The team's performance per game is calculated as follows: each game point
    multiplied by the shooting accuracy. Each of these product values should
    then be subtracted by the number of injured players.
    - Each row in the given game points numpy array represents the game
    points of a single week. Each value in the given game points numpy array
    represents the game points of a single game, as shown:
            #game 1  #g2  #g3  #g3  #g4, etc
        array([[110,  99,  89, 105,  78],    #week 1
               [ 68,  70,  89, 116,  74],    #week 2
               [102,  72,  98, 116, 100]])   #week 3, etc
     Note: number of games and weeks may vary.
    - This MUST be done in ONE LINE.

    Args:
        game_points (np.array)
        shooting_accuracy (float)
        injured_players (int)

    Returns:
        np.array

    >>> arr1 = np.array([[110, 99, 89, 105, 78], [68, 70, 89, 116, 74]])
    >>> team_performance(arr1, 0.6, 5)
    array([[61. , 54.4, 48.4, 58. , 41.8],
           [35.8, 37. , 48.4, 64.6, 39.4]])

    """

def jersey_numbers(num):
    return np.array([i for i in range(0, 100) if i%num == 0])
    """
    Question 2
    - There was a malfunction in jersey production. Now, only multiples of a
    given integer from 0,99 (inclusive) can be sold.
    - Given an int (num) from 0,99 (inclusive), return a 1D numpy array of
    all of the possible jersey numbers that can be sold.
    - This MUST be done in ONE LINE.

    Args:
        num (int)

    Return:
        np.array

    >>> arr2 = jersey_numbers(3)
    >>> arr2
    array([ 0,  3,  6,  9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48,
       51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99])
    >> len(arr2)
    34
    """

def leading_scorers(players):
    return players[players != "Trae Young"]
    """
    Question 3
    - Ahead of Game 4, Hawks coach, Coach McMillan, wants to know who he should
    play since Trae Young is injured.
    - Given an array of leading scorers (players) from games this season,
    return a numpy array of scorers (player names (str)) who are not Trae Young
    ('Trae Young' (str)).
    - This MUST be done in ONE LINE.
    - Hint: use masking

    Args:
        players (np.array)

    Return:
        np.array

    >>> arr3 = np.array(["Trae Young", "Clint Capela", "Kevin Huerter",
                        "John Collins", "Trae Young", "Bogdan Bogdanov",
                        "Trae Young", "Lou Williams"])
    >>> leading_scorers(arr3)
    array(['Clint Capela', 'Kevin Huerter', 'John Collins', 'Bogdan Bogdanov',
       'Lou Williams'])
    """

def slicing(game_points, week, start, end):
    for i in range(start, end + 1): game_points[week - 1][i - 1] += 11
    """
    Question 4
    - Megan is a little superstitious. She forgot to wear her lucky jersey
    during some of the games, so she thinks that those games are an inaccurate
    measure of the Hawks performance.
    - Given a 2D numpy array of a team's game points in playoff games per week
    (game_points), the week (week), and the starting (start) and ending (end)
    games that Megan forgot to wear her lucky jersey, mutate the given numpy
    array so that the games indicated by the week and start, end range
    (inclusive) have their scores increased by 11 points.
    - This MUST be done in ONE LINE.
    - Hint:     #game 1  #g2  #g3  #g3  #g4, etc
            array([[110,  99,  89, 105,  78],    #week 1
                   [ 68,  70,  89, 116,  74],    #week 2
                   [102,  72,  98, 116, 100]])   #week 3, etc
     Note: number of games and weeks may vary.

    Args:
        game_points (np.array)
        week (int)
        start (int)
        end (int)

    Return:
        NoneType (default)

    >>> arr4 = np.array([[110, 99, 89, 105, 78], [68, 70, 89, 116, 74]])
    >>> slicing(arr4, 1, 2, 3)
    >>> arr4
    array([[110, 110, 100, 105,  78],
           [ 68,  70,  89, 116,  74]])
    """

def my_aggregate(game_scores):

    return np.amax(np.sum(game_scores,axis=0))
    """
    Question 5
    - Some salty Philadelphia fans have begun to think that a series should be
    won based on the total number of points when all 7 games in the series are
    played.
    - Given a numpy array of game scores (game_scores), return the total number
    of points of the winning team if the winner was declared based on which team
    had the greatest number of total points in all games.
    - This MUST be done in ONE LINE.
    - Hint: game_scores will have the following format:
                #team 1  #t2
            array([[128, 124],  #game 1
                   [102, 118],  #game 2
                   [111, 127],  #game 3
                   [103, 100],  #game 4
                   [109, 106],  #game 5
                   [ 99, 104],  #game 6
                   [103,  96]]) #game 7, etc
     Note: number of games may vary.

    Args:
        game_scores (np.array)

    Returns:
        int

    >>> arr5 = np.array([(128, 124), (102, 118), (111, 127), (103, 100), (109, 106), (99, 104), (103, 96)])
    >>> my_aggregate(arr5)
    775
    """


def hawks_wins(game_scores):
    return np.resize(np.array([1 if i > j else 0 for i, j in zip(game_scores[:, 0], game_scores[:, 1])]), (len(game_scores), 1))
    """
    Question 6
    - Given a numpy array of game scores (game_scores), return a numpy array
    where the games that the Hawks won are represented by a 1 (int), the games
    that the Hawks lost are represented by a 0 (int).
    - Ties will be considered as a Hawks' loss.
    - The returned array should be then be formatted so that it resembles a
    column vector (2D array with only 1 column).
    - This MUST be done in ONE LINE.
    - Hint: game_scores will have the following format:
                 #Hawks  #Oponent
            array([[128, 124],      #game 1
                   [102, 118],      #game 2
                   [111, 127],      #game 3
                   [103, 100],      #game 4
                   [109, 106],      #game 5
                   [ 99, 104],      #game 6
                   [103,  96]])     #game 7, etc
     Note: number of games may vary.

    Args:
        game_scores (np.array)

    Returns:
        np.array

    >>> arr6 = np.array([(128, 124), (102, 118), (111, 127), (103, 100), (109, 106), (99, 104), (103, 96)])
    >>> hawks_wins(arr6)
    array([[1],
           [0],
           [0],
           [1],
           [1],
           [0],
           [1]])
    """

def get_hawks_win_df(game_scores, win_arr):
    return pd.DataFrame(np.concatenate((game_scores, win_arr), axis=1), columns=['Hawks', 'Opponent', 'Hawks Win'], index=[i + 1 for i in range(len(win_arr))])
    """
    Question 7
    - Given a numpy array of game scores (game_scores) as described in
    Question 6 and the returned numpy array (win_arr) from Question 6, return a
    pandas DataFrame that is formatted as follows:
            #games_scores        #win_arr
          | 'Hawks'| 'Opponent'| 'Hawks Win'
       ---|--------|-----------|------------
        1 |    128 |       124 |          1     #game 1
        2 |    102 |       118 |          0     #game 2
        3 |    111 |       127 |          0     #game 3
        4 |    103 |       100 |          1     #game 4
        5 |    109 |       106 |          1     #game 5
        6 |     99 |       104 |          0     #game 6
        7 |    103 |        96 |          1     #game 7, etc
     Note: number of games may vary.
    - The retruned pandas DataFrame should have indicies starting at 1, and its
    column should be labeled accordingly:
     "Hawks"
     "Opponent"
     "Hawks Win"
    - This MUST be done in ONE LINE.
    - Hint 1: np.concatenate() may be useful
    - Hint 2: this is the only question that uses pandas

    Args:
        game_scores (np.array)
        win_arr (np.array)

    Returns:
        pd.DataFrame

    >>> arr7_1 = np.array([(128, 124), (102, 118), (111, 127), (103, 100), (109, 106), (99, 104), (103, 96)])
    >>> arr7_2 = hawks_wins(arr6)
    >>> get_hawks_win_df(arr7_1, arr7_2)
       | 'Hawks'| 'Opponent'| 'Hawks Win'
    ---|--------|-----------|------------
     1 |    128 |       124 |          1
     2 |    102 |       118 |          0
     3 |    111 |       127 |          0
     4 |    103 |       100 |          1
     5 |    109 |       106 |          1
     6 |     99 |       104 |          0
     7 |    103 |        96 |          1
    """

def nested_where(game_points):
    return np.select([game_points < 100, game_points < 110, game_points >= 110], [':(', ':)', ':D'])
    """
    Question 8
    - Liv wants to create a simple visual based on how happy she is after each
    Hawks game.
    - Given a numpy array of Hawks game points, return a numpy array where
     1) the games that the Hawks earn less than 100 points are represented by a
     ':(' (str),
     2) the games that the Hawks earn [100, 110) points are represented by a
     ':(' (str), and
     3) the games that the Hawks earn more than 110 points are represented by a
     ':D' (str).
    - This MUST be done in ONE LINE.

    Args:
        game_points (np.array)

    Returns:
        np.array

    >>> arr5 = np.array([128, 102, 111, 103, 109, 99, 103])
    >>> nested_where(arr5)
    array([':D', ':)', ':D', ':)', ':)', ':(', ':)'])
    """


def high_scores(scores):

    return scores[(scores >= np.nanmean(scores)) | np.isnan(scores)]
    
    """
    Question 9
    - Zayyen wants to filter out scores that are lower than the mean average
    score of all given games.
    - Given a numpy array of game points (scores), which may include NaN
    (np.nan) values, return a 1D numpy array only of game points that are
    greater than or equal to the mean of all non NaN game points or that are NaN
    values themselves.
    - This MUST be done in ONE LINE.
    - Hint 1: np.isnan() may be useful
    - Hint 2: it may also be useful to use Google to determine if there is a
    built-in numpy function that takes the average (mean) of all non NaN values.
    This process of googling, discovering, and reading documentation on new
    functions and/or modules is very valuable in Phase II and Phase III of your
    final project.
    - Hint 3: a correct answer may incur a warning message. You may ignore the
    warning; however, it is good coding practice to still understand why a
    warning occured. You can find out more about a warning message by reading
    the message itself, reading documentation, and/or googling.

    Args:
        scores (np.array)

    Returns:
        np.array

    >>> arr9 = np.array([[70, np.nan, 58, 92, 68],
                        [62, 82, 64, 70, 85]])
    >>> high_scores(arr9)
    array([nan, 92., 82., 85.])
    """

if __name__ == '__main__':
    pass
