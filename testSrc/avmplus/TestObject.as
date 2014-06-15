package avmplus
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    [ArrayElementType("String")]
    public dynamic class TestObject extends TestObjectParent implements ITestObject
    {
        [ArrayElementType("String")]
        public var test:String;

        private var _test1:String;

        [ArrayElementType("String")]
        mx_internal var property:String;

        [ArrayElementType("String")]
        public function TestObject(test:String)
        {
        }

        [ArrayElementType("String")]
        public function get test1():String
        {
            return _test1;
        }

        public function set test1(value:String):void
        {
            _test1 = value;
        }

        [ArrayElementType("String")]
        public function toString(arg:String):String
        {
            return "TestObject{test=" + String(test) + ",_test1=" + String(_test1) + "}";
        }
    }
}
