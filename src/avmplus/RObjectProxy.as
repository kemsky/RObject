package avmplus
{
    public class RObjectProxy extends RObject
    {
        public function RObjectProxy(object:Object)
        {
            this.isDynamic = object.isDynamic;
            this.isFinal = object.isFinal;
            this.isStatic = object.isStatic;
            this.name = object.isStatic;

            this.traits = new RTraitsProxy(object.traits);
        }
    }
}
