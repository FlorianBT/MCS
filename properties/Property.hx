package properties;

class Property {
    var value:Any;

    public function new(str:String) {
        parse(str);
    }

    function parse(str:String):Void {
        if(StringTools.trim(str).length <= 0) {
            value = null;
            trace("Parsing empty property - set to null");
            return;
        }

        if(StringTools.startsWith(str, "#")) 
        {
            parse("0x" + str.substr(1));
        }
        else if(StringTools.startsWith(str, "[")
            && StringTools.endsWith(str, "]")) 
        {
            var values:Array<String> = str.split(",");
            switch(values.length) {
                case 0: 
                {
                    value = null;
                    trace("Parsing invalid property (" + str + ")- set to null");
                }
                case 1:
                {
                    parse(values[0]);
                }
                case 2:
                {
                    value = new h2d.col.Point(Std.parseFloat(values[0]), Std.parseFloat(values[1]));
                }
                case 3:
                {
                    value = new h3d.col.Point(Std.parseFloat(values[0])
                                            , Std.parseFloat(values[1])
                                            , Std.parseFloat(values[2]));
                }
                case 4:
                {
                    value = new h3d.Vector(Std.parseFloat(values[0])
                                        , Std.parseFloat(values[1])
                                        , Std.parseFloat(values[2])
                                        , Std.parseFloat(values[3]));
                }
                default: 
                {
                    var container:Array<Float> = new Array<Float>();
                    for(i in 0...values.length) {
                        container.push(Std.parseFloat(values[i]));
                    }
                    value = container;
                }
            }
        }
        else {
            var intVal:Int = Std.parseInt(str);
            if(intVal != null) {
                value = intVal;
                return;
            }

            var floatVal:Float = Std.parseFloat(str);
            if(floatVal != null && !Math.isNaN(floatVal)) {
                value = floatVal;
                return;
            }

            value = str;
        }
    }
}