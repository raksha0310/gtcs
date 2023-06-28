# PE09 -sql

# Do NOT Change Imports
#########################
import pymysql
from pprint import pprint
import getpass
#########################

def create_cursor(host_name, user_name, pw, db_name):
    '''Do NOT alter this function'''
    try:
        connection = pymysql.connect(host = host_name, user = user_name, password = pw, db = db_name, \
                                    charset = "utf8mb4", cursorclass = pymysql.cursors.Cursor)
        cursor = connection.cursor()
        return cursor
    except Exception as e:
        print(e)
        print(f"Couldn't log in to MySQL server using this password: {pw}.\n")



def query0(cursor, min_value):
    '''Sample'''
    query = 'SELECT * FROM dept_emp WHERE emp_no < %s;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (min_value,))
    result = cursor.fetchall()
    return result

def query1(cursor):
    '''Fill in the query'''
    query = 'SELECT dept_name, dept_no FROM departments WHERE dept_name = \'Research\' OR dept_name = \'Development\';'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query2(cursor):
    '''Fill in the query'''
    query = 'SELECT emp_no, salary FROM salaries WHERE salary BETWEEN 155513 AND 158220;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query3(cursor, my_emp):
    '''Fill in the query'''
    query = 'SELECT * FROM salaries WHERE emp_no = %s ORDER BY salary DESC;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (my_emp,))
    result = cursor.fetchall()
    return result

def query4(cursor):
    '''Fill in the query'''
    query = 'SELECT emp_no, dept_no FROM dept_emp WHERE YEAR(to_date)= 9999 ORDER BY from_date LIMIT 5;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query5(cursor, title):
    '''Fill in the query'''
    query = 'SELECT title, COUNT(title) FROM titles WHERE title = %s;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (title,))
    result = cursor.fetchall()
    return result

def query6(cursor):
    '''Fill in the query'''
    query = 'SELECT titles.title, count(title) FROM employees INNER JOIN titles ON titles.emp_no = employees.emp_no WHERE employees.gender = \'F\' AND titles.title LIKE \'%Engineer%\' GROUP BY titles.title;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query7(cursor):
    '''Fill in the query'''
    query = 'SELECT emp_no, MIN(salary) FROM salaries GROUP BY emp_no ORDER BY MIN(salary) LIMIT 5;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query8(cursor, minimum):
    '''Fill in the query'''
    query = 'SELECT dept_no, COUNT(*) FROM dept_manager GROUP BY dept_no HAVING COUNT(dept_no) > %s;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (minimum,))
    result = cursor.fetchall()
    return result

def query9(cursor, job_title):
    '''Fill in the query'''
    query = 'SELECT gender, count(title) FROM employees INNER JOIN titles ON titles.emp_no = employees.emp_no WHERE titles.title = %s GROUP BY employees.gender;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (job_title,))
    result = cursor.fetchall()
    return result

def query10(cursor):
    '''Fill in the query'''
    query = 'SELECT employees.first_name, employees.last_name FROM employees INNER JOIN dept_emp on employees.emp_no = dept_emp.emp_no GROUP BY employees.emp_no HAVING COUNT(dept_no) > 1 ORDER BY last_name, first_name LIMIT 10;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def main():

    ################ Insert MySQL Server password if applicable ################

    user_password = getpass.getpass('\n# Enter your MySQL Server password: ')
    cursor = create_cursor('localhost', 'root', user_password, 'employees')

    ############################################################################
    # If using the command line to test your code (not reccommended),
    # then test your code below (nested in def main() block).

    # Query 0
    # print(">>> query0(cursor)")
    # pprint(query0(cursor, 10005))

def create_cursor(host_name, user_name, pw, db_name):
    '''Do NOT alter this function'''
    try:
        connection = pymysql.connect(host = host_name, user = user_name, password = pw, db = db_name, \
                                    charset = "utf8mb4", cursorclass = pymysql.cursors.Cursor)
        cursor = connection.cursor()
        return cursor
    except Exception as e:
        print(e)
        print(f"Couldn't log in to MySQL server using this password: {pw}.\n")

def query11(cursor, emp_no, birth_date, first_name, last_name, gender, hire_date):
    '''Fill in the query'''
    query = 'INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s);'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query, (emp_no, birth_date, first_name, last_name, gender, hire_date))
    result = cursor.fetchall()
    return result

def query12(cursor):
    '''Fill in the query'''
    query = 'UPDATE dept_emp SET to_date = CAST(\'2021-07-01\' AS DATETIME) WHERE YEAR(to_date)= 9999;'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

def query13(cursor):
    '''Fill in the query'''
    query = 'DELETE FROM dept_emp WHERE dept_no > \'d005\';'
    '''DO NOT CHANGE THE CODE BELOW'''
    cursor.execute(query)
    result = cursor.fetchall()
    return result

if __name__ == '__main__':
    main()
