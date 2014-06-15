package avmplus
{
    public class RTraits
    {
        [ArrayElementType("avmplus.RMember")]
        public var accessors:Array = [];

        [ArrayElementType("avmplus.RMember")]
        public var variables:Array = [];

        [ArrayElementType("String")]
        public var interfaces:Array = [];

        [ArrayElementType("avmplus.RMember")]
        public var methods:Array = [];

        [ArrayElementType("String")]
        public var bases:Array = [];

        [ArrayElementType("avmplus.RValue")]
        public var metadata:Array = [];

        [ArrayElementType("avmplus.RArgument")]
        public var constructor:Array = [];
    }
}
