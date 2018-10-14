package properties;

class Properties {
    static var res:hxd.res.Resource;
    static var loaded:Bool = false;
    static var properties:PropertySet;

    public static function load():Void {
        if(loaded) {return;}

        properties = new PropertySet();

        res = hxd.Res.game;
        trace("Loading properties :" + res.name);

        var content = res.entry.getText();
        if(content != null) {
            parse(content, true);
            trace("Loaded " + properties.count + " properties");
        }
    }

    private static function parse(content:String, ?clear:Bool = false):Void {
        if(clear) { properties.clear(); }

        if(content.length <= 0) { return; }

        var lines:Array<String> = content.split("\n");
        for(line in lines) {
            var l:String = StringTools.trim(line);
            if(StringTools.startsWith(l,"#")) { continue; }
            var lineData:Array<String> = l.split(":");
            if(lineData.length != 2) {
                trace("Invalid property line :\n>> " + l);
                continue;
            }
            properties.add(lineData[0], lineData[1]);
        }
    }
}