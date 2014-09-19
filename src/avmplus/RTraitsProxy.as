package avmplus
{
    public class RTraitsProxy extends RTraits
    {
        public function RTraitsProxy(traits:Object)
        {
            super();

            for each (var accessor:Object in traits.accessors)
            {
                this.accessors.push(new RMemberProxy(accessor));
            }

            for each (var variable:Object in traits.variables)
            {
                this.variables.push(new RMemberProxy(variable));
            }

            this.interfaces = traits.interfaces;

            for each (var method:Object in traits.methods)
            {
                this.methods.push(new RMemberProxy(method));
            }

            this.bases = traits.bases;

            for each (var metadata:Object in traits.metadata)
            {
                this.metadata.push(new RMetaProxy(metadata));
            }

            for each (var constr:Object in traits.constructor)
            {
                this.constructor.push(new RArgumentProxy(constr));
            }
        }
    }
}
