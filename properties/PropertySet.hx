package properties;

import js.html.TableCaptionElement;
import haxe.ds.Map;

class PropertySet {
    var data:Map<String,Property>;

    public var count(default,null): Int;
    
    public function new() {
        clear();
    }

    public function clear():Void {
        data = new Map<String,Property>();
        count = 0;
    }

    public function add(key:String, value:String):Void {
        key = StringTools.trim(key);
        value = StringTools.trim(value);
        if(key.length <= 0) {
            trace("Invalid empty key used for property");
            return;
        }
        if(value.length <= 0) {
            trace("No value specified for property <"+key+">");
            return;
        }
        if(data.exists(key)) {
            trace("Property <" + key + "> already exists.");
            return;
        }
        data.set(key, new Property(value));
        count++;
        trace("Added property <" + key +  " => " + value + ">");
    }

    public function getProperty(key:String): Property {
        if(!data.exists(key)) {
            trace("Cannot find property <" + key + ">");
            return null;
        }               
        return data[key];
    }
    
    public function get<T>(key:String): T {
        var prop:Property = getProperty(key);
        return (prop != null ? (prop.value : T) : null);
    }
}