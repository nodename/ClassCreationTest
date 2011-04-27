package
{
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.MultinameKind;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.emit.impl.MethodArgument;

	public final class TupleClassGenerator
	{
		public static const GENERATED_CLASS_PACKAGE:String = "com.classes.generated";
		
		public static function getTupleClass(properties:TupleClassProperties, callback:Function):void
		{
			try
			{
				const tupleClass:Class = ApplicationDomain.currentDomain.getDefinition(GENERATED_CLASS_PACKAGE + "::" + properties.tupleClassName) as Class;
				if (tupleClass)
				{
					callback(tupleClass);
				}
			}
			catch (e:Error)
			{
				new TupleClassGenerator(LOCK, properties, callback);
			}
		}
		
		protected static const LOCK:Object = {};
		
		public function TupleClassGenerator(lock:Object, properties:TupleClassProperties, callback:Function)
		{
			if (lock != LOCK)
			{
				throw new Error("PairClassGenerator: invalid constructor access");
			}
			
			generateTupleClass(properties, callback);
		}

		private function generateTupleClass(tupleClassProperties:TupleClassProperties, callback:Function):void
		{
			const generatedClassPackage:String = "com.classes.generated";
			
			const abcBuilder:IAbcBuilder = new AbcBuilder();
			const packageBuilder:IPackageBuilder = abcBuilder.definePackage(generatedClassPackage);
			const tupleClassName:String = tupleClassProperties.tupleClassName;
			const classBuilder:IClassBuilder = packageBuilder.defineClass(tupleClassName);
			const properties:Vector.<ClassProperty> = tupleClassProperties.properties;
			
			var propertyIndex:uint;
			
			for (propertyIndex = 0; propertyIndex < properties.length; propertyIndex++)
			{
				var prop:ClassProperty = properties[propertyIndex];
				var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty(prop.memberName, prop.qualifiedClassName);
				propertyBuilder.isConstant = false;
				propertyBuilder.visibility = prop.visibility;
			}
			
			const namespaceName:String = generatedClassPackage + ":" + tupleClassName;
			const publicNamespace:LNamespace = LNamespace.PUBLIC;
			const protectedNamespace:LNamespace = new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, namespaceName);
			const privateNamespace:LNamespace = new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, namespaceName);
			
			const namespaceMap:Dictionary = new Dictionary();
			namespaceMap[MemberVisibility.PUBLIC] = publicNamespace;
			namespaceMap[MemberVisibility.PROTECTED] = protectedNamespace;
			namespaceMap[MemberVisibility.PRIVATE] = privateNamespace;
			
			const ctorBuilder:ICtorBuilder = classBuilder.defineConstructor();
			for (propertyIndex = 0; propertyIndex < properties.length; propertyIndex++)
			{
				prop = properties[propertyIndex];
				var argument:MethodArgument = ctorBuilder.defineArgument(prop.qualifiedClassName);
				argument.name = prop.accessorName; // don't even need name really
			}
			
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.pushscope);
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.constructsuper, [0]);
			
			for (propertyIndex = 0; propertyIndex < properties.length; propertyIndex++)
			{
				prop = properties[propertyIndex];
				ctorBuilder.addOpcode(Opcode.getlocal_0);
				addGetLocalOpcode(propertyIndex);
				ctorBuilder.addOpcode(Opcode.initproperty, [new QualifiedName(prop.memberName, namespaceMap[prop.visibility])]);
			}
			
			ctorBuilder.addOpcode(Opcode.returnvoid);
			
			abcBuilder.addEventListener(Event.COMPLETE, loadedHandler);
			abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			
			abcBuilder.buildAndLoad();
			
			// This code would write the class out to a swf rather than loading it into the current application:
			
			/*const binarySwf:ByteArray = abcBuilder.buildAndExport();
			const file:FileReference = new FileReference();
			file.save(binarySwf, "MyGeneratedClasses.swf");*/
			
			function addGetLocalOpcode(propertyIndex:uint):void
			{
				var getlocalIndex:uint = propertyIndex + 1;
				if (getlocalIndex < 4)
				{
					ctorBuilder.addOpcode(Opcode["getlocal_" + getlocalIndex]);
				}
				else
				{
					ctorBuilder.addOpcode(Opcode.getlocal, [ getlocalIndex ]);
				}
			}
			
			function removeListeners():void
			{
				abcBuilder.removeEventListener(Event.COMPLETE, loadedHandler);
				abcBuilder.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				abcBuilder.removeEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			}
			
			function loadedHandler(event:Event):void
			{
				const clazz:Class = ApplicationDomain.currentDomain.getDefinition(generatedClassPackage + "::" + tupleClassName) as Class;
				callback(clazz);
				removeListeners();
			}
		
			function errorHandler(event:Event):void
			{
				trace("Öy!");
				removeListeners();
			}
		}
		
	}
}

