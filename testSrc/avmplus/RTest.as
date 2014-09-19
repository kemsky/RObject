package avmplus
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import mx.logging.ILogger;
    import flash.utils.describeType;
    import mx.logging.Log;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertTrue;

    public class RTest
    {
        private static const log:ILogger = Log.getLogger("avmplus.RTest");

        [Test]
        public function testQualifiedClassName():void
        {
            assertEquals(flash.utils.getQualifiedClassName(null), Types.getQualifiedClassName(null));
            assertEquals(flash.utils.getQualifiedClassName(Object), Types.getQualifiedClassName(Object));
            assertEquals(flash.utils.getQualifiedClassName(TestObject), Types.getQualifiedClassName(TestObject));
            assertEquals(flash.utils.getQualifiedClassName(ITestObject), Types.getQualifiedClassName(ITestObject));
        }

        [Test]
        public function testDefinitionByName():void
        {
            assertEquals(getDefinitionByName("String"), Types.getDefinitionByName("String"));
            assertEquals(getDefinitionByName("Object"), Types.getDefinitionByName("Object"));
            assertEquals(getDefinitionByName("avmplus.TestObject"), Types.getDefinitionByName("avmplus.TestObject"));
            assertEquals(getDefinitionByName("avmplus.ITestObject"), Types.getDefinitionByName("avmplus.ITestObject"));
        }

        [Test]
        public function testNonEmptyConstructor():void
        {
            try
            {
                R.describe(TestObject);
                assertFalse(true);
            }
            catch(e:Error)
            {

            }
        }

        [Test]
        public function testInterface():void
        {
            var json:RObject = R.describe(ITestObject, R.TRAITS | R.METHODS);
            assertEquals(1, json.traits.methods.length);
            assertEquals(1, json.traits.methods[0].parameters.length);
            assertEquals("String", json.traits.methods[0].parameters[0].type);
            assertEquals(false, json.traits.methods[0].parameters[0].optional);
            assertEquals("String", json.traits.methods[0].returnType);
            assertEquals("avmplus::ITestObject", json.traits.methods[0].declaredBy);
        }

        [Test]
        public function testReflectionFromXML():void
        {
            var test:TestObject = new TestObject("");
            var flags:int = R.ACCESSORS | R.VARIABLES | R.METADATA | R.TRAITS | R.METHODS | R.CONSTRUCTOR | R.BASES | R.INTERFACES;
            var json:RObject = R.describeInstance(test, flags);
            var jsonXML:RObject = R.describeFromXML(flash.utils.describeType(test), flags);

            //remove Object methods:
            json.traits.methods = (json.traits.methods as Array).filter(function (item:Object, index:int, array:Array):Boolean {
                return item.declaredBy != "Object";
            });

            assertEquals(json.isDynamic, jsonXML.isDynamic);
            assertEquals(json.isFinal, jsonXML.isFinal);
            assertEquals(json.isStatic, jsonXML.isStatic);
            assertEquals(json.name, jsonXML.name);

            assertNotNull(json.traits);
            assertNotNull(jsonXML.traits);

            assertEquals(json.traits.accessors.length, jsonXML.traits.accessors.length);
            assertEquals(json.traits.variables.length, jsonXML.traits.variables.length);
            assertEquals(json.traits.methods.length, jsonXML.traits.methods.length);
            assertEquals(json.traits.constructor.length, jsonXML.traits.constructor.length);
            assertEquals(json.traits.metadata.length, jsonXML.traits.metadata.length);
            assertEquals(json.traits.bases.length, jsonXML.traits.bases.length);
            assertEquals(json.traits.interfaces.length, jsonXML.traits.interfaces.length);

            assertBases(json, jsonXML);
            assertInterfaces(json, jsonXML);
            assertParameters(json.traits.constructor, jsonXML.traits.constructor);
            assertMembers(json.traits.methods, jsonXML.traits.methods);
            assertMembers(json.traits.variables, jsonXML.traits.variables);
            assertMembers(json.traits.accessors, jsonXML.traits.accessors);
            assertMetadata(json.traits.metadata, jsonXML.traits.metadata);
        }

        private function assertMembers(json:Array, jsonXML:Array):void
        {
            json = json.sortOn("name");
            jsonXML = jsonXML.sortOn("name");

            for (var i:int = 0; i < jsonXML.length; i++)
            {
                var m1:RMember = jsonXML[i];
                var m2:RMember = json[i];

                assertEquals(m2.type, m1.type);
                assertEquals(m2.access, m1.access);
                assertEquals(m2.declaredBy, m1.declaredBy);
                assertEquals(m2.name, m1.name);
                assertEquals(m2.returnType, m1.returnType);
                assertEquals(m2.uri, m1.uri);
                assertParameters(m2.parameters, m1.parameters);
                assertMetadata(m2.metadata, m1.metadata);
            }
        }

        private function assertMetadata(json:Array, jsonXML:Array):void
        {
            for (var i:int = 0; i < jsonXML.length; i++)
            {
                var m1:RMeta = jsonXML[i];
                var m2:Object = json[i];

                assertEquals(m2.name, m1.name);
                assertEquals(m2.value.length, m1.value.length);
            }
        }

        private function assertParameters(json:Array, jsonXML:Array):void
        {
            for (var i:int = 0; i < jsonXML.length; i++)
            {
                var m1:RArgument = jsonXML[i];
                var m2:Object = json[i];

                assertEquals(m2.type, m1.type);
                assertEquals(m2.optional, m1.optional);
            }
        }

        private function assertInterfaces(json:Object, jsonXML:RObject):void
        {
            for each (var base:String in json.traits.interfaces)
            {
                assertTrue(jsonXML.traits.interfaces.indexOf(base) >= 0);
            }
        }

        private function assertBases(json:Object, jsonXML:RObject):void
        {
            for each (var base:String in json.traits.bases)
            {
                assertTrue(jsonXML.traits.bases.indexOf(base) >= 0);
            }
        }
    }
}
