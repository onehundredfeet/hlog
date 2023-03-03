// this file is written in haxe
package ;

import hlog.Log;

class Test {
    public static function main() {
        initLogging(VERBOSE);
        verbose('Info that borders on spew');
        info('Even more info');
        message('Normal message, equivalent to regular trace');
        warning('Waring message');
        debug('Some extra debugging information');
        error('Error message');
        critical('Critical failure, and throw');
    }

}