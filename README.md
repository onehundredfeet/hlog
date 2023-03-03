# hlog
Ultra simple, ultra lightweight logging library for Haxe


# Usage

```haxe
import log.Log;

class Test {
    public static function main() {
        initLogging(VERBOSE);
         // In order of level
        verbose('Info that borders on spew');
        info('Even more info');
        message('Normal message, equivalent to regular trace');
        warning('Waring message');
        debug('Some extra debugging information');
        error('Error message');
        critical('Critical failure, and throw');
    }
}

```

Outputs

```terminal 
Verbose: Test.main [line 127] : Info that borders on spew
Info: Test.main [line 116] : Even more info
Message: Test.main [line 94] : Normal message, equivalent to regular trace
Warning: Test.main [line 83] : Waring message
Debug: Test.main [line 105] : Some extra debugging information
\x1b[38;2;⟨200⟩;⟨20⟩;⟨20⟩mError: Test.main [line 72] : Error message
Critical: Test.main [line 61] : Critical failure, and throw
```

