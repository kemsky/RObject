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

        public function getValueByName(name:String):RValue
        {
            for each (var parameter:RValue in value)
            {
                if(parameter.key == name)
                {
                    return parameter;
                }
            }

            return null;
        }
    }
}
