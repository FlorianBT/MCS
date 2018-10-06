package map;

@:allow(map.Generator)
class Map extends h3d.scene.Object {
    public static inline var UNITS_PER_METER:Float = 10.;
    public static inline var METER_PER_UNIT:Float = 1 / UNITS_PER_METER;   

    public static inline var WIDTH:Float = 40 * Map.UNITS_PER_METER;

    var generator:Generator;
    var floors:Array<Floor>; 
    var covers:Array<CoverLine>;   

    public function new(?mapName:String = "Default map", ?parent : h3d.scene.Object) {
        super(parent);        

        name = mapName;
        floors = new Array<Floor>();
        covers = new Array<CoverLine>();

        generator = new Generator(this);
        generator.generate();    
    }

    public function regen() {
        generator.reset();
        generator.generate();
    }

    public function update(dt:Float) {
        var cam:h3d.Camera = getScene().camera;
        for(floor in floors) {
            if(floor.y + floor.height > cam.pos.y - cam.orthoBounds.ySize) {continue;}
            if(floor.getBounds().inFrustum(getScene().camera.m)) {continue;}
            var lastFloor:Floor = floors[floors.length-1];
            floor.y = lastFloor.y + lastFloor.height;
            break; //only one floor at a time anyway
        }
        floors.sort(function(x:Floor,y:Floor):Int {
            if(x.y == y.y) return 0;
            return x.y > y.y ? 1 : -1;
        });

        var i:Int = 0;
        var del:Int = 0;
        while(i < covers.length) {
            var line:CoverLine = covers[i];
            if(line.y > cam.pos.y - cam.orthoBounds.ySize) { ++i; continue;}
            if(line.getBounds().inFrustum(getScene().camera.m)) { ++i; continue;}
            line.remove();
            covers.remove(line);
            del++;
        }

        if(del > 0) {
            generator.generateCoverLines(del);
        }
    }
}