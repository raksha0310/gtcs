#PE08 - pandas

########################
# Do NOT change imports
import numpy as np
import pandas as pd
########################


################################################################################
# Cleaning Data
################################################################################
def csv_parser(filename):
    return pd.read_csv(filename)
    """
    Question 1
    - Given a str of a csv file name with its extension (filename), return a
    pandas DataFrame of its data.
    - This MUST be done in ONE LINE.

    Args:
        filename (str)

    Return:
        pd.DataFrame

    >>> clean_df = csv_parser("claims.csv")
    >>> len(clean_df)
    2042
    >>> clean_df.head()
      Claim Number Date Received  ...      Disposition
    0     0616610L     17-Oct-02  ...              NaN
    1        20565      7-Nov-02  ...  Approve in Full
    2        20856     19-Nov-02  ...             Deny
    3        28383     25-Nov-02  ...           Settle
    4        29859      4-Dec-02  ...           Settle
    """


def percent_coverage_column(df):
    df['Percent Covered'] = (df['Close Amount'] * 100 / df['Claim Amount']).round(1)
    """
    Question 2
    - Given the returned pandas DataFrame of airport luggage data from
    Question 1, add a new column titled "Percent Covered".
    - This new column should calculate the percentage of the claim amount
    ('Claim Amount', float) that was paid out (column 'Close Amount',
    float).
    - If the Close Amount column cells are NaN then the corresponding Percent
    Covered cell should be 0.0.
    - Round the percentages to the first decimal place.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.
    - Hint: remember how vectorized operations can be applied to pandas Series

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    >>> percent_coverage_column(clean_df)
    >>> clean_df.head()
      Claim Number Date Received  ...  Percent Covered
    0     0616610L     17-Oct-02  ...              NaN
    1        20565      7-Nov-02  ...            100.0
    2        20856     19-Nov-02  ...              0.0
    3        28383     25-Nov-02  ...             69.0
    4        29859      4-Dec-02  ...             75.0
    """

def clean_nan(df):
    df.dropna(subset=['Incident Date', 'Airport Code', 'Percent Covered'], inplace=True)
    """
    Question 3
    - Given the mutated pandas DataFrame from Question 2, remove/drop rows
    with NaN (np.nan) values in their 'Incident Date', 'Airport Code'
    and/or 'Percent Covered' columns and reset the DataFrame index.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    >>> clean_nan(clean_df)
    >>> len(clean_df)
    1448
    >>> clean_df.head()
      Claim Number Date Received  ... Percent Covered
    2        20856     19-Nov-02  ...             0.0
    3        28383     25-Nov-02  ...            69.0
    4        29859      4-Dec-02  ...            75.0
    5     0717505M     12-Dec-02  ...             0.0
    6     1216000L     16-Dec-02  ...           100.0
    """

def clean_index(df):
    df.reset_index(inplace=True, drop=True)

    """
    Question 4
    - Given the mutated pandas DataFrame Question 3, reset the
    DataFrame's index.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    >>> clean_index(clean_df)
    >>> clean_df.head()
      Claim Number Date Received  ... Percent Covered
    0        20856     19-Nov-02  ...             0.0
    1        28383     25-Nov-02  ...            69.0
    2        29859      4-Dec-02  ...            75.0
    3     0717505M     12-Dec-02  ...             0.0
    4     1216000L     16-Dec-02  ...           100.0
    """

def year_column(df):
    df['Year'] = pd.to_datetime(df['Incident Date']).dt.year
    """
    Question 5
    - Given the returned pandas DataFrame from Question 4, add a new column
    titled "Year".
    - This new column should be an int of the year for each 'Incident Date'.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.
    - Hint: pd.DatetimeIndex() or str methods may be helpful

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    >>> year_column(clean_df)
    >>> clean_df.head()
      Claim Number Date Received  ... Percent Covered Year
    0        20856     19-Nov-02  ...             0.0 2002
    1        28383     25-Nov-02  ...            69.0 2002
    2        29859      4-Dec-02  ...            75.0 2002
    3     0717505M     12-Dec-02  ...             0.0 2002
    4     1216000L     16-Dec-02  ...           100.0 2002
    """

def month_column(df):
    df['Month'] = pd.to_datetime(df['Incident Date']).dt.month
    """
    Question 6
    - Given the mutated pandas DataFrame from Question 5, add a new column
    titled "Month".
    - This new column should be an int of the month for each 'Incident Date'.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.
    - Hint: pd.DatetimeIndex() or str methods may be helpful

    Args:
        df (pd.DataFrame)

    Return:
        NoneType (default)

    >>> month_column(clean_df)
    >>> clean_df.head()
      Claim Number Date Received  ... Percent Covered Year Month
    0        20856     19-Nov-02  ...             0.0 2002    10
    1        28383     25-Nov-02  ...            69.0 2002    10
    2        29859      4-Dec-02  ...            75.0 2002    11
    3     0717505M     12-Dec-02  ...             0.0 2002    11
    4     1216000L     16-Dec-02  ...           100.0 2002    11
    """

def export_excel(df, filename, my_sheet):
    df.to_excel(filename, sheet_name=my_sheet, index=False)
    """
    Question 7
    - Given the mutated pandas DataFrame from Question 6, a str of an excel file name
    with its extension (filename), and a str of a sheet name (my_sheet), write the
    DataFrame to a new excel file.
    - Do NOT write the indices to the excel file.
    - Do NOT use list/dict comprehensions.

    Args:
        df (pd.DataFrame)
        filename (str)
        sheetname (str)

    Return:
        NoneType (default)

    >>> export_excel(clean_df, 'my_cleaned_data.xlsx', 'Claim Data')
    #Exected file: col [A, P] and rows [1, 1449]
    """

################################################################################
# Analyzing Data
################################################################################
def coverage_by_airport_code(df):
    return df.groupby('Airport Code').mean().round(2)[['Claim Amount', 'Percent Covered']]
    """
    Question 8
    - Given the clean pandas DataFrame from Question 6, return a new pandas
    DataFrame of the mean 'Claim Amount' and mean 'Percent Covered' for each
    'Airport Code'.
    - Round averages the second decimal place.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.

    Args:
        df (pd.DataFrame)

    Return:
        pd.DataFrame

    >>> df8 = coverage_by_airport_code(clean_df)
    >>> df8.head()
                  Claim Amount  Percent Covered
    Airport Code
    ABE                 455.88             0.00
    ABI                1654.06             0.00
    ABQ                  75.04            61.38
    ACT                 251.63             0.00
    AEX                2967.50            50.00
    """

def claims_per_month_per_year(df):
    return df[['Year', 'Month', 'Claim Number']].groupby(['Year', 'Month']).size()
    """
    Question 9
    - Given the clean pandas DataFrame from Question 6, return a new pandas
    DataFrame that contains the 'Year', the 'Month' for each 'Year', and
    the corresponding number of cleams for each month of each year.
    - This MUST be done in ONE LINE.
    - Do NOT use list/dict comprehensions.
    - Hint: Remember that the .groupby() method can groupby take in a list of columns.

    Args:
        df (pd.DataFrame)

    Return:
        pd.DataFrame

    >>> df9 = claims_per_month_per_year(clean_df)
    >>> df9.head()
    Year  Month
    2002     9         1
             10        3
             11        4
             12        5
    2003     1        13
    """
    
    if __name__ == '__main__':
    pass
