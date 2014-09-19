package avmplus
{
    import flash.utils.Dictionary;

    import mx.logging.ILogger;
    import mx.logging.Log;

    import flash.utils.describeType;

    /**
     * Fast reflection for ActionScript
     */
    public class R
    {
        private static const log:ILogger = Log.getLogger("avmplus.R");

        public static const HIDE_NSURI_METHODS:uint = 1;
        public static const BASES:uint = 2;
        public static const INTERFACES:uint = 4;
        public static const VARIABLES:uint = 8;
        public static const ACCESSORS:uint = 16;
        public static const METHODS:uint = 32;
        public static const METADATA:uint = 64;
        public static const CONSTRUCTOR:uint = 128;
        public static const TRAITS:uint = 256;
        public static const USE_ITRAITS:uint = 512;
        public static const HIDE_OBJECT:uint = 1024;
        public static const FLASH10_FLAGS:uint = 1535;

        private static const cache:Dictionary = new Dictionary(true);

        /**
         * Cache describeTypeJSON results
         */
        public static var cacheEnabled:Boolean = false;

        /**
         * Describe class or instance
         * @param o class or instance
         * @param flags describeTypeJSON flags
         * @return descriptor object
         */
        public static function describe(o:*, flags:uint = 0):RObject
        {
            var result:RObject;
            if (cacheEnabled)
            {
                var key:String;
                if (o is Class)
                {
                    key = flags + o.toString();
                    result = cache[key];
                    if (result == null)
                    {
                        result = describeClass(o, flags);
                        cache[key] = result;
                    }
                }
                else
                {
                    key = flags + o.constructor.toString();
                    result = cache[key];
                    if (result == null)
                    {
                        result = describeInstance(o, flags);
                        cache[key] = result;
                    }
                }
            }
            else
            {
                if (o is Class)
                {
                    result = describeClass(o, flags);
                }
                else
                {
                    result = describeInstance(o, flags);
                }
            }

            return result;
        }

        /**
         * Fast describe instance
         * @param o instance
         * @param flags
         * @return descriptor object
         */
        public static function describeInstance(o:*, flags:uint = 0):RObject
        {
            return new RObjectProxy(describeTypeJSON(o, flags));
        }

        /**
         * Fast describe class
         * @param type class
         * @param flags
         * @return descriptor object
         */
        public static function describeClass(type:Class, flags:uint = 0):RObject
        {
            var result:RObject;
            var instance:*;
            try
            {
                instance = new type();
                result = new RObjectProxy(describeTypeJSON(instance, flags));
            }
            catch (e:Error)
            {
                if(e.errorID == 1001)
                {
                    //interface
                    result = describeFromXML(flash.utils.describeType(type), flags);
                }
                else if(e.errorID == 1063)
                {
                    //class has constructor parameters
                    result = describeFromXML(flash.utils.describeType(type), flags);
                }
                else
                {
                    //any other error
                    throw e;
                }
            }

            return result;
        }

        /**
         * Parse descriptor from flash.utils.describeType
         * @param descriptor - XML descriptor
         * @param flags
         * @return describeTypeJSON compatible descriptor
         */
        public static function describeFromXML(descriptor:XML, flags:int):RObject
        {
            if (descriptor.factory.length() > 0)
            {
                descriptor = descriptor.factory[0];
            }

            var custom:RObject = new RObject();
            custom.isDynamic = descriptor.@isDynamic.toString() == "true";
            custom.isFinal = descriptor.@isFinal == "true";
            custom.isStatic = descriptor.@isStatic == "true";
            custom.name = descriptor.@name;

            if (custom.name.length == 0)
            {
                custom.name = descriptor.@type;
            }

            if((flags & TRAITS) == TRAITS)
            {
                if ((flags & BASES) == BASES)
                {
                    var extendsClasses:XMLList = descriptor.extendsClass;
                    if (extendsClasses.length() > 0)
                    {
                        for each (var extendsClass:XML in extendsClasses)
                        {
                            custom.traits.bases.push(extendsClass.@type[0].toString());
                        }
                    }
                }

                if ((flags & INTERFACES) == INTERFACES)
                {
                    var interfaces:XMLList = descriptor.implementsInterface;
                    if (interfaces.length() > 0)
                    {
                        for each (var interf:XML in interfaces)
                        {
                            custom.traits.interfaces.push(interf.@type[0].toString());
                        }
                    }
                }

                if ((flags & CONSTRUCTOR) == CONSTRUCTOR)
                {
                    var constructor:XMLList = descriptor.constructor;
                    if (constructor.length() > 0)
                    {
                        custom.traits.constructor = custom.traits.constructor.concat(getParameters(constructor[0]));
                    }
                }

                var member:RMember;

                if ((flags & VARIABLES) == VARIABLES)
                {
                    var variables:XMLList = descriptor.variable;
                    if (variables.length() > 0)
                    {
                        for each (var variable:XML in variables)
                        {
                            member = new RMember(variable.@name, convert(variable.@type), "readwrite", null, null);
                            member.metadata = member.metadata.concat(getMetadata(variable));
                            member.uri = convert(variable.@uri);
                            custom.traits.variables.push(member);
                        }
                    }
                }

                if ((flags & VARIABLES) == VARIABLES)
                {
                    var constants:XMLList = descriptor.constant;
                    if (constants.length() > 0)
                    {
                        for each (var constant:XML in constants)
                        {
                            member = new RMember(constant.@name, convert(constant.@type), "readonly", null, null);
                            member.metadata = member.metadata.concat(getMetadata(constant));
                            member.uri = convert(constant.@uri);
                            custom.traits.variables.push(member);
                        }
                    }
                }

                if ((flags & ACCESSORS) == ACCESSORS)
                {
                    var accessors:XMLList = descriptor.accessor;
                    if (accessors.length() > 0)
                    {
                        for each (var accessor:XML in accessors)
                        {
                            member = new RMember(accessor.@name, convert(accessor.@type), convert(accessor.@access), convert(accessor.@declaredBy), null);
                            member.metadata = member.metadata.concat(getMetadata(accessor));
                            member.uri = convert(accessor.@uri);
                            custom.traits.accessors.push(member);
                        }
                    }
                }

                if ((flags & METHODS) == METHODS)
                {
                    var methods:XMLList = descriptor.method;
                    if (methods.length() > 0)
                    {
                        for each (var method:XML in methods)
                        {
                            member = new RMember(method.@name, convert(method.@type), null, convert(method.@declaredBy), convert(method.@returnType));
                            member.metadata = member.metadata.concat(getMetadata(method));
                            member.parameters = member.parameters.concat(getParameters(method));
                            member.uri = convert(method.@uri);
                            custom.traits.methods.push(member);
                        }
                    }
                }

                if ((flags & METADATA) == METADATA)
                {
                    custom.traits.metadata = custom.traits.metadata.concat(getMetadata(descriptor));
                }

            }
            return custom;
        }

        /**
         * @private
         */
        private static function convert(list:XMLList):String
        {
            return list.length() > 0 ? list: null;
        }

        /**
         * @private
         */
        private static function getParameters(source:XML):Array
        {
            var result:Array = [];
            var constructor:XMLList = source.parameter;
            if (constructor.length() > 0)
            {
                for each (var arg:XML in constructor)
                {
                    result.push(new RArgument(arg.@type, arg.@optional == "true"));
                }
            }
            return result;
        }

        /**
         * @private
         */
        private static function getMetadata(source:XML):Array
        {
            var result:Array = [];
            var metadatas:XMLList = source.metadata;
            for each (var metadata:XML in metadatas)
            {
                var name:String = metadata.@name;

                var meta:RMeta = new RMeta(name);
                result.push(meta);

                var args:XMLList = metadata.arg;
                for each (var value:XML in args)
                {
                    meta.value.push(new RValue(value.@key, value.@value));
                }
            }
            return result;
        }
    }
}
