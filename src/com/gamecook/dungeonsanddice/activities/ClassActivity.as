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
import com.gamecook.dungeonsanddice.views.DiceView;
import com.gamecook.frogue.enum.SlotsEnum;
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

    public class ClassActivity extends LogoActivity implements IMenuOptions
    {
        [Embed(source="../../../../../build/assets/dice_spritesheet.png")]
        private var DiceSpriteSheet:Class;

        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var bitmapScroller:BitmapScroller;
        private var slider:Slider;
        private var easeScrollBehavior:EaseScrollBehavior;
        private var scrollerContainer:Sprite;
        private var instancesRects:Array = [];
        private var textFieldStamp:TextField;
        private var bitmapData:BitmapData;
        private var offset:int = 55;
        private var classText:Array = [
        {name: "Knight", description: "Roll 2 or more sixes. Immediately take 1 point of life from the monster."},
        {name: "Mage", description: "Roll 3 or more threes. Restore health to full amount."},
        {name: "Thief", description: "Win with a two pair. Roll a single dice after combat. Add the value to the player’s score."},
        {name: "Ranger", description: "Attack with high card. Take 1 point of life from monster regardless of attacker’s hand."},
        {name: "Barbarian", description: "Roll five of a kind. Multiply attack value by 2."}];
        private var diceSpriteSheet:SpriteSheet;
        private var playerDiceContainer:Sprite;
        private var playerDiceInstances:Array = [];

        public function ClassActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            super.onCreate();

            createDiceSpriteSheet();
            displayContextualButton("BACK");

            textFieldStamp = new TextField();
            textFieldStamp.autoSize = TextFieldAutoSize.LEFT;
            textFieldStamp.antiAliasType = AntiAliasType.ADVANCED;
            textFieldStamp.sharpness = 200;
            textFieldStamp.embedFonts = true;
            textFieldStamp.defaultTextFormat = TextFieldFactory.textFormatSmall;
            textFieldStamp.background = false;
            textFieldStamp.backgroundColor = 0x000000;
            textFieldStamp.multiline = true;
            textFieldStamp.wordWrap = true;
            textFieldStamp.width = 150;

            scrollerContainer = addChild(new Sprite()) as Sprite;


            offset = 55;

            createScrubber();
            //Generate Bitmap Data
            bitmapScroller = scrollerContainer.addChild(new BitmapScroller(null, "auto", true)) as BitmapScroller;
            bitmapScroller.width = fullSizeHeight - offset - 43;
            bitmapScroller.height = fullSizeWidth;

            bitmapData = generateBitmapSheets();
            bitmapScroller.bitmapDataCollection = [bitmapData];

            createEaseScrollBehavior();

            scrollerContainer.rotation = 90;
            scrollerContainer.x = fullSizeHeight + (HUD_WIDTH - (HUD_PADDING + 10));
            scrollerContainer.y = offset;

            addEventListener(MouseEvent.CLICK, onClick);

            var descriptionText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='grey'>Time to create a new character. Assign a dice value to your character’s <span class='white'>Attack</span>, <span class='white'>Defense</span> and <span class='white'>Life</span> values.</span>",150)) as TextField
            descriptionText.x = HUD_PADDING;
            descriptionText.y = 48;

            var instructionText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>Click on the property above, then the dice you want to assign it to.</span>",150)) as TextField

            instructionText.x = (HUD_WIDTH - instructionText.width) * .5;
            instructionText.y = HUD_MESSAGE_Y + 5;

            createPlayerDice();

        }

        private function createDiceSpriteSheet():void
        {
            diceSpriteSheet = new SpriteSheet();
            var tileSize:int = 40;
            var bitmap:Bitmap = new DiceSpriteSheet();
            diceSpriteSheet.bitmapData = bitmap.bitmapData;
            var i:int;
            var total:int = Math.floor(bitmap.width / tileSize);
            var spriteRect:Rectangle = new Rectangle(0, 0, tileSize, tileSize);
            for (i = 0; i < total; ++i)
            {
                spriteRect.x = i * tileSize;
                diceSpriteSheet.registerSprite("sprite" + i, spriteRect.clone());
            }
        }

        private function createPlayerDice():void
        {
            playerDiceContainer = addChild(new Sprite()) as Sprite;
            createDiceGroup(playerDiceContainer, playerDiceInstances);
            playerDiceContainer.x = ((BACKGROUND_WIDTH - playerDiceContainer.width) * .5) + HUD_WIDTH;
            playerDiceContainer.y =fullSizeHeight - playerDiceContainer.height - 2;
        }

        private function createDiceGroup(container:Sprite, instanceCollection:Array):void
        {
            var total:int = 5;
            var i:int;
            var dice:DiceView;
            var padding:int = 4;
            for (i = 0; i < total; i++)
            {
                dice = container.addChild(new DiceView(diceSpriteSheet)) as DiceView;
                dice.x = (dice.width+padding) * i;
                dice.roll();
                instanceCollection.push(dice);
            }
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
                trace("Hit Test", rect.contains(x, y), rect);
                //TODO need to test if the level has been unlocked
                if (rect.contains(x, y) /*&& (activeState.getUnlockedEquipment().indexOf(id) != -1)*/)
                {
                    trace("Select Class", id);

                    nextActivity(DungeonActivity, {classID:id});

                    return;
                }

            }
        }

        override public function onStart():void
        {
            super.onStart();

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
            var total:int = classText.length;
            var padding:int = 20;
            var inventoryWidth:int = BACKGROUND_WIDTH - 20;
            var columns:int = 1;
            var rows:int = Math.ceil(total / columns);

            // calculate left/right margin for each item
            var leftMargin:int = 0;
            var rightMargin:int = 30;

            var currentPage:BitmapData = new BitmapData(inventoryWidth, ((SpriteSheetFactory.TILE_SIZE + padding) * rows) + 10, true, 0);
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
            var classObject:Object;

            for (i = 0; i < total; i++)
            {
                currentColumn = i % columns;
                classObject = classText[i];
                spriteName = "@";//+(i+1);
                var matrix:Matrix = new Matrix();

                newX = (currentColumn * (SpriteSheetFactory.TILE_SIZE + padding + rightMargin) + leftMargin);
                newY = (currentRow * (SpriteSheetFactory.TILE_SIZE + padding)) + 5;

                matrix.translate(newX, newY);

                instancesRects[i] = new Rectangle(newX, newY, 200, 40);

                // test if item is found
                /*if (unlockedEquipment.indexOf(sprites[i]) == -1)
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
                    unlocked ++;
                }*/


                currentPage.draw(spriteSheet.getSprite(TileTypes.getTileSprite(spriteName)), matrix, foundColorMatrix);

                textFieldStamp.htmlText = classObject.name+" - <span class='grey'>"+classObject.description+"</span>";

                matrix.translate(SpriteSheetFactory.TILE_SIZE + 5, 0);
                currentPage.draw(textFieldStamp, matrix, foundColorMatrix);

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
            var sWidth:int = fullSizeHeight - offset - 43;
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
