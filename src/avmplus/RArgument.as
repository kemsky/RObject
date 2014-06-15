package avmplus
{
    public class RArgument
    {
        public var optional:Boolean;

        public var type:String;


        public function RArgument(type:String, optional:Boolean)
        {
            this.optional = optional;
            this.type = type;
        }
    }
}
