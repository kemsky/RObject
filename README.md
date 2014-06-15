RObject
=======

Fast reflection for ActionScript, based on describeTypeJSON function

See http://tillschneidereit.net/2009/11/22/improved-reflection-support-in-flash-player-10-1/

The main limitation of the `avmplus.describeTypeJSON` function is that it can only be applied to instances.
RObject internally uses describeTypeJSON function where possible and falls back to parsing XML output of `flash.utils.describeType`
function, providing compatible object descriptor.

Usage

```ActionScript
var flags:int = R.VARIABLES | R.METADATA | R.TRAITS;
var descriptor:Object = R.describe(test, flags);
```