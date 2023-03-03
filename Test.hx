// this file is written in haxe
package ;

import log.Log;

class Test {
    public static function main() {
        initLogging(VERBOSE);
        verbose('Verbose');
        info('Info');
        debug('Debug');
        message('Message');
        warning('Warning');
        error('Error');
        critical('Critical');
    }

}