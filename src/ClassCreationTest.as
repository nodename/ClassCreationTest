package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.emit.IPropertyBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.emit.impl.MethodArgument;
	
	public class ClassCreationTest extends Sprite
	{
		public function ClassCreationTest()
		{
			generatePairClass();
		}

		private function generatePairClass():void
		{
			const pointType:String = "flash.geom.Point";
			
			const abcBuilder:IAbcBuilder = new AbcBuilder();
			const packageBuilder:IPackageBuilder = abcBuilder.definePackage("com.classes.generated");
			const classBuilder:IClassBuilder = packageBuilder.defineClass("PointPair");
			
			const propertyBuilder1:IPropertyBuilder = classBuilder.defineProperty("_first", pointType);
			//	propertyBuilder1.memberInitialization = new MemberInitialization();
			//	propertyBuilder1.memberInitialization.constructorArguments = [3, 3];
			propertyBuilder1.visibility = MemberVisibility.PRIVATE;
			
			const propertyBuilder2:IPropertyBuilder = classBuilder.defineProperty("_second", pointType);
			//	propertyBuilder2.memberInitialization = new MemberInitialization();
			//	propertyBuilder2.memberInitialization.constructorArguments = [2, 2];
			propertyBuilder2.visibility = MemberVisibility.PRIVATE;
			
			/*const methodBuilder1:IMethodBuilder = classBuilder.defineMethod("first");
			methodBuilder1.visibility = MemberVisibility.PUBLIC;
			methodBuilder1.returnType = pointType;
			
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
			methodBuilder2.returnType = pointType;
			
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
			const argument1:MethodArgument = ctorBuilder.defineArgument(pointType);
			const argument2:MethodArgument = ctorBuilder.defineArgument(pointType);
			
			
			const ctorSource:String = (<![CDATA[
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
			
			ctorBuilder.addAsmSource(ctorSource);
			
			abcBuilder.addEventListener(Event.COMPLETE, loadedHandler);
			abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			
			abcBuilder.buildAndLoad();
			
			/*const binarySwf:ByteArray = abcBuilder.buildAndExport();
			const file:FileReference = new FileReference();
			file.save(binarySwf, "MyGeneratedClasses.swf");*/
		}
		
		private function errorHandler(event:Event):void
		{
			trace("Öy!");
		}
		
		private function loadedHandler(event:Event):void
		{
			const clazz:Class = ApplicationDomain.currentDomain.getDefinition("com.classes.generated.PointPair") as Class;
			//const clazz:Class = ApplicationDomain.currentDomain.getDefinition("PointPair") as Class;
			const desc:XML = flash.utils.describeType(clazz);
			trace(desc.toString());
			
			const p0:Point = new Point(1, 0);
			const p1:Point = new Point(0, 1);
			const instance:Object = new clazz(p0, p1);
			
			//trace(instance._first);
			//trace(instance._second);
		}
	}
}