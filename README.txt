UPDATE: the current version is working (with public properties at least) and does not produce the errors noted below.




When using the call

abcBuilder.buildAndLoad();

the constructor call

const instance:Object = new clazz(p0, p1);

in the loadedHandler throws ReferenceError: Error #1056: Cannot create property _first on com.classes.generated.PointPair.

When using the call

abcBuilder.buildAndExport();

and saving to a swf file,

ASV reports that the SWF version is greater than 14, and decompiles the class com.classes.generated.PointPair to:

package com.classes.generated {
    import flash.geom.*;
    import private.*;

    public class PointPair {

        private var _first:Point;
        private var _second:Point;

        public function PointPair(_arg1:Point, _arg2:Point){
            this._first = _arg1;
            this._second = _arg2;
        }
    }
}//package com.classes.generated 

which of course won't compile because of the line

import private.*;

(using as3-commons-bytecode/RC3)


