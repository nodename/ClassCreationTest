package
{
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.emit.impl.MethodArgument;

	public final class PairClassGenerator
	{
		private static const PAIR_CLASSES:Dictionary = new Dictionary();
		
		public static function getPairClass(type:Class, callback:Function):void
		{
			const pairClass:Class = PAIR_CLASSES[type];
			if (pairClass)
			{
				callback(pairClass);
			}
			else
			{
				new PairClassGenerator(LOCK, type, callback);
			}
		}
		
		public static function pairClass(type:Class):Class
		{
			return PAIR_CLASSES[type];
		}
		
		protected static const LOCK:Object = {};
		
		private var _callback:Function;
		
		public function PairClassGenerator(lock:Object, type:Class, callback:Function)
		{
			if (lock != LOCK)
			{
				throw new Error("PairClassGenerator: invalid constructor access");
			}
			
			_callback = callback;
			generatePairClass(type);
		}

		private function generatePairClass(type:Class):void
		{
			const qualifiedClassName:String = getQualifiedClassName(type);
			const className:String = qualifiedClassName.split('::')[1];
			const generatedClassPackage:String = "com.classes.generated";
			const pairClassName:String = "Pair<" + className + ">";
			
			const abcBuilder:IAbcBuilder = new AbcBuilder();
			const packageBuilder:IPackageBuilder = abcBuilder.definePackage(generatedClassPackage);
			const classBuilder:IClassBuilder = packageBuilder.defineClass(pairClassName);
			
			const propertyBuilder1:IPropertyBuilder = classBuilder.defineProperty("first", qualifiedClassName);
			propertyBuilder1.isConstant = false;
			//	propertyBuilder1.memberInitialization = new MemberInitialization();
			//	propertyBuilder1.memberInitialization.constructorArguments = [3, 3];
			propertyBuilder1.visibility = MemberVisibility.PUBLIC;
			
			const propertyBuilder2:IPropertyBuilder = classBuilder.defineProperty("second", qualifiedClassName);
			propertyBuilder2.isConstant = false;
			//	propertyBuilder2.memberInitialization = new MemberInitialization();
			//	propertyBuilder2.memberInitialization.constructorArguments = [2, 2];
			propertyBuilder2.visibility = MemberVisibility.PUBLIC;
			
			/*const methodBuilder1:IMethodBuilder = classBuilder.defineMethod("first");
			methodBuilder1.visibility = MemberVisibility.PUBLIC;
			methodBuilder1.returnType = qualifiedClassName;
			
			const firstSource:String = (<![CDATA[
			getlocal_0
			pushscope
			getlocal_0
			getproperty     private:_first
			returnvalue
			]]>).toString();
			
			methodBuilder1.addAsmSource(firstSource);
			
			const methodBuilder2:IMethodBuilder = classBuilder.defineMethod("second");
			methodBuilder2.visibility = MemberVisibility.PUBLIC;
			methodBuilder2.returnType = qualifiedClassName;
			
			const secondSource:String = (<![CDATA[
			getlocal_0
			pushscope
			getlocal_0
			getproperty     private:_second
			returnvalue
			]]>).toString();
			
			methodBuilder2.addAsmSource(secondSource);*/
			
			/*const accessorBuilder1:IAccessorBuilder = classBuilder.defineAccessor("first", "flash.geom.Point");
			accessorBuilder1.access = AccessorAccess.READ_ONLY;
			const accessorBuilder2:IAccessorBuilder = classBuilder.defineAccessor("second", "flash.geom.Point");
			accessorBuilder2.access = AccessorAccess.READ_ONLY;*/
			
			const ctorBuilder:ICtorBuilder = classBuilder.defineConstructor();
			const argument1:MethodArgument = ctorBuilder.defineArgument(qualifiedClassName);
			argument1.name = "first";
			const argument2:MethodArgument = ctorBuilder.defineArgument(qualifiedClassName);
			argument2.name = "second";
			
			
			// this form of specifying the bytecode is not yet working in as3-commons-bytecode;
			// see http://code.google.com/p/as3-commons/issues/detail?id=52
			
			/*const ctorSource:String = (<![CDATA[
			getlocal_0
			pushscope
			getlocal_0
			constructsuper  (0)
			getlocal_0
			getlocal_1
			initproperty    private:_first
			getlocal_0
			getlocal_2
			initproperty    private:_second
			returnvoid
			]]>).toString();
			
			ctorBuilder.addAsmSource(ctorSource);*/
			
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.pushscope);
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.constructsuper, [0]);
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.getlocal_1);
			ctorBuilder.addOpcode(Opcode.initproperty, [new QualifiedName("first", LNamespace.PUBLIC)]);
			ctorBuilder.addOpcode(Opcode.getlocal_0);
			ctorBuilder.addOpcode(Opcode.getlocal_2);
			ctorBuilder.addOpcode(Opcode.initproperty, [new QualifiedName("second", LNamespace.PUBLIC)]);
			ctorBuilder.addOpcode(Opcode.returnvoid);
			
			abcBuilder.addEventListener(Event.COMPLETE, loadedHandler);
			abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			
			abcBuilder.buildAndLoad();
			
			/*const binarySwf:ByteArray = abcBuilder.buildAndExport();
			const file:FileReference = new FileReference();
			file.save(binarySwf, "MyGeneratedClasses.swf");*/
			
			function removeListeners():void
			{
				abcBuilder.removeEventListener(Event.COMPLETE, loadedHandler);
				abcBuilder.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				abcBuilder.removeEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			}
			
			function loadedHandler(event:Event):void
			{
				removeListeners();
				const clazz:Class = ApplicationDomain.currentDomain.getDefinition(generatedClassPackage + "::" + pairClassName) as Class;
				PAIR_CLASSES[type] = clazz;
				_callback(clazz);
			}
		
			function errorHandler(event:Event):void
			{
				removeListeners();
				trace("Öy!");
			}
		}
		
	}
}