import h3d.col.*;
import map.Generator;
import properties.Properties;

class Main extends hxd.App {
    var map:map.Map;
    var camHandler:CameraHandler;
    var camCtrl:h3d.scene.CameraController;

    var posTxt:h2d.Text;
    var targetTxt:h2d.Text;

	override function init() {
        // adds a directional light to the scene
		var light = new h3d.scene.DirLight(new h3d.Vector(0.1, 0.2, -0.5), s3d);
		light.enableSpecular = false;

		// set the ambient light to 30%
		s3d.lightSystem.ambientLight.set(0.3, 0.3, 0.3);

        var win:hxd.Window = hxd.Window.getInstance();
        var wMin:h3d.col.Point = new h3d.col.Point(-200,-250,0);
        var wMax:h3d.col.Point = new h3d.col.Point(200,250,500);
        var oBounds:h3d.col.Bounds = h3d.col.Bounds.fromPoints(wMin, wMax);

        s3d.camera.pos.set(0, 350, 5);
        s3d.camera.target.set(0, 355, 0);
        s3d.camera.orthoBounds = oBounds;      
        
        map = new map.Map(s3d);
    
        posTxt = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        posTxt.text = "Pos: " + s3d.camera.pos;
        
        targetTxt = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        targetTxt.text = "Target: " + s3d.camera.target;
        targetTxt.y = 20;
	}

	static function main() {
        hxd.Res.initEmbed();
        Properties.load(#if hl false #end);
		new Main();
	}

    override function update( dt : Float ) {
        var move = { abs: 0, ord: 0 };

        if(hxd.Key.isDown(hxd.Key.UP)) {
            move.ord++;
        } 
        if(hxd.Key.isDown(hxd.Key.DOWN)) {
           move.ord--;
        }

        if(hxd.Key.isDown(hxd.Key.RIGHT)) {
            move.abs++;
        }         
        if(hxd.Key.isDown(hxd.Key.LEFT)) {
           move.abs--;
        }

        move.abs = hxd.Math.iclamp(move.abs, -1, 1);
        move.ord = hxd.Math.iclamp(move.ord, -1, 1);

        if(move.abs != 0 || move.ord != 0) {
            s3d.camera.pos.x += move.abs * 10 * dt;
            s3d.camera.target.x += move.abs * 10 * dt;

            s3d.camera.pos.y += move.ord * 10 * dt;
            s3d.camera.target.y += move.ord * 10 * dt;

            posTxt.text = "Pos: " + s3d.camera.pos;
            targetTxt.text = "Target: " + s3d.camera.target; 
        }

        map.update(dt);
    }

    function makeCube(color:Int, p:Point) {
        var prim:h3d.prim.Cube = new h3d.prim.Cube(15, 15, 15, true);
        prim.unindex();
		prim.addNormals();
		prim.addUniformUVs(1.0);
		prim.addTangents();

        var mesh = new h3d.scene.Mesh(prim, s3d);
        mesh.material.color.setColor(color);
        mesh.setPosition(p.x, p.y, p.z);
    }
}