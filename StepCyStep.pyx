"""
Calls From Wolfram|Alpha Step by Step API.
Writes into a file known as solutions.txt
"""

from datetime import datetime

import_time = datetime.now()
"""
import sympy
from sympy.parsing.sympy_parser import parse_expr, standard_transformations,implicit_multiplication_application
from sympy.printing import pretty
from sympy import init_printing
from sympy import pretty_print as pp, latex
from sympy import Eq, solve, Symbol
import wolframalpha

import os
import configparser
import time
"""
print(f"[StepPyStep] Import time: {datetime.now() - import_time}")
#Set of tools used to process TeX inputs.
class create_zip(object):
    def __init__(self):
        pass
    def create_directory(self, root_directory):
        start = datetime.now()
        import os
        import configparser
        import time

        config = configparser.ConfigParser()
        config['HISTORY'] = {'count': '1',
                      'recent': '1-1-1',
                      }
        config.read("MathSolverApp/settings.ini")
        print(config.sections())
        with open('settings.ini','w') as configfile:
            config.write(configfile)
        config['HISTORY']['RECENT_DATE'] = str(time.strftime("%I-%M-%S %p, %b %d, %Y"))
        with open('settings.ini', 'w') as configfile:
            config.write(configfile)
        try:
            self.fpath = config['HISTORY']['RECENT_DATE']
            os.makedirs(os.path.join(root_directory, "Solutions", self.fpath))
            print(os.path.join(root_directory, "Solutions", self.fpath))
        except FileExistsError:
            pass
        with open(os.path.join(root_directory, "Solutions", self.fpath, "solution.txt"), "w+", encoding='utf-8'):
                pass
        print(f"[StepPyStep][create_zip][create_directory] runtime: {datetime.now() - start}")
        return self.fpath

class parse_tex(object):
    def start_appending(self,s, d, i):
        temp = ""
        count = 1
        while (True):
            if (s[i] == "{"):
                count += 1
            if (s[i] == "}"):
                if (count == 1):
                    break
                else:
                    count -= 1
            temp += s[i]
            i += 1
        return temp
    #splits LaTeX arrays by {...}
    def split_array(self,tex):
        texl = []
        temp = ""
        flag = False
        i = 0
        while i < len(tex):
            if (tex[i] == "{"):
                temp = self.start_appending(tex, "}", i+1)
                texl.append(temp)
                i += len(temp)
            else:
                i += 1
        del texl[0]
        del texl[0]
        del texl[len(texl)-1]
        return texl
    #Determines the characters in a string, returns a list containing the variable(s)
    def determine_chars(self,tex):
        ch = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
        found = []
        for k in tex:
            if (k in ch) and (k not in found):
                found.append(k)
        return found
    #Converts 'a = b' equation into Eq(a,b), since sympy does not use '=' or '=='.
    def parse_equals(self,tex):
        try:
            return tex.split('=')
        except Exception:
            return tex
    def detectFrac(self, tex):
        if "\\frac" in tex:
            texList = self.split_array(tex)
            return texList[0] + "/" + texList[1]
        else:
            return tex
    def replaceBackSlash(self, tex):
        temp = tex
        if "\\frac" in tex:
            texList = self.split_array(tex)
            temp = texList[0] + "/" + texList[1]
        #greek letters
        temp = temp.replace("\\pi", "pi")
        temp = temp.replace("\\alpha", "alpha")
        temp = temp.replace("\\mu", "mu")
        temp = temp.replace("\\theta", "theta")

        #trig Functions
        temp = temp.replace("\\sin", "sin")
        temp = temp.replace("\\cos", "cos")
        temp = temp.replace("\\tan", "tan")
        temp = temp.replace("\\csc", "csc")
        temp = temp.replace("\\sec", "sec")
        temp = temp.replace("\\cot", "cot")

        return temp
    def pretty_config(self, tex):
        start = datetime.now()
        import sympy
        from sympy.parsing.sympy_parser import parse_expr, standard_transformations,implicit_multiplication_application
        from sympy import init_printing
        from sympy.printing import pretty
        from sympy import Eq, Symbol
        transformations = transformations = (standard_transformations +
                                     (implicit_multiplication_application,))
        tex = str(tex).replace("^", "**")
        if ("=" in tex):
            i = 0
            for c in tex:
                if c == "=":
                    i += 1
            print(i)
            rhs, lhs = tex.split('=')
            try:
                rhs = parse_expr(rhs, transformations=transformations)
            except SyntaxError as e:
                print(e)
                print(f"[StepPyStep][parse_tex][pretty_config] runtime: {datetime.now() - start}")
                return tex
            try:
                lhs = parse_expr(lhs, transformations=transformations)
            except SyntaxError as e:
                print(e)
                print(f"[StepPyStep][parse_tex][pretty_config] runtime: {datetime.now() - start}")
                return tex
            rhs = pretty(rhs, use_unicode=True)
            lhs = pretty(lhs, use_unicode=True)
            tex = rhs + "=" + lhs + "\n"
            print(f"[StepPyStep][parse_tex][pretty_config] runtime: {datetime.now() - start}")
            return tex
        else:
            sympy_expr = parse_expr(tex, transformations=transformations)
            print(f"[StepPyStep][parse_tex][pretty_config] runtime: {datetime.now() - start}")
            return pretty(sympy_expr)
class solve_equation(object):
    def wolfram_alpha(self, call, write_file, image=False):
        start = datetime.now()
        import sympy
        from sympy.parsing.sympy_parser import parse_expr, standard_transformations,implicit_multiplication_application
        import wolframalpha
        import os
        import configparser
        import time
        from sympy import Eq, solve, Symbol
        
    #Calls from the wolfram|alpha api for step-by-step calculations.
        client = wolframalpha.Client('EVHR3T-ULQ98AEG66')
        self.res = client.query(call)
        try:
            print(self.res.pods)
        except AttributeError:
            return "Our software ran into an issue. Sorry!"
        temp = ""
        with open(f"{write_file}","w+",encoding='utf-8') as f:
            pass
            if (image == False):
                f.write("SOLUTION\n")
                for pod in self.res.pods:
                    for sub in pod.subpods:
                        flag = False
                        if (sub['@title'] == "Possible intermediate steps"):
                            f.write(str(sub.plaintext)+'\n')
                            temp += str(sub.plaintext) + '\n'
                            print(sub.plaintext)
                            flag = True
                       
                f.write("PRETTY_PRINT\n")
                for pod in self.res.pods:
                    for sub in pod.subpods:
                        if (sub['@title'] == "Possible intermediate steps"):
                            s = str(sub.plaintext).split('\n')
                            for i in range(len(s)):
                                if i%2 == 1 and '=' in s[i]:
                                    if 'or' in s[i]:
                                        mult_solution = s[i].split('or')
                                        for i in range(len(mult_solution)):
                                            mult_solution[i] = parse_tex().pretty_config(mult_solution[i])
                                            f.write(mult_solution[i] + " ")
                                            temp += mult_solution[i] + " "
                                        f.write('\n')
                                        temp += '\n'
                                    else:
                                        pretty = parse_tex().pretty_config(s[i])
                                        f.write(pretty + '\n')
                                        temp += pretty
                                        print(pretty)
                                else:
                                    f.write(s[i] + '\n')
                                    temp += s[i] + '\n'
                                    print(s[i] + '\n')
            else:
                for pod in self.res.pods:
                    for sub in pod.subpods:
                        temp = sub['img']['@src']
                f.write(str(temp) + '\n')
        print(f"[StepPyStep][solve_equation][wolfram_alpha] runtime: {datetime.now() - start}")
        return temp   
    #Used with check_equation().check_eq()
    def get_answer(self,tex):
        start = datetime.now()
        import sympy
        from sympy.parsing.sympy_parser import parse_expr, standard_transformations,implicit_multiplication_application
        import wolframalpha
        import os
        import configparser
        import time
        from sympy import Eq, solve, Symbol
        
        lhs, rhs = parse_tex().parse_equals(tex)
        transformations = (standard_transformations +
                           (implicit_multiplication_application,))
        lhs = parse_expr(lhs,transformations=transformations)
        rhs = parse_expr(rhs,transformations=transformations)

        Equ = Eq(lhs,rhs)
        a = solve(Equ)
        print(f"[StepPyStep][solve_equation][get_answer] runtime: {datetime.now() - start}")
        return a

class check_equation(object):
    #str -> check_eq -> bool
    #int ----^
    def check_eq(self, eq,answer, precision):
        start = datetime.now()
        import sympy
        from sympy.parsing.sympy_parser import parse_expr, standard_transformations,implicit_multiplication_application
        import wolframalpha
        import os
        import configparser
        import time
        from sympy import Eq, solve, Symbol
        

        transformations = (standard_transformations +
                        (implicit_multiplication_application,))
        origin = eq
        lhs, rhs = parse_tex().parse_equals(eq)
        lhs = parse_expr(lhs,transformations=transformations)
        rhs = parse_expr(rhs,transformations=transformations)
        if (isinstance(answer, list)):
            for solutions in answer:
                lhs = lhs.subs(Symbol('x'),solutions)
                lhs = round(lhs, precision)
                rhs = rhs.subs(Symbol('x'),solutions)
                rhs = round(rhs, precision)
                with open("solutions.txt","a") as f:
                    if (lhs == rhs):
                        f.write(origin+"\t + True")
                        print(f"[StepPyStep][Check_equation][check_eq] runtime: {datetime.now() - start}")
                        return True
            with open("solutions.txt","a") as f:
                f.write(origin + "\t + False")
                print(f"[StepPyStep][Check_equation][check_eq] runtime: {datetime.now() - start}")
                return False
                        
        else:
            lhs = lhs.subs(Symbol('x'),answer)
            rhs = rhs.subs(Symbol('x'),answer)
            with open("solutions.txt","a") as f:
                if lhs == rhs:
                    f.write(origin+"\t + True")
                    print(f"[StepPyStep][Check_equation][check_eq] runtime: {datetime.now() - start}")
                    return True
                else:
                    f.write(origin+"\t + False")
                    print(f"[StepPyStep][Check_equation][check_eq] runtime: {datetime.now() - start}")
                    return False

#Test Case 1: \\left. \\begin{array} { l } { x^{2} + 5 = 20 } \\\\ { 5 + 6 = 11 } \\\\ { x + 3 = Y } \\end{array} \\right.
#Test Case 2: x + 5 + 6 + x + y + 2*y
#Test Case 3: 3*x - 2 = 4
#Test Case 4: 3*x + 4*y = 2
#Test Case 5: ['3*x - 2 = 4','3*x = 6','x = 2']
#Test Case 6: 3*(x + 2) = 4
#Test Case 7: \\left. \\begin{array} { l } { x + 5 = 7 } \\\\ { x + 1 = 5 } \\\\ { x = 2 } \\end{array} \\right.
#Test Case 8: \\left. \\begin{array} { l } { x^(2) + 2x + 1 = 0 } \\\\ { (x + 1)^(2) = 0} \\\\ { x = -1 } \\end{array} \\right.
#Test Case 9: \\left. \\begin{array} { l } {5x^(2) + 6x + 1 = 0 } \\end{array} \\right.

    
    
