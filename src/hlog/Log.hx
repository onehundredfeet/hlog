package hlog;

import haxe.macro.Printer;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.PositionTools;

// TODO - Easier way for someone to customize without modifying this file
// Feel free to modify these to your liking
enum abstract LogColour(String) to String {
	var NONE = "\x1b[0m";
	var RED = "\x1b[38;2;⟨200⟩;⟨20⟩;⟨20⟩m";
	var GREEN = "\x1b[32m";
	var YELLOW = "\x1b[33m";
	var BLUE = "\x1b[34m";
	var MAGENTA = "\x1b[35m";
	var CYAN = "\x1b[36m";
	var WHITE = "\x1b[37m";
	var BRIGHT_RED = "\x1b[38;2;⟨255⟩;⟨40⟩;⟨40⟩m";
	var BRIGHT_GREEN = "\x1b[92m";
	var BRIGHT_YELLOW = "\x1b[93m";
	var BRIGHT_BLUE = "\x1b[94m";
	var BRIGHT_MAGENTA = "\x1b[95m";
	var BRIGHT_CYAN = "\x1b[38;2;⟨85⟩;⟨255⟩;⟨255⟩m";
	var BRIGHT_WHITE = "\x1b[97m";
	var BOLD = "\x1b[1m";
	var UNDERLINE = "\x1b[4m";
	var BLINK = "\x1b[5m";
	var REVERSE = "\x1b[7m";
	var HIDDEN = "\x1b[8m";
}

class LogLevel {
	public function new(level:Int, description:String, halt:Bool, colour:String) {
		this.level = level;
		this.description = description;
		this.colour = colour;
		this.halt = halt;
	}

	public var level:Int;
	public var description:String;
	public var colour:String;
	public var halt:Bool;
}

// TODO - Easier way for someone to customize without modifying this file
// Feel free to modify these to your liking
final CRITICAL = new LogLevel(-3, "Critical", true, '${LogColour.BOLD}${LogColour.BRIGHT_RED}');
final ERROR = new LogLevel(-2, "Error", false, '${LogColour.BOLD}${LogColour.RED}');
final WARNING = new LogLevel(-1, "Warning", false, LogColour.YELLOW);
final MESSAGE = new LogLevel(0, "Message", false, LogColour.GREEN);
final DEBUG = new LogLevel(1, "Debug", false, LogColour.BRIGHT_CYAN);
final INFO = new LogLevel(2, "Info", false, LogColour.CYAN);
final VERBOSE = new LogLevel(3, "Verbose", false, LogColour.BLUE);
var logLevel = DEBUG;
var jsonFile:sys.io.FileOutput = null;
var txtFile:sys.io.FileOutput = null;

macro function critical(e:Expr):Expr {
	#if !hlog_no_critical
	var pos = e.pos;
	var x = macro hlog.Log.CRITICAL;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.CRITICAL.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function error(e:Expr):Expr {
	#if !hlog_no_error
	var pos = e.pos;
	var x = macro hlog.Log.ERROR;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.ERROR.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function warning(e:Expr):Expr {
	#if !hlog_no_warning
	var pos = e.pos;
	var x = macro hlog.Log.WARNING;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.WARNING.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function message(e:Expr):Expr {
	#if !hlog_no_message
	var pos = e.pos;
	var x = macro hlog.Log.MESSAGE;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.MESSAGE.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function debug(e:Expr):Expr {
	#if !hlog_no_debug
	var pos = e.pos;
	var x = macro hlog.Log.DEBUG;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.DEBUG.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function info(e:Expr):Expr {
	#if !hlog_no_info
	var pos = e.pos;
	var x = macro hlog.Log.INFO;
	var eout = macro {if (hlog.Log.logLevel.level >= hlog.Log.INFO.level)
		trace($e, $x);};
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

macro function verbose(e:Expr):Expr {
	#if !hlog_no_verbose
	var pos = e.pos;
	var x = macro hlog.Log.VERBOSE;
	var eout = macro if (hlog.Log.logLevel.level >= hlog.Log.VERBOSE.level) trace($e, $x);
	eout.pos = e.pos;
	return eout;
	#end
	return macro {};
}

function println(v:Dynamic) {
	#if sys
	Sys.println(v);
	#elseif js
	js.html.Console.log(v);
	#end
}

function logJson(v:Dynamic, level, ?infos:haxe.PosInfos) {
	if (Log.jsonFile != null) {
		var json = {
			__timestamp__: Date.now(),
			message: v,
			level: level.description,
			classname: infos != null ? infos.className : null,
			file: infos != null ? infos.fileName : null,
			method: infos != null ? infos.methodName : null,
			line: infos != null ? infos.lineNumber : null
		};
		Log.jsonFile.writeString(haxe.Json.stringify(json) + "\n");
	}
}

function logTxt(v:Dynamic, level, ?infos:haxe.PosInfos) {
	if (Log.txtFile != null) {
		var classname = infos != null ? infos.className : "";
		var filename = infos != null ? infos.fileName : "";
		var methodname = infos != null ? infos.methodName : "";
		var line = infos != null ? '${infos.lineNumber}' : "";
		Log.txtFile.writeString('[${Date.now()}] ${level.description} - ${classname}:${methodname}[$line] : ${v}\n');
	}
}

function logString(s:String) {
    if (Log.txtFile != null) {
        Log.txtFile.writeString(s + "\n");
    }
    println(s);
}
function logCallStack() {
	var stack = haxe.CallStack.callStack();
	for (i in 2...stack.length) {
		var item = stack[i];
		switch (item) {
			case CFunction:
				logString('CFunction');
			case Module(m):
				logString('Module: ${m}');
			case FilePos(s, file, line, column):
				switch (s) {
					case CFunction:
						logString('CFunction');
					case Module(m):
						logString('Module: ${m}');
					case Method(classname, method):
                        var columnStr = column != null ? ',${column}' : "";
						logString('Called from ${classname}.${method}(${file}[${line}${columnStr}])');
					case LocalFunction(v):
						logString('LocalFunction: ${v}');
                    default:
				}
			case Method(classname, method):
				logString('Method: ${classname}.${method}');
			case LocalFunction(v):
				logString('LocalFunction: ${v}');
			default:
		}
	}
}

// TODO allow custom formatting
function log_trace(v:Dynamic, ?infos:haxe.PosInfos) {
	if (infos != null) {
		var className = infos.className;
		var fileName = infos.fileName;
		var methodName = infos.methodName;
		var level = Log.MESSAGE;

		if (infos.customParams != null) {
			for (x in infos.customParams) {
				var pi:haxe.PosInfos = x;
				if (x is LogLevel) {
					var ll:LogLevel = x;
					level = ll;
				} else if (pi != null) {
					className = pi.className;
					fileName = pi.fileName;
					methodName = pi.methodName;
					if (pi.customParams != null) {
						level = pi.customParams[0];
					} else {
						level = Log.MESSAGE;
					}
				} else {
					println('Unknown paramter type: ${x}');
				}
			}
		}

		if (Log.jsonFile != null) {
			logJson(v, level, infos);
		}

		if (Log.txtFile != null) {
			logTxt(v, level, infos);
		}

		if (level.level <= Log.logLevel.level) {
			// custom trace function here
			var description = '${level.colour}${level.description}${Log.LogColour.NONE}';
			if (infos != null) {
				if (className != null && methodName != null)
					println('${description}: ${className}.${methodName} [line ${infos.lineNumber}] : ${v}');
				else
					println('${description}: ${fileName}[${infos.lineNumber}]: ${v}');
			} else {
				println('${description}: ${v}');
			}
		}
		if (level.halt) {
			logCallStack();
            throw v;
		}
	} else {
		println(Std.string(v));
		if (Log.jsonFile != null) {
			logJson(v, Log.MESSAGE, null);
		}
		if (Log.txtFile != null) {
			logTxt(v, Log.MESSAGE, null);
		}
	}
}

function initLogging(maxlevel:LogLevel) {
	Log.logLevel = maxlevel;
	haxe.Log.trace = log_trace;
}

function initLogJSON(jsonPath:String) {
	Log.jsonFile = sys.io.File.write(jsonPath, false);
}

function initLogText(txtPath:String) {
	Log.txtFile = sys.io.File.write(txtPath, false);
}
