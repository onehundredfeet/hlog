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
```

