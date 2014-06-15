RObject
=======

Fast reflection for ActionScript, based on describeTypeJSON function

See (http://tillschneidereit.net/2009/11/22/improved-reflection-support-in-flash-player-10-1/)

The main limitation of the avmplus.describeTypeJSON function is that it can only be applied to instances.
RObject internally uses describeTypeJSON where possible and falls back to parsing XML output of flash.utils.describeType
function.

Usage

var flags:int = R.ACCESSORS | R.VARIABLES | R.METADATA | R.TRAITS | R.METHODS | R.CONSTRUCTOR | R.BASES | R.INTERFACES;
var descriptor:Object = R.describe(test, flags);