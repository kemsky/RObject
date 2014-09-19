package avmplus
{
    public class RArgumentProxy extends RArgument
    {
        public function RArgumentProxy(argument:Object)
        {
            super(argument.type, argument.optional);
        }
    }
}
