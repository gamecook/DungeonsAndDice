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
    import com.gamecook.dungeonsanddice.views.InventoryPreviewView;
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
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class InventoryActivity extends LogoActivity implements IMenuOptions
    {
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var bitmapScroller:BitmapScroller;
        private var slider:Slider;
        private var easeScrollBehavior:EaseScrollBehavior;
        private var scrollerContainer:Sprite;
        private var instancesRects:Array = [];
        private var textFieldStamp:TextField;
        private var bitmapData:BitmapData;
        private var coinContainer:Bitmap;
        private var offset:int = 55;
        private var statsTF:TextField;
        private var inventoryPreview:InventoryPreviewView;

        public function InventoryActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            super.onCreate();

            var inventoryText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='grey'>Your Inventory shows all of the equipment that have been found while playing the game.</span>",150)) as TextField

            inventoryText.x = (HUD_WIDTH - inventoryText.width) * .5;
            inventoryText.y = 44;

            textFieldStamp = new TextField();
            textFieldStamp.autoSize = TextFieldAutoSize.LEFT;
            textFieldStamp.antiAliasType = AntiAliasType.ADVANCED;
            textFieldStamp.sharpness = 200;
            textFieldStamp.embedFonts = true;
            textFieldStamp.defaultTextFormat = TextFieldFactory.textFormatSmall;
            textFieldStamp.background = true;
            textFieldStamp.backgroundColor = 0x000000;

            inventoryPreview = addChild(new InventoryPreviewView(activeState)) as InventoryPreviewView;
            inventoryPreview.x = inventoryText.x;
            inventoryPreview.y = inventoryText.y + inventoryText.height + 3;

            createCoinDisplay();

            statsTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, formatStatsText(), 160)) as TextField;
            statsTF.x = coinContainer.x + coinContainer.width + 10;
            statsTF.y = coinContainer.y;

            scrollerContainer = addChild(new Sprite()) as Sprite;

            offset = 65;

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

            var instructionText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>Simply click on any of the equipment to customize your player.</span>",150)) as TextField

            instructionText.x = (HUD_WIDTH - instructionText.width) * .5;
            instructionText.y = HUD_MESSAGE_Y + 5;

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

        private function formatStatsText():String
        {
            var message:String =
                    "<span >Stats:</span>\n"+
                    "<span class='lightGrey'>Wins:</span>\n<span class='green'>" + activeState.totalWins + "</span>\n" +
                    "<span class='lightGrey'>Losses:</span>\n<span class='red'>" + activeState.totalLosses + "</span>\n";
            return message;
        }

        private function updatePlayerDisplay():void
        {
            var sprites:Array = [TileTypes.getTileSprite("@")];

            if (activeState.equippedInventory[SlotsEnum.ARMOR])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.ARMOR]));

            if (activeState.equippedInventory[SlotsEnum.HELMET])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.HELMET]));

            if (activeState.equippedInventory[SlotsEnum.BOOTS])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.BOOTS]));

            if (activeState.equippedInventory[SlotsEnum.SHIELD])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.SHIELD]));

            if (activeState.equippedInventory[SlotsEnum.WEAPON])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.WEAPON]));


            /*playerSprite.bitmapData = spriteSheet.getSprite.apply(this, sprites);*/
        }

        private function createCoinDisplay():void
        {
            coinContainer = addChild(new Bitmap(new BitmapData(110, 65, true, 0))) as Bitmap;
            var bmd:BitmapData = coinContainer.bitmapData;

            var totalMoney:int = 0;


            var sprites:Array = ["C1","C2","C3"];
            var i:int;

            for (i = 0; i < 3; i++)
            {
                var matrix:Matrix = new Matrix();
                //matrix.scale(.5, .5)
                matrix.translate(40 * i, 12);
                coinContainer.bitmapData.draw(spriteSheet.getSprite(TileTypes.getTileSprite(sprites[i])), matrix);

                var total:int = activeState.getCoins()[sprites[i]];
                textFieldStamp.text = total == 0 ? "0" : total.toString();
                matrix = new Matrix();
                matrix.translate(40 * i + ((32 - textFieldStamp.width) * .5), textFieldStamp.height + 30);
                bmd.draw(textFieldStamp, matrix);

                totalMoney += total * (i + 1);
            }
            coinContainer.x = HUD_WIDTH + 10;
            coinContainer.y = 5;

            textFieldStamp.textColor = 0xf1f102;
            textFieldStamp.text = "COINS: $" + totalMoney;
            bmd.draw(textFieldStamp);
        }

        private function onClick(event:MouseEvent):void
        {
            testButtonPress()
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
                if (rect.contains(x, y) && (activeState.getUnlockedEquipment().indexOf(id) != -1))
                {
                    /*trace("Equip", id);
                    textFieldStamp.textColor = 0xff0000;
                    textFieldStamp.text = TileTypes.getTileName(id);

                    //stamp = new BitmapData(textFieldStamp.width, textFieldStamp.height);
                    //stamp.draw(text)
                    matrix.rotate(Math.PI * 2 * (-90 / 360));
                    matrix.translate(Math.round(rect.y + rect.height), Math.round((bitmapData.height - rect.x) - ((SpriteSheetFactory.TILE_SIZE - textFieldStamp.width) * .5)));
                    //matrix.translate(Math.round(,SpriteSheetFactory.TILE_SIZE - bitmapData.  );
                    bitmapData.draw(textFieldStamp, matrix, null, null, null, true);
                    bitmapScroller.invalidate(BitmapScroller.INVALID_VISUALS);*/

                    switch (id.substr(0, 1))
                    {
                        case "W":
                            if (activeState.equippedInventory[SlotsEnum.WEAPON] == id)
                                delete activeState.equippedInventory[SlotsEnum.WEAPON];
                            else
                                activeState.equippedInventory[SlotsEnum.WEAPON] = id;
                            break;
                        case "S":
                            if (activeState.equippedInventory[SlotsEnum.SHIELD] == id)
                                delete activeState.equippedInventory[SlotsEnum.SHIELD];
                            else
                                activeState.equippedInventory[SlotsEnum.SHIELD] = id;
                            break;
                        case "A":
                            if (activeState.equippedInventory[SlotsEnum.ARMOR] == id)
                                delete activeState.equippedInventory[SlotsEnum.ARMOR];
                            else
                                activeState.equippedInventory[SlotsEnum.ARMOR] = id;
                            break;
                        case "B":
                            if (activeState.equippedInventory[SlotsEnum.BOOTS] == id)
                                delete activeState.equippedInventory[SlotsEnum.BOOTS];
                            else
                                activeState.equippedInventory[SlotsEnum.BOOTS] = id;
                            break;
                        case "H":
                            if (activeState.equippedInventory[SlotsEnum.HELMET] == id)
                                delete activeState.equippedInventory[SlotsEnum.HELMET];
                            else
                                activeState.equippedInventory[SlotsEnum.HELMET] = id;
                            break;
                    }

                    updatePlayerDisplay();
                    return;
                }

            }
        }

        private function generateBitmapSheets():BitmapData
        {
            var sprites:Array = SpriteFactory.equipment.slice();
            var tileSize:int = SpriteSheetFactory.TILE_SIZE * 2;
            var i:int = 0;
            var total:int = sprites.length;
            var padding:int = 20;
            var inventoryWidth:int = BACKGROUND_WIDTH - 20;
            var columns:int = 2;
            var rows:int = Math.ceil(total / columns);

            // calculate left/right margin for each item
            var leftMargin:int = 0;
            var rightMargin:int = 30;

            var currentPage:BitmapData = new BitmapData(inventoryWidth, ((tileSize + padding) * rows) + 10, true, 0);
            var currentColumn:int = 0;
            var currentRow:int = 0;
            var foundColorMatrix:ColorTransform = new ColorTransform();
            var unlockedEquipment:Array = activeState.getUnlockedEquipment();
            var newX:int;
            var newY:int;

            textFieldStamp.textColor = 0xffffff;

            for (i = 0; i < total; i++)
            {
                currentColumn = i % columns;

                var matrix:Matrix = new Matrix();

                newX = (currentColumn * (tileSize + padding + rightMargin) + leftMargin);
                newY = (currentRow * (tileSize + padding)) + 5;

                matrix.translate(newX, newY);
                matrix.a = 2;
                matrix.d = 2;

                instancesRects[sprites[i]] = new Rectangle(newX, newY, tileSize, tileSize);

                // test if item is found
                if (unlockedEquipment.indexOf(sprites[i]) == -1)
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

                currentPage.draw(spriteSheet.getSprite(TileTypes.getEquipmentPreview(sprites[i])), matrix, foundColorMatrix);

                textFieldStamp.text = TileTypes.getTileName(sprites[i]);
                matrix.translate(Math.round((tileSize - textFieldStamp.width) * .5), tileSize);
                matrix.a = 1;
                matrix.d = 1;
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
            var sWidth:int = fullSizeHeight - offset;
            var sHeight:int = 20;
            var dWidth:int = 60;
            var corners:int = 0;

            slider = new Slider(sWidth, sHeight, dWidth, corners, 0);
            slider.y = - 10;

            slider.addEventListener(Event.CHANGE, onSliderValueChange)
            scrollerContainer.addChild(slider);

        }

        private function onSliderValueChange(event:Event):void
        {
            //trace("Slider Changed", slider.value);
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
