import inspect
import numpy as np


class Logger(object):

	COLORS = {
		"bold": "\033[1m",
		"dim": "\033[2m",
		"underline": "\033[4m",
		"blink": "\033[5m",
		"reverse": "\033[7m",
		"hidden": "\033[8m",
		"endc": '\033[0m',
		"none"	: '',

		"resetbold"       : "\033[21m",
		"resetdim"        : "\033[22m",
		"resetunderlined" : "\033[24m",
		"resetblink"      : "\033[25m",
		"resetreverse"    : "\033[27m",
		"resethidden"   : "\033[28m",

		"default"      : "\033[39m",
		"black"        : "\033[30m",
		"red"          : "\033[31m",
		"green"        : "\033[32m",
		"yellow"       : "\033[33m",
		"orange"       : "\033[95m",
		"blue"         : "\033[34m",
		"magenta"      : "\033[35m",
		"cyan"         : "\033[36m",
		"lightgray"    : "\033[37m",
		"darkgray"     : "\033[90m",
		"lightred"     : "\033[91m",
		"lightgreen"   : "\033[92m",
		"lightyellow"  : "\033[93m",
		"lightblue"    : "\033[94m",
		"lightmagenta" : "\033[95m",
		"lightcyan"    : "\033[96m",
		"white"        : "\033[97m",

		"bg_default"      : "\033[49m",
		"bg_black"        : "\033[40m",
		"bg_red"          : "\033[41m",
		"bg_green"        : "\033[42m",
		"bg_yellow"       : "\033[43m",
		"bg_blue"         : "\033[44m",
		"bg_magenta"      : "\033[45m",
		"bg_cyan"         : "\033[46m",
		"bg_lightgray"    : "\033[47m",
		"bg_darkgray"     : "\033[100m",
		"bg_lightred"     : "\033[101m",
		"bg_lightgreen"   : "\033[102m",
		"bg_lightyellow"  : "\033[103m",
		"bg_lightblue"    : "\033[104m",
		"bg_lightmagenta" : "\033[105m",
		"bg_lightcyan"    : "\033[106m",
		"bg_white"        : "\033[107m"
	}

	STATUSES = {
		"success" : "green",
		"fail": "red",
		"info": "lightblue",
		"timing": "blue",
		"warning": "yellow",
		"standard": "none"
	}

	@staticmethod
	def bold_txt(msg: str, status=None, color=None) -> str:
		if status:
			return Logger.COLORS[Logger.STATUSES[status]] + Logger.COLORS["bold"] + msg + Logger.COLORS["endc"]
		if color:
			return Logger.COLORS[color.lower()] + Logger.COLORS["bold"] + msg + Logger.COLORS["endc"]
		return Logger.COLORS["bold"] + msg + Logger.COLORS["endc"]

	@staticmethod
	def log_boolean(bool_val: bool, invert=False, msg=None) -> str:
		success = Logger.STATUSES["success"]
		fail = Logger.STATUSES["fail"]
		if invert:
			success = Logger.STATUSES["fail"]
			fail = Logger.STATUSES["success"]
		if bool_val:
			pre = Logger.COLORS[success]
			if msg is None:
				msg = "True"
		elif not bool_val:
			pre = Logger.COLORS[fail]
			if msg is None:
				msg = "False"
		else:
			pre = ""
		return pre + msg + Logger.COLORS["endc"]

	@staticmethod
	def styled_text(msg: str, color: str) -> str:
		if color.lower() in Logger.STATUSES:
			return Logger.COLORS[Logger.STATUSES[color.lower()]] + msg + Logger.COLORS["endc"]
		elif color.lower() in Logger.COLORS:
			return Logger.COLORS[color.lower()] + msg + Logger.COLORS["endc"]
		else:
			print(f" color '{color}' not saved")
			return msg

	@staticmethod
	def log(message: str, status="standard", print_enanled=True, nl_after=0, nl_before=0) -> None:

		if not print_enanled: return
		stack = inspect.stack()
		use_stack = True
		class_, method_ = "" ,""
		caller = "<static method>"
		try:
			class_ = stack[1][0].f_locals["self"].__class__.__name__
			method_ = stack[1][0].f_code.co_name
		except KeyError:
			use_stack = False

		if use_stack:
			caller = class_ + "." + method_ + "()"

		if status.lower() not in Logger.STATUSES:
			print(f" Warning: status '{status}' not in saved status")

		prefix = Logger.COLORS["bold"] + Logger.COLORS["underline"] + caller + Logger.COLORS["endc"] + ":"
		try:
			print_str = prefix + Logger.COLORS[Logger.STATUSES[status.lower()]] + " " + message + " " + Logger.COLORS["endc"]
		except KeyError:
			print_str = prefix + " " + message + " " + Logger.COLORS["endc"]

		for _ in range(nl_before):
			print()
		print(print_str)
		for _ in range(nl_after):
			print()

	@staticmethod
	def log_hash(x):
		return str(hash(str(x)))[-5:]

	@staticmethod
	def pp_list(input_list_, round=None):
		ret = "[ "
		if input_list_ is None:
			return Logger.COLORS["bold"] + "None" + Logger.COLORS["endc"]
		for i in input_list_:
			if type(i) == list or type(i) == tuple:
				ret += Logger.pp_list(i)	# recursion, lfg
			else:
				if isinstance(i, (int, float, complex)):
					if i == int(i):
						ret += str(i) + ", "
					else:
						if i == np.inf:
							ret += "inf"
						else:
							ret += "%.5f" % i
						ret += ", "
				else:
					ret += str(i ) +", "
		ret = ret[:-2]
		ret += " ]"
		return ret

	@staticmethod
	def printable_vector(v: list, round_amt=3) -> str:

		print_str = "<"
		for i in v:
			print_str += str(round(i, round_amt))+", "
		print_str = print_str[:-2]
		print_str += ">"
		return print_str
