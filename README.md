# hlog
Ultra simple, ultra lightweight logging library for Haxe


# Usage

```haxe
import log.Log;

function test() {
    // In order of level
    critical('Critical failure, and throw');
    error('Error message');
    warning('Waring message');
    message('Normal message, equivalent to regular trace');
    debug('Some extra debugging information');
    info('Even more info');
    verbose('Info that borders on spew');
}

class MyMain {
    public static function main() {
        initLogging(VERBOSE);
        test();
    }
}

```

Outputs

```terminal 
Verbose: Test.main [line 127] : Verbose
Info: Test.main [line 116] : Info
Debug: Test.main [line 105] : Debug
Message: Test.main [line 94] : Message
Warning: Test.main [line 83] : Warning
Error: Test.main [line 72] : Error
Critical: Test.main [line 61] : Critical
```

