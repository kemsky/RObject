package avmplus
{
    public class RObject
    {
        public var isFinal:Boolean = false;
        public var isDynamic:Boolean = false;
        public var isStatic:Boolean = false;

        public var name:String;

        public var traits:RTraits = new RTraits();
    }
}
