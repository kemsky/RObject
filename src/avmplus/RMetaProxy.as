package avmplus
{
    public class RMetaProxy extends RMeta
    {
        public function RMetaProxy(meta:Object)
        {
            super(meta.name);

            for each (var value:Object in meta.value)
            {
                this.value.push(new RValueProxy(value));
            }
        }
    }
}
