/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/16/11
 * Time: 11:03 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.activities
{
    import com.flashartofwar.BitmapScroller;
    import com.flashartofwar.behaviors.EaseScrollBehavior;
    import com.flashartofwar.ui.Slider;
    import com.gamecook.dungeonsanddice.factories.SpriteSheetFactory;
    import com.gamecook.frogue.enum.SlotsEnum;
import com.gamecook.frogue.maps.RandomMap;
import com.gamecook.frogue.renderer.MapDrawingRenderer;
import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.dungeonsanddice.factories.SpriteFactory;
    import com.gamecook.dungeonsanddice.factories.SpriteSheetFactory;
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.views.IMenuOptions;
    import com.gamecook.dungeonsanddice.views.MenuBar;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
import flash.text.StyleSheet;
import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class DungeonActivity extends LogoActivity implements IMenuOptions
    {

        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var bitmapScroller:BitmapScroller;
        private var slider:Slider;
        private var easeScrollBehavior:EaseScrollBehavior;
        private var scrollerContainer:Sprite;
        private var instancesRects:Array = [];
        private var textFieldStamp:TextField;
        private var bitmapData:BitmapData;
        private var offset:int = 55;

        public function DungeonActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            super.onCreate();

            textFieldStamp = new TextField();
            textFieldStamp.autoSize = TextFieldAutoSize.LEFT;
            textFieldStamp.antiAliasType = AntiAliasType.ADVANCED;
            textFieldStamp.sharpness = 200;
            textFieldStamp.embedFonts = true;
            textFieldStamp.defaultTextFormat = TextFieldFactory.textFormatSmall;
            textFieldStamp.background = false;

            // Draw bottom black box
            var bottomMask:Shape = addChild(new Shape()) as Shape;
            bottomMask.graphics.beginFill(0);
            bottomMask.graphics.drawRect(0,0,fullSizeWidth - HUD_WIDTH, 50);
            bottomMask.graphics.endFill();
            bottomMask.x = HUD_WIDTH;
            bottomMask.y = fullSizeHeight - bottomMask.height;

            scrollerContainer = addChild(new Sprite()) as Sprite;


            offset = 55;


            createScrubber();
            //Generate Bitmap Data
            bitmapScroller = scrollerContainer.addChild(new BitmapScroller(null, "auto", true)) as BitmapScroller;
            bitmapScroller.width = fullSizeHeight - offset;
            bitmapScroller.height = fullSizeWidth;

            bitmapData = generateBitmapSheets();
            bitmapScroller.bitmapDataCollection = [bitmapData];

            createEaseScrollBehavior();

            scrollerContainer.rotation = 90;
            scrollerContainer.x = fullSizeHeight + (HUD_WIDTH - (HUD_PADDING + 10));
            scrollerContainer.y = offset;

            addEventListener(MouseEvent.CLICK, onClick);

            var instructionText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>Pick a Dungeon to explore. Unlock more dungeons by gaining experience.</span>",150)) as TextField

            instructionText.x = (HUD_WIDTH - instructionText.width) * .5;
            instructionText.y = HUD_MESSAGE_Y + 5;

        }

        private function testButtonPress():void
        {
            var x:int = mouseX - HUD_WIDTH;
            var y:int = (mouseY - scrollerContainer.y) + bitmapScroller.scrollX;
            var matrix:Matrix = new Matrix();
            var rect:Rectangle;
            var stamp:BitmapData;

            for (var id:String in instancesRects)
            {
                rect = instancesRects[id];
                //trace("Hit Test", rect.contains(x, y));
                //TODO need to test if the level has been unlocked
                if (rect.contains(x, y) /*&& (activeState.getUnlockedEquipment().indexOf(id) != -1)*/)
                {
                    trace("Hit", id);

                    nextActivity(NewGameActivity, {dungeon:id});

                    return;
                }

            }
        }

        override public function onStart():void
        {
            super.onStart();
            displayContextualButton("BACK");
        }

        override protected function onContextualButtonClick(event:MouseEvent):void
        {
            activityManager.back();
        }

        private function onClick(event:MouseEvent):void
        {
            testButtonPress();
        }

        private function generateBitmapSheets():BitmapData
        {
            //var sprites:Array = SpriteFactory.equipment.slice();

            var i:int = 0;
            var total:int = 9;//sprites.length;
            var padding:int = 20;
            var inventoryWidth:int = BACKGROUND_WIDTH - 20;
            var columns:int = 1;
            var rows:int = Math.ceil(total / columns);
            var cellHeight:int = SpriteSheetFactory.TILE_SIZE + 20;
            // calculate left/right margin for each item
            var leftMargin:int = 0;
            var rightMargin:int = 30;

            var currentPage:BitmapData = new BitmapData(inventoryWidth, ((cellHeight + padding) * rows) + 10, true, 0);
            var currentColumn:int = 0;
            var currentRow:int = 0;
            var foundColorMatrix:ColorTransform = new ColorTransform();
            var unlocked:int = 0;
            var unlockedEquipment:Array = activeState.getUnlockedEquipment();
            var newX:int;
            var newY:int;

            textFieldStamp.textColor = 0xffffff;
            var styles:StyleSheet = new StyleSheet();
            styles.parseCSS(TextFieldFactory.css);
            textFieldStamp.styleSheet = styles;

            var spriteName:String;
            var playerLevel:int = activeState.getPlayerLevel();
            var locked:Boolean;
            var map:RandomMap = new RandomMap();
            var mapShape:Shape = new Shape();
            var renderer:MapDrawingRenderer = new MapDrawingRenderer(mapShape.graphics, new Rectangle(0,0,4,4));

            for (i = 0; i < total; i++)
            {
                currentColumn = i % columns;

                map.generateMap(16,1);
                renderer.renderMap(map);
                trace("map", map);


                spriteName = "M"+(i+1);
                var matrix:Matrix = new Matrix();

                newX = (currentColumn * (SpriteSheetFactory.TILE_SIZE + padding + rightMargin) + leftMargin);
                newY = (currentRow * (SpriteSheetFactory.TILE_SIZE + 20 + padding)) + 5;

                matrix.translate(newX, newY);

                instancesRects[spriteName] = new Rectangle(newX, newY, 200, 40);

                locked = (i > playerLevel);

                // test if item is found
                if (locked)
                {
                    foundColorMatrix.blueOffset =
                    foundColorMatrix.redOffset =
                    foundColorMatrix.greenOffset = -180;
                }
                else
                {
                    foundColorMatrix.blueOffset =
                    foundColorMatrix.redOffset =
                    foundColorMatrix.greenOffset = 0;

                }

                currentPage.draw(mapShape, matrix);

                textFieldStamp.htmlText = "Dungeon "+(i+1)+" "+(!locked ? "Unlocked" : "Locked")+"\n<span class='grey'>Monster: "+TileTypes.getTileName(spriteName)+"s</span>";

                matrix.translate(mapShape.width + 5, 0);
                currentPage.draw(textFieldStamp, matrix, foundColorMatrix);

                matrix.translate(0, textFieldStamp.height+2);
                currentPage.draw(spriteSheet.getSprite(TileTypes.getTileSprite(spriteName)), matrix, foundColorMatrix);

                matrix.translate(SpriteSheetFactory.TILE_SIZE + 5, 0);
                currentPage.draw(spriteSheet.getSprite(TileTypes.getTileSprite("C3")), matrix, foundColorMatrix);

                if (currentColumn == columns - 1)
                {
                    currentRow ++;
                }

            }

            // Rotate the bitmap for the scroller
            var rotatedBMD:BitmapData = new BitmapData(currentPage.height, currentPage.width, true, 0);
            var rotatedMatrix:Matrix = new Matrix();
            rotatedMatrix.rotate(Math.PI * 2 * (-90 / 360));
            rotatedMatrix.translate(0, rotatedBMD.height);
            rotatedBMD.draw(currentPage, rotatedMatrix);

            return rotatedBMD;


        }

        private function createScrubber():void
        {
            var sWidth:int = fullSizeHeight - offset;
            var sHeight:int = 20;
            var dWidth:int = 60;
            var corners:int = 0;

            slider = new Slider(sWidth, sHeight, dWidth, corners, 0);
            slider.y = - 10;

            scrollerContainer.addChild(slider);

        }

        /**
         *
         */
        private function createEaseScrollBehavior():void
        {
            easeScrollBehavior = new EaseScrollBehavior(bitmapScroller, 0);
        }

        override public function update(elapsed:Number = 0):void
        {
            var percent:Number = slider.value / 100;
            var s:Number = bitmapScroller.totalWidth;
            var t:Number = bitmapScroller.width;

            easeScrollBehavior.targetX = percent * (s - t);
            //
            easeScrollBehavior.update();
            //
            bitmapScroller.render();

            super.update(elapsed);
        }

        public function onExit():void
        {
            onBack();
        }

        public function onInventory():void
        {
        }

        public function onPause()
        {
        }
    }
}
