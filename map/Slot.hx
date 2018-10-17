package map;

import properties.Properties;

class Slot extends h3d.scene.Object {
    var debugCube:h3d.scene.Mesh;

    public function new(_x:Float, _y:Float, _z:Float, parent:Cover) {
        super(parent);
        setPosition(_x, _y, _z);

        if(Properties.get("showSlot")) {
            var prim:h3d.prim.Cube = h3d.prim.Cube.defaultUnitCube();
            debugCube = new h3d.scene.Mesh(prim, this);
            debugCube.material.color.setColor(0x0000FF);
            debugCube.scale(3);
        } 
    }
}