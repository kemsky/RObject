package avmplus
{
    public class RMeta
    {
        public var name:String;

        [ArrayElementType("avmplus.RValue")]
        public var value:Array = [];

        public function RMeta(name:String)
        {
            this.name = name;
        }
    }
}
