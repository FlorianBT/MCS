package map;

class Player extends h3d.scene.Object {
    static inline var WIDTH:Float = 0.8 * Map.UNITS_PER_METER; //TODO properties
    static inline var HEIGHT:Float = 1.8 * Map.UNITS_PER_METER; //TODO properties
    static inline var COLOR:Int = 0x000000; //TODO properties

    var radius:Float;

    public function new(?parent:h3d.scene.Object) {
        super(parent);

        radius = WIDTH * 0.5;

        var prim:h3d.prim.Cylinder = new h3d.prim.Cylinder(16, radius, HEIGHT -radius);
        prim.addNormals();
        prim.addTCoords();
        
        var sprim:h3d.prim.Sphere = new h3d.prim.Sphere(radius, 16, 12);
        sprim.addNormals();
        sprim.addUVs();

        var s1:h3d.scene.Mesh = new h3d.scene.Mesh(sprim, this); 
        s1.material.color.setColor(COLOR);      
        var s2:h3d.scene.Mesh = new h3d.scene.Mesh(sprim, this);
        s2.material.color.setColor(COLOR);        
        var cylinder:h3d.scene.Mesh = new h3d.scene.Mesh(prim, this);
        cylinder.material.color.setColor(COLOR);

        s1.setPosition(0,0, radius * 0.5);
        cylinder.setPosition(s1.x, s1.y, s1.z);
        s2.setPosition(s1.x, s1.y, cylinder.z + HEIGHT - radius); 
    }

    private function setPositionV(pos:h3d.Vector) {
        setPosition(pos.x,pos.y,pos.z);
    }

    public function goToCover(cover:Cover, ?instant:Bool = false) {
        var dir:h3d.Vector = cover.localToGlobal().sub(this.localToGlobal());
        var targetPos:h3d.Vector = cover.getSlot(hxd.Direction.from(0, dir.y), true);

        if(instant) {
            setPositionV(globalToLocal(targetPos));
        }
    }
}