package avmplus
{
    public class RObjectProxy extends RObject
    {
        public function RObjectProxy(object:Object, flags:uint)
        {
            this.isDynamic = object.isDynamic;
            this.isFinal = object.isFinal;
            this.isStatic = object.isStatic;
            this.name = object.isStatic;

            if((flags & R.TRAITS) == R.TRAITS)
                this.traits = new RTraitsProxy(object.traits, flags);
        }
    }
}
