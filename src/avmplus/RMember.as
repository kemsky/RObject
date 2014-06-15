package avmplus
{
    public class RMember
    {
        public var type:String;
        public var uri:String;
        public var name:String;
        public var returnType:String;
        public var declaredBy:String;

        [ArrayElementType("avmplus.RArgument")]
        public var parameters:Array = [];

        [ArrayElementType("avmplus.RMeta")]
        public var metadata:Array = [];

        public var access:String;

        public function RMember(name:String, type:String, access:String, declaredBy:String, returnType:String)
        {
            this.name = name;
            this.type = type;
            this.access = access;
            this.declaredBy = declaredBy;
            this.returnType = returnType;
        }
    }
}
