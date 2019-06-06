import datetime
import numpy as np
import inspect

class Logger(object):

    class colors:
        '''Colors class:
        reset all colors with colors.reset
        two subclasses fg for foreground and bg for background.
        use as colors.subclass.colorname.
        i.e. colors.fg.red or colors.bg.green
        also, the generic bold, disable, underline, reverse, strikethrough,
        and invisible work with the main class
        i.e. colors.bold
        '''
        reset = '\033[0m'
        bold = '\033[01m'
        disable = '\033[02m'
        underline = '\033[04m'
        reverse = '\033[07m'
        strikethrough = '\033[09m'
        invisible = '\033[08m'

        class fg:
            black = '\033[30m'
            red = '\033[31m'
            green = '\033[32m'
            orange = '\033[33m'
            blue = '\033[34m'
            purple = '\033[35m'
            cyan = '\033[36m'
            lightgrey = '\033[37m'
            darkgrey = '\033[90m'
            lightred = '\033[91m'
            lightgreen = '\033[92m'
            yellow = '\033[93m'
            lightblue = '\033[94m'
            pink = '\033[95m'
            lightcyan = '\033[96m'

        class bg:
            black = '\033[40m'
            red = '\033[41m'
            green = '\033[42m'
            orange = '\033[43m'
            blue = '\033[44m'
            purple = '\033[45m'
            cyan = '\033[46m'
            lightgrey = '\033[47m'


    COLORS = {  # Unix codes for special priting
        "HEADER"	: 	{"value" :'\033[95m'},
        "OKBLUE" 		: 	{"value" :'\033[94m'},
        "OKGREEN" 		: 	{"value" :'\033[92m'},
        "BLUE" 		    : 	{"value" :'\033[34m'},
        # "ORANGE" 		: 	{"value" :'\033[43m'},
        "ORANGE" 		: 	{"value" :'\033[95m'},
        # "WARNING" 		: 	{"value" :'\033[93m'},
        "WARNING" 		: 	{"value" :'\033[95m'},
        "FAIL" 			: 	{"value" :'\033[91m'},
        "ENDC" 			: 	{"value" :'\033[0m'},
        "BOLD" 			: 	{"value" :'\033[1m'},
        "UNDERLINE" 	: 	{"value" :'\033[4m'},
        "STANDARD"		:	{"value" :''}
    }

    @staticmethod
    def get_file_save_name():
        now = datetime.datetime.now()
        return now.strftime("%m-%d-%Y_%H:%M")

    @staticmethod
    def bold_txt(msg, color="STANDARD"):
        return Logger.COLORS[color]["value"] + Logger.COLORS["BOLD"]["value"] + msg + Logger.COLORS["ENDC"]["value"]

    @staticmethod
    def log_boolean(bool, invert=False, msg=None):
        success = "OKGREEN"
        fail = "FAIL"
        if invert:
            success = "FAIL"
            fail = "OKGREEN"
        pre = ""
        if bool == True:
            pre = Logger.COLORS[success]["value"]
            if msg is None:
                msg = "True"
            # return Logger.COLORS[success]["value"] + "True" + Logger.COLORS["ENDC"]["value"]
        elif bool == False:
            pre = Logger.COLORS[fail]["value"]
            if msg is None:
                msg = "False"
            # return Logger.COLORS[fail]["value"] + "False" + Logger.COLORS["ENDC"]["value"]
        else:
            pre = ""
        return pre + msg + Logger.COLORS["ENDC"]["value"]

    @staticmethod
    def styled_text(msg, style):
        return Logger.COLORS[style.upper()]["value"]+msg+Logger.COLORS["ENDC"]["value"]

    @staticmethod
    def log(message, color):
        # type: (str, str) -> None
        # [03/Apr/2017 18:37:10]

        stack = inspect.stack()
        use_stack = True
        class_, method_ = "",""
        caller = "__main__"
        try:
            class_ = stack[1][0].f_locals["self"].__class__.__name__
            method_ = stack[1][0].f_code.co_name
        except KeyError:
            use_stack = False
        if use_stack:
            caller = class_+"."+method_+"()"

        time = datetime.datetime.now()
        if color not in Logger.COLORS:
            color = Logger.COLORS.get("STANDARD").get("value")
        prefix = "["+str(time.day)+"/"+str(time.month)+ "/" + str(time.year) + " " + str(time.hour) + ":" + str(time.minute) + ":" + str(time.second) +  " ] "
        prefix = prefix +  Logger.COLORS["BOLD"]["value"]+ Logger.COLORS["UNDERLINE"]["value"]+ caller+ Logger.COLORS["ENDC"]["value"]+ ":"

        try:
            print_Str = prefix + ""+Logger.COLORS[color]["value"] + " "+message + " "+Logger.COLORS["ENDC"]["value"]
        except KeyError:
            print_Str = prefix + "" + Logger.COLORS["STANDARD"]["value"] + " " + message + " " + Logger.COLORS["ENDC"]["value"]
        print(print_Str)

    @staticmethod
    def log_hash(x):
        return str(hash(str(x)))[-5:]

    @staticmethod
    def pp_list(input_list_, round=None):
        ret = "[ "
        if input_list_ is None:
            return Logger.COLORS["BOLD"]["value"] + "None" + Logger.COLORS["ENDC"]["value"]
        for i in input_list_:
            if type(i) == list or type(i) == tuple:
                ret += Logger.pp_list(i)    # recursion, lfg
            else:
                if isinstance(i, (int, long, float, complex)):
                    if i == int(i):
                        ret += str(i) + ", "
                    else:
                        if i == np.inf:
                            ret += "inf"
                        else:
                            ret += "%.5f" % i
                        ret += ", "
                else:
                    ret += str(i)+", "
        ret = ret[:-2]
        ret += " ]"
        return ret

    @staticmethod
    def pp_double(dbl):
        if dbl:
            if dbl == np.inf:
                return "inf"
            try:
                if int(dbl) == dbl:
                    return str(int(dbl))
            except ValueError:
                return 'NaN'
            s = "%.5f" % dbl
            return s
        return "<none>"