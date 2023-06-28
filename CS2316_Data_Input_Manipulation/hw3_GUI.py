#Base version

import sys, random
import math
from random import randint
from PyQt5.QtWidgets import (
    QApplication,
    QWidget,
    QPushButton,
    QRadioButton,
    QHBoxLayout,
    QVBoxLayout,
    QLabel,
    QLineEdit
)

class RandomNumberGenerator(QWidget):

    def __init__(self):
        #everything in self scope is required to be named the same
        super(RandomNumberGenerator, self).__init__()
        #set window title
        self.setWindowTitle("Random Number Generator")
        #set attributes - do NOT change attribute names
        self.pick_int=QRadioButton()
        self.pick_int.setStyleSheet("font: bold")
        self.pick_int.setText("Integer")
        self.pick_float =QRadioButton()
        self.pick_float.setStyleSheet("font:bold")
        self.pick_float.setText("Float")

        self.lower_bound = QLabel()
        self.lower_bound.setStyleSheet("font: italic; color:red;")                            
        self.lower_bound.setText("Lower Bound:")
        self.upper_bound = QLabel()
        self.upper_bound.setText("Upper Bound:")
        self.upper_bound.setStyleSheet("font: italic; color:green;")
        self.output = QLabel()
        self.output.setText("Generator in progress")

        self.set_lower_bound = QLineEdit()
        self.set_lower_bound.setStyleSheet("font: Comic Sans MS; background-color: yellow; color: blue;")
        self.set_upper_bound = QLineEdit()
        self.set_upper_bound.setStyleSheet("background-color: yellow; color: blue;")

        self.check_my_bounds = QPushButton("Check My Bounds")
        self.randomize = QPushButton("Randomize!")
        self.my_reset = QPushButton("Reset")

        #set attribute default status
        self.pick_int.setChecked(True)
        self.randomize.setEnabled(False)
        self.my_reset.setEnabled(False)

        #connect buttons
        self.check_my_bounds.clicked.connect(self.check_bounds)
        self.randomize.clicked.connect(self.get_random_number)
        self.my_reset.clicked.connect(self.reset_all)


        ##############################################################
        #Create your own layout. You may use or ignore
        # the layout skeleton below.
        #It is ok if your layout differs from the example,
        # as long as all features are shown and functional.
        #Remember to set your layout!
        ##############################################################
        #layout (is base layout horizintal (hbox) or vertical (vbox))
        vbox = QVBoxLayout()
        #level 1 -hbox
        hbox2=QHBoxLayout()
        hbox2.addWidget(self.pick_int)
        hbox2.addWidget(self.pick_float)

        #level 2 -hbox
        hbox1=QHBoxLayout()
        hbox1.addWidget(self.lower_bound)
        hbox1.addWidget(self.set_lower_bound)
        hbox1.addWidget(self.upper_bound)
        hbox1.addWidget(self.set_upper_bound)

        vbox.addLayout(hbox2)
        vbox.addLayout(hbox1)

        #level 3 -widget
        vbox.addWidget(self.check_my_bounds)
        #level 4 -widget
        vbox.addWidget(self.randomize)
        #level 5 -widget
        vbox.addWidget(self.check_my_bounds)
        #level 6 -widget
        vbox.addWidget(self.output)
        vbox.addWidget(self.my_reset)
        #set layout
        self.setLayout(vbox)

    ###################################################################
    #this method is given to you; do NOT change for PE03 base
    def is_num_inputs(self):
        #This method is given to you b/c it uses try/except statements
        # which are not covered in this course. Although try/except
        # statements are not testable material, they are useful to know.
        # For more info, official try/except documentation is below:
        # https://docs.python.org/3/tutorial/errors.html
        tupsinlist = [(self.set_lower_bound, self.set_upper_bound)]
        for a, b in tupsinlist:
            if a.isEnabled() and b.isEnabled():
                try:
                    float(a.text())
                except:
                    a.setText('')
                    try:
                        float(b.text())
                    except:
                        b.setText('')
                    return False
                try:
                    float(b.text())
                except:
                    b.setText('')
                    return False
        return True
    ###################################################################

    def check_bounds(self):
        ############################
        #do NOT change for PE03 base
        if not self.is_num_inputs():
            return None
        ############################
        #Your code goes here:
        lower=float(self.set_lower_bound.text())
        upper=float(self.set_upper_bound.text())

        if self.pick_int.isChecked()==True:
            self.pick_float.setDisabled(True)

        if self.pick_float.isChecked()==True:
            self.pick_int.setDisabled(True)

        if lower>upper:
            self.set_lower_bound.setText("")
            self.set_upper_bound.setText("")
        else:
            self.randomize.setEnabled(True)
            self.my_reset.setEnabled(True)
            self.set_lower_bound.setDisabled(True)
            self.set_upper_bound.setDisabled(True)
            self.check_my_bounds.setDisabled(True)

        if lower<upper and self.pick_int.isChecked()==True:
            lower=float(self.set_lower_bound.text())
            upper=float(self.set_upper_bound.text())
            self.set_lower_bound.setText(str(int(lower)))
            self.set_upper_bound.setText(str(int(upper)))


    def get_random_number(self):

        if self.pick_int.isChecked()==True:
            lower=int(self.set_lower_bound.text())
            upper=int(self.set_upper_bound.text())
            r=randint(lower,upper)
            self.output.setText("My random number is "+str(r))
            return r

        if self.pick_float.isChecked()==True:
            lower=float(self.set_lower_bound.text())
            upper=float(self.set_upper_bound.text())
            r=random.uniform(lower,upper)
            self.output.setText("My random number is "+str(r))
            return r


    def reset_all(self):
        self.pick_int.setEnabled(True)
        self.pick_float.setEnabled(True)
        self.lower_bound.setEnabled(True)
        self.upper_bound.setEnabled(True)
        self.set_lower_bound.setEnabled(True)
        self.set_upper_bound.setEnabled(True)
        self.check_my_bounds.setEnabled(True)
        self.randomize.setDisabled(True) #can also use .setEnabled(False)
        self.my_reset.setDisabled(True) #can also use .setEnabled(False)
        self.set_lower_bound.setText('')
        self.set_upper_bound.setText('')
        self.output.setText('Generator in progress')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = RandomNumberGenerator()
    main.show()
    exit_code = app.exec_()
    sys.exit(exit_code)
    
"""Extra Credit: Many aesthetic changes (text/background colors, font styles/types), Added QMessageBox feature, 
Added extra functionality of a calculator with an add, subtract, multiply, divide button (along with a zero division error box)
for the inputted numbers"""

import sys, random
import math
from random import randint
from PyQt5.QtWidgets import (
    QApplication,
    QWidget,
    QPushButton,
    QRadioButton,
    QHBoxLayout,
    QVBoxLayout,
    QMessageBox,
    QLabel,
    QLineEdit
)

class RandomNumberGenerator(QWidget):

    def __init__(self):
        #everything in self scope is required to be named the same
        super(RandomNumberGenerator, self).__init__()
        #set window title
        self.setWindowTitle("Random Number Generator")
        #set attributes - do NOT change attribute names
        self.pick_int=QRadioButton()
        self.pick_int.setStyleSheet("font: bold") #extra credit
        self.pick_int.setText("Integer")
        self.pick_float =QRadioButton()
        self.pick_float.setStyleSheet("font:bold") #extra credit
        self.pick_float.setText("Float")

        self.lower_bound = QLabel()
        self.lower_bound.setStyleSheet("font: italic; color:red;")      #extra credit                       
        self.lower_bound.setText("Lower Bound:")
        self.upper_bound = QLabel()
        self.upper_bound.setText("Upper Bound:")
        self.upper_bound.setStyleSheet("font: italic; color:green;") #extra credit
        self.output = QLabel()
        self.output.setText("Generator in progress")

        self.set_lower_bound = QLineEdit()
        self.set_lower_bound.setStyleSheet("font: Comic Sans MS; background-color: yellow; color: blue;") #extra credit
        self.set_upper_bound = QLineEdit()
        self.set_upper_bound.setStyleSheet("background-color: yellow; color: blue;") #extra credit

        self.check_my_bounds = QPushButton("Check My Bounds")
        self.randomize = QPushButton("Randomize!")
        self.my_reset = QPushButton("Reset")

        #set attribute default status
        self.pick_int.setChecked(True)
        self.randomize.setEnabled(False)
        self.my_reset.setEnabled(False)

        #connect buttons
        self.check_my_bounds.clicked.connect(self.check_bounds)
        self.randomize.clicked.connect(self.get_random_number)
        self.my_reset.clicked.connect(self.reset_all)

        self.divide_button = QPushButton("Divide")                                   #extra credit 
        self.divide_button.setEnabled(False)
        self.divide_button.clicked.connect(self.divide_todo_item)
        self.set_lower_bound.textChanged.connect(self.enable_divide_button)
        self.set_upper_bound.textChanged.connect(self.enable_divide_button)

        self.multiply_button = QPushButton("Multiply")                                   #extra credit 
        self.multiply_button.setEnabled(False)
        self.multiply_button.clicked.connect(self.multiply_todo_item)
        self.set_lower_bound.textChanged.connect(self.enable_multiply_button)
        self.set_upper_bound.textChanged.connect(self.enable_multiply_button)

        self.add_button = QPushButton("Add")                                    #extra credit 
        self.add_button.setEnabled(False)
        self.add_button.clicked.connect(self.add_todo_item)
        self.set_lower_bound.textChanged.connect(self.enable_add_button)
        self.set_upper_bound.textChanged.connect(self.enable_add_button)

        self.subtract_button = QPushButton("Subtract")                                    #extra credit 
        self.subtract_button.setEnabled(False)
        self.subtract_button.clicked.connect(self.subtract_todo_item)
        self.set_lower_bound.textChanged.connect(self.enable_subtract_button)
        self.set_upper_bound.textChanged.connect(self.enable_subtract_button)

        ##############################################################
        #Create your own layout. You may use or ignore
        # the layout skeleton below.
        #It is ok if your layout differs from the example,
        # as long as all features are shown and functional.
        #Remember to set your layout!
        ##############################################################
        #layout (is base layout horizintal (hbox) or vertical (vbox))
        vbox = QVBoxLayout()
        #level 1 -hbox
        hbox2=QHBoxLayout()
        hbox2.addWidget(self.pick_int)
        hbox2.addWidget(self.pick_float)

        #level 2 -hbox
        hbox1=QHBoxLayout()
        hbox1.addWidget(self.lower_bound)
        hbox1.addWidget(self.set_lower_bound)
        hbox1.addWidget(self.upper_bound)
        hbox1.addWidget(self.set_upper_bound)

        vbox.addLayout(hbox2)
        vbox.addLayout(hbox1)

        #level 3 -widget
        vbox.addWidget(self.check_my_bounds)
        #level 4 -widget
        vbox.addWidget(self.randomize)
        vbox.addWidget(self.divide_button)                                   #extra credit 
        vbox.addWidget(self.multiply_button)                                   #extra credit 
        vbox.addWidget(self.add_button)                                   #extra credit 
        vbox.addWidget(self.subtract_button)                                   #extra credit 
        #level 5 -widget
        vbox.addWidget(self.output)
        #level 6 -widget
        vbox.addWidget(self.my_reset)
        #set layout
        self.setLayout(vbox)

    ###################################################################
    #this method is given to you; do NOT change for PE03 base
    def is_num_inputs(self):
        #This method is given to you b/c it uses try/except statements
        # which are not covered in this course. Although try/except
        # statements are not testable material, they are useful to know.
        # For more info, official try/except documentation is below:
        # https://docs.python.org/3/tutorial/errors.html
        tupsinlist = [(self.set_lower_bound, self.set_upper_bound)]
        for a, b in tupsinlist:
            if a.isEnabled() and b.isEnabled():
                try:
                    float(a.text())
                except:
                    a.setText('')
                    try:
                        float(b.text())
                    except:
                        b.setText('')
                    return False
                try:
                    float(b.text())
                except:
                    b.setText('')
                    return False
        return True
    ###################################################################

    def check_bounds(self):
        ############################
        #do NOT change for PE03 base
        if not self.is_num_inputs():
            return None
        ############################
        #Your code goes here:
        lower=float(self.set_lower_bound.text())
        upper=float(self.set_upper_bound.text())

        if self.pick_int.isChecked()==True:
            self.pick_float.setDisabled(True)

        if self.pick_float.isChecked()==True:
            self.pick_int.setDisabled(True)

        if lower>upper:
            self.set_lower_bound.setText("")
            self.set_upper_bound.setText("")
            msgBox = QMessageBox()
            msgBox.setText("lower bound needs to be bigger than upper bound- try inputting numbers again")  #extra credit
            msgBox.exec_()
        else:
            self.randomize.setEnabled(True)
            self.my_reset.setEnabled(True)
            self.set_lower_bound.setDisabled(True)
            self.set_upper_bound.setDisabled(True)
            self.check_my_bounds.setDisabled(True)

        if lower<upper and self.pick_int.isChecked()==True:
            lower=float(self.set_lower_bound.text())
            upper=float(self.set_upper_bound.text())
            self.set_lower_bound.setText(str(int(lower)))
            self.set_upper_bound.setText(str(int(upper)))


    def get_random_number(self):

        if self.pick_int.isChecked()==True:
            lower=int(self.set_lower_bound.text())
            upper=int(self.set_upper_bound.text())
            r=randint(lower,upper)
            self.output.setText("My random number is "+str(r))
            return r

        if self.pick_float.isChecked()==True:
            lower=float(self.set_lower_bound.text())
            upper=float(self.set_upper_bound.text())
            r=random.uniform(lower,upper)
            self.output.setText("My random number is "+str(r))
            return r

    def divide_todo_item(self):                                   #extra credit 
        n1=float(self.set_lower_bound.text())
        n2=float(self.set_upper_bound.text())
        try:
            s=str(round((n2/n1),4))
        except ZeroDivisionError:
            msgBox = QMessageBox()
            msgBox.setText("Cannot divide by zero!")
            msgBox.exec_()
        self.output.setText(str(s))

    def enable_divide_button(self):                                   #extra credit 
        if (len(self.set_lower_bound.text()) == 0) or (len(self.set_upper_bound.text())==0) and not(self.pick_int.isChecked()==True or self.pick_float.isChecked==True):
            self.divide_button.setEnabled(False)
        if (len(self.set_lower_bound.text()) > 0) and (len(self.set_upper_bound.text())>0) and (self.pick_int.isChecked()==True or self.pick_float.isChecked==True):
            self.divide_button.setEnabled(True)

    def multiply_todo_item(self):                                    #extra credit 
        n1=float(self.set_lower_bound.text())
        n2=float(self.set_upper_bound.text())
        s=str(round((n1*n2),4))
        self.output.setText(str(s))

    def enable_multiply_button(self):                                   #extra credit 
        if (len(self.set_lower_bound.text()) == 0) or (len(self.set_upper_bound.text())==0) and not(self.pick_int.isChecked()==True or self.pick_float.isChecked==True):
            self.multiply_button.setEnabled(False)
        if (len(self.set_lower_bound.text()) > 0) and (len(self.set_upper_bound.text())>0) and (self.pick_int.isChecked()==True or self.pick_float.isChecked==True):
            self.multiply_button.setEnabled(True)

    def add_todo_item(self):                                   #extra credit 
        n1=float(self.set_lower_bound.text())
        n2=float(self.set_upper_bound.text())
        s=str(round((n1+n2),4))
        self.output.setText(str(s))

    def enable_add_button(self):                                   #extra credit 
        if len(self.set_lower_bound.text()) == 0:
            self.add_button.setEnabled(False)
        if len(self.set_lower_bound.text()) > 0 and len(self.set_upper_bound.text()) > 0 :
            self.add_button.setEnabled(True)

    def subtract_todo_item(self):                                   #extra credit 
        n1=float(self.set_lower_bound.text())
        n2=float(self.set_upper_bound.text())
        s=str(round((n2-n1),4))
        self.output.setText(str(s))

    def enable_subtract_button(self):                                   #extra credit 
        if len(self.lower_bound.text()) == 0:
            self.subtract_button.setEnabled(False)
        if len(self.lower_bound.text()) > 0 and len(self.upper_bound.text()) > 0 :
            self.subtract_button.setEnabled(True)
       

    def reset_all(self):
        self.pick_int.setEnabled(True)
        self.pick_float.setEnabled(True)
        self.lower_bound.setEnabled(True)
        self.upper_bound.setEnabled(True)
        self.set_lower_bound.setEnabled(True)
        self.set_upper_bound.setEnabled(True)
        self.check_my_bounds.setEnabled(True)
        self.randomize.setDisabled(True) #can also use .setEnabled(False)
        self.my_reset.setDisabled(True) #can also use .setEnabled(False)
        self.set_lower_bound.setText('')
        self.set_upper_bound.setText('')
        self.output.setText('Generator in progress')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = RandomNumberGenerator()
    main.show()
    exit_code = app.exec_()
    sys.exit(exit_code)
