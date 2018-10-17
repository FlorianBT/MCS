package map;

import properties.Properties;

class Player extends h3d.scene.Object {
    var size(default,null):h2d.col.Point;
    var color(default,null):Int;
    var radius(default,null):Float;

    public function new(?parent:h3d.scene.Object) {
        super(parent);

        size = Properties.get("playerSize").clone().scale(Map.UNITS_PER_METER);
        color = Properties.get("playerColor");
        
        radius = size.x * 0.5;

        var prim:h3d.prim.Cylinder = new h3d.prim.Cylinder(16, radius, size.y - radius);
        prim.addNormals();
        prim.addTCoords();
        
        var sprim:h3d.prim.Sphere = new h3d.prim.Sphere(radius, 16, 12);
        sprim.addNormals();
        sprim.addUVs();

        var s1:h3d.scene.Mesh = new h3d.scene.Mesh(sprim, this); 
        s1.material.color.setColor(color);      
        var s2:h3d.scene.Mesh = new h3d.scene.Mesh(sprim, this);
        s2.material.color.setColor(color);        
        var cylinder:h3d.scene.Mesh = new h3d.scene.Mesh(prim, this);
        cylinder.material.color.setColor(color);

        s1.setPosition(0,0, radius * 0.5);
        cylinder.setPosition(s1.x, s1.y, s1.z);
        s2.setPosition(s1.x, s1.y, cylinder.z + size.y - radius); 
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