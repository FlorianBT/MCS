package map;

import properties.Properties;

class Generator {
    static var init:Bool = false;
    static var coverspace:Float;
    static var coverOdds:Array<Float>;
    static var coverPos:Array<Float>;
    static var lastLine = [0,0,0,0];
    static var seed:Int;
    
    static var totalLinesCount = 0;
    static var totalCoversCount = 0;

    var map:Map;
    var rand:hxd.Rand;

    public function new(target:Map) {
        if(!init) {
            coverspace = Properties.get("coverLineYSpacing") * Map.UNITS_PER_METER;
            var coverMinSize:h3d.col.Point = Properties.get("coverMinSize").clone();
            coverMinSize.scale(Map.UNITS_PER_METER);
            var coverMinWidth:Float = coverMinSize.x;
            coverPos = [
                (Map.WIDTH * 0.95 - coverMinWidth) * 0.5,
                0,
                (Map.WIDTH * 0.95 - coverMinWidth) * -0.5
            ];
            coverOdds = Properties.get("coverCountOdds");
            seed = Properties.get("seed");
            init = true;
        }
        map = target;
        rand = new hxd.Rand(seed);
    }

    public function reset() {
        for(floor in map.floors) {
            floor.remove();
        }
        for(cover in map.covers) {
            cover.remove();
        }

        map.floors = [];
        map.covers = [];
    }
    
    public function generate() {
        for(f in 0...4) {
            generateFloor();
        }
        
        generateCoverLines(10);
    }

    private function generateFloor() {
        var colors:Array<Int> = Properties.get("floorColors");
        var floor:Floor = makeFloor(map, Floor.DEFAULT_LENGTH, colors[map.floors.length % 2 == 0 ? 0 : 1]);
        if(map.floors.length > 0) {
            var prevFloor:Floor = map.floors[map.floors.length-1];
            floor.y = prevFloor.y + prevFloor.height;
        }
        map.floors.push(floor); 
    }

    public function generateCoverLines(lines:Int) {
        var coverY = map.covers.length > 0 ? map.covers[map.covers.length-1].y : coverspace * 0.75;
        var colors:Array<Int> = Properties.get("coverColors");
        for(k in 0...lines) {
            var coverLine:CoverLine = new CoverLine(map);
            map.covers.push(coverLine);

            var vSpace:Float = coverspace;
            coverLine.y = (coverY + vSpace);
            coverY += vSpace;

            generateCovers(coverLine, colors[totalLinesCount % colors.length]); 
            totalLinesCount++;           
        }
    }

    public function generateCovers(coverLine:CoverLine, ?color:Int = 0xFF0000) {
        var roll:Float = -1;

        //get covers count
        var count:Int = -1;
        do {
            roll = rand.rand();
            count = getRollResult(roll);
            if(count == 0 || count == 3) {
                trace(count + "-" + lastLine[count]);
            }
        } while((count == 0 || count == 3) && lastLine[count] > 0);
        //never more than X cover lines with either 0 or 3 covers at a time

        for(k in 0...lastLine.length) {
            var v:Int = lastLine[k] + (k == count ? Properties.get("coverEdgeRepeat") : -1);
            lastLine[k] = hxd.Math.imax(0,v);
        }

        //pick covers positions
        var coverPlacement = [];
        while(coverPlacement.length < count) {
            var pick = rand.random(coverPos.length);
            if(coverPlacement.indexOf(pick) < 0) {
                coverPlacement.push(pick);
            }
        }

        var coverMinSize:h3d.col.Point = Properties.get("coverMinSize").clone();
        coverMinSize.scale(Map.UNITS_PER_METER);
        var coverSizeNoise:h3d.col.Point = Properties.get("coverSizeNoise").clone();

        for(i in 0...count) {
            var coverSize:h3d.Vector = new h3d.Vector(
                coverMinSize.x * (1 + rand.srand(coverSizeNoise.x)),
                coverMinSize.y * (1 + rand.srand(coverSizeNoise.y)),
                coverMinSize.z * (1 + rand.srand(coverSizeNoise.z))
            );

            var cover:Cover = makeCover(coverLine, coverSize, color);
            totalCoversCount++;
            cover.x = coverPos[coverPlacement[i]]; //position
            
            //add noise
            var coverPosNoise:h2d.col.Point = Properties.get("coverPosNoise");
            cover.x += Map.WIDTH * rand.srand(coverPosNoise.x);
            cover.y += coverspace * rand.srand(coverPosNoise.y);

            coverLine.addCover(cover);
        }
    }

    private static function getRollResult(roll:Float):Int {
        var odd:Float = 0;
        for(i in 0...coverOdds.length) {
            odd += coverOdds[i];
            if(roll < odd) {
                return i;
            }
        }
        return coverOdds.length - 1;
    }

    private static function makeFloor(map:Map, ?height:Float = Floor.DEFAULT_LENGTH, ?color:Int = 0xF0F0F0):Floor {
        return new Floor(Map.WIDTH, height, color, map);
    }

    private static function makeCover(line:CoverLine, ?size:h3d.Vector = null, ?color:Int = 0xFF0000):Cover {
        if(size == null) {
            var minSize = Properties.get("coverMinSize").clone();
            minSize.scale3(Map.UNITS_PER_METER);
            size = minSize.toVector();
        }
        return new Cover(size, color, line);
    }
}