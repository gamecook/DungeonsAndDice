/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 10/17/11
 * Time: 9:20 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.views
{
    import com.gamecook.dungeonsanddice.factories.SpriteFactory;
    import com.gamecook.dungeonsanddice.factories.SpriteSheetFactory;
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.states.ActiveGameState;
    import com.gamecook.frogue.enum.SlotsEnum;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;

    import flash.display.BitmapData;

    import flash.display.Shape;

    import flash.display.Sprite;
    import flash.text.TextField;

    public class InventoryPreviewView extends Sprite
    {
        private var state:ActiveGameState;
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);

        private var inventoryLabel:TextField;
        private var weaponBox:Sprite;
        private var armorBox:Sprite;
        private var potionBox:Sprite;

        public function InventoryPreviewView(state:ActiveGameState)
        {
            this.state = state;
            createDisplay();
        }

        private function createDisplay():void
        {
            //Need to make sure the level is padded by a space so it always is aligned with right side of level bar

            inventoryLabel = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>Inventory ("+calculateUnlockPercent()+"% discovered)</span>", 150)) as TextField;

            /*if (activeState.equippedInventory[SlotsEnum.ARMOR])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.ARMOR]));

            if (activeState.equippedInventory[SlotsEnum.HELMET])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.HELMET]));

            if (activeState.equippedInventory[SlotsEnum.BOOTS])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.BOOTS]));

            if (activeState.equippedInventory[SlotsEnum.SHIELD])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.SHIELD]));

            if (activeState.equippedInventory[SlotsEnum.WEAPON])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.WEAPON]));*/

            renderPreviews();
        }

        private function renderPreviews():void
        {

            var tmpSprite:BitmapData =  null;

            // Weapon
            if (state.equippedInventory[SlotsEnum.WEAPON])
                tmpSprite = spriteSheet.getSprite(TileTypes.getTileSprite(state.equippedInventory[SlotsEnum.WEAPON]));

            weaponBox = addChild(drawInventoryBox(tmpSprite, 0xe2a5a5, "<span class='grey'>A:</span> +99")) as Sprite;

            // Armor
            armorBox = addChild(drawInventoryBox(null, 0x85acbb, "<span class='grey'>D:</span> +99")) as Sprite;
            armorBox.x = weaponBox.x + weaponBox.width + 15;

            // Potions
            potionBox = addChild(drawInventoryBox(spriteSheet.getSprite(TileTypes.getTileSprite("P")), 0x8ad695, "<span class='grey'>P:</span> x99")) as Sprite;
            potionBox.x = armorBox.x + armorBox.width + 15;
        }

        private function drawInventoryBox(sprite:BitmapData, backgroundColor:uint, label:String):Sprite
        {
            var maxWidth:int = 36;
            var maxHeight:int = 36;
            var border:int = 2;

            var box:Sprite = addChild(new Sprite()) as Sprite;
            box.x = border;
            box.y = inventoryLabel.y + inventoryLabel.height + 2
            box.graphics.lineStyle(2,0xffffff);
            box.graphics.beginFill(backgroundColor);

            //TODO do we need to offset these by the border?
            box.graphics.drawRect(0,0,maxWidth,maxHeight);
            box.graphics.endFill();

            if(sprite)
            {
                var bitmap:Bitmap = box.addChild(new Bitmap(sprite)) as Bitmap;
                bitmap.x = (box.width - sprite.width) * .5;
                bitmap.y = (box.height - sprite.height) * .5;
            }

            var tf:TextField = box.addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall,label,box.width)) as TextField;
            tf.x = -border;
            tf.y = box.height;

            return box;
        }

        private function calculateUnlockPercent():Number
        {
            var sprites:Array = SpriteFactory.equipment.slice();
            var i:int = 0;
            var total:int = sprites.length;
            var unlockedPercent:Number = 0;
            var unlocked:int = 0;
            var unlockedEquipment:Array = state.getUnlockedEquipment();

            for (i = 0; i < total; i++)
            {
                if (unlockedEquipment.indexOf(sprites[i]) != -1)
                {
                    unlocked ++;
                }

            }

            unlockedPercent = Math.round(unlocked / total * 100);
            return unlockedPercent;


        }
    }
}
