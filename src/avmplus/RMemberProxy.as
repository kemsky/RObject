package avmplus
{
    public class RMemberProxy extends RMember
    {
        public function RMemberProxy(member:Object)
        {
            super(member.name, member.type, member.access, member.declaredBy, member.returnType);

            this.uri = member.uri;

            for each (var parameter:Object in member.parameters)
            {
                this.parameters.push(new RArgumentProxy(parameter));
            }

            for each (var meta:Object in member.metadata)
            {
                this.metadata.push(new RMetaProxy(meta));
            }
        }
    }
}
