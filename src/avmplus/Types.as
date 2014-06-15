package avmplus
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class Types
    {
        private static const CLASS_PATTERN:RegExp = /\.([a-zA-Z0-9_$]+)$/;

        private static const classToFullName:Dictionary = new Dictionary(true);
        private static const fullNameToClass:Dictionary = new Dictionary(true);

        classToFullName[Number] = "Number";
        classToFullName[int] = "int";
        classToFullName[uint] = "uint";
        classToFullName[String] = "String";
        classToFullName[Boolean] = "Boolean";
        classToFullName[Date] = "Date";
        classToFullName[XML] = "XML";
        classToFullName[Class] = "Class";


        fullNameToClass["Number"] = Number;
        fullNameToClass["int"] = int;
        fullNameToClass["uint"] = uint;
        fullNameToClass["String"] = String;
        fullNameToClass["Boolean"] = Boolean;
        fullNameToClass["Date"] = Date;
        fullNameToClass["XML"] = XML;
        fullNameToClass["Class"] = Class;


        public static function getQualifiedClassName(object:*):String
        {
            if(!(object is Class) && object != null)
            {
                object = object.constructor;
            }

            var name:String = classToFullName[object];
            if(name == null)
            {
                name = flash.utils.getQualifiedClassName(object);
                fullNameToClass[name] = object;
                classToFullName[object] = name;
            }
            return name;
        }

        public static function getDefinitionByName(object:String):Class
        {
            var clazz:Class = fullNameToClass[object];
            if(clazz == null)
            {
                clazz = flash.utils.getDefinitionByName(object) as Class;
                fullNameToClass[object] = clazz;
                classToFullName[clazz] = object.replace(CLASS_PATTERN, "::$1");
            }
            return clazz;
        }
    }
}
