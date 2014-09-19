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

        [ArrayElementType("avmplus.RMeta")]
        public var metadata:Array = [];

        [ArrayElementType("avmplus.RArgument")]
        public var constructor:Array = [];

        public function getMetadataByName(name:String):Array
        {
            var result:Array = [];
            for each (var meta:RMeta in metadata)
            {
                if(meta.name == name)
                {
                    result.push(meta);
                }
            }
            return result;
        }
    }
}
