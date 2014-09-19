/**
 * Created by dookie on 09/19/2014.
 */
package avmplus
{
    public class RValueProxy extends RValue
    {
        public function RValueProxy(value:Object)
        {
            super(value.key, value.value);
        }
    }
}
