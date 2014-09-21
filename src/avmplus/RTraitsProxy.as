package avmplus
{
    public class RTraitsProxy extends RTraits
    {
        public function RTraitsProxy(traits:Object, flags:uint)
        {
            if((flags & R.ACCESSORS) == R.ACCESSORS)
            {
                for each (var accessor:Object in traits.accessors)
                {
                    this.accessors.push(new RMemberProxy(accessor, flags));
                }
            }

            if((flags & R.VARIABLES) == R.VARIABLES)
            {
                for each (var variable:Object in traits.variables)
                {
                    this.variables.push(new RMemberProxy(variable, flags));
                }
            }

            if((flags & R.INTERFACES) == R.INTERFACES)
            {
                this.interfaces = traits.interfaces;
            }

            if((flags & R.METHODS) == R.METHODS)
            {
                for each (var method:Object in traits.methods)
                {
                    this.methods.push(new RMemberProxy(method, flags));
                }
            }

            if((flags & R.BASES) == R.BASES)
            {
                this.bases = traits.bases;
            }

            if((flags & R.METADATA) == R.METADATA)
            {
                for each (var metadata:Object in traits.metadata)
                {
                    this.metadata.push(new RMetaProxy(metadata));
                }
            }

            if((flags & R.CONSTRUCTOR) == R.CONSTRUCTOR)
            {
                for each (var constr:Object in traits.constructor)
                {
                    this.constructor.push(new RArgumentProxy(constr));
                }
            }
        }
    }
}
