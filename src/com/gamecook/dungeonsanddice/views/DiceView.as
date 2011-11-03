/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 9/25/11
 * Time: 9:04 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.views
{
import com.gamecook.dungeonsanddice.utils.ArrayUtil;
import com.gamecook.frogue.sprites.SpriteSheet;

    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class DiceView extends Sprite
    {
        private var spriteSheet:SpriteSheet;
        private var _selected:Boolean;
        private var _value:int = 0;
        private var diceBitmap:Bitmap;
        private var highlightBitmap:Bitmap;
        private var sides:int;
        private var sideValues:Array = [];

        public function DiceView(spriteSheet:SpriteSheet, sides:int = 6)
        {
            this.sides = sides;
            var i:int;
            for(i = 0; i < this.sides ; i++)
            {
                sideValues.push(i+1);
            }

            this.spriteSheet = spriteSheet;
            diceBitmap = addChild(new Bitmap(new BitmapData(40,40,true,0x0))) as Bitmap;
            highlightBitmap = addChild(new Bitmap(spriteSheet.getSprite(spriteSheet.spriteNames[spriteSheet.spriteNames.length-1]))) as Bitmap;
            reset();
        }

        public function reset():void
        {
            addEventListeners(this);
            _selected = false;
            _value = 0;
            render();
        }

        public function get selected():Boolean
        {
            return _selected;
        }

        public function set selected(value:Boolean):void
        {
            _selected = value;
            render();
        }

        public function get value():int
        {
            return _value;
        }

        public function set value(value:int):void
        {
            _value = value;
            render();
        }

        public function roll() : int {
			sideValues = ArrayUtil.shuffleArray(sideValues);
            value = sideValues[0] != value ? sideValues[0] : sideValues[1];
            return value;
		}

        private function addEventListeners(diceView:DiceView):void
        {
            diceView.addEventListener(MouseEvent.CLICK, onClick);
        }

        private function onClick(event:MouseEvent):void
        {
            if(value == 0)
                return;
            _selected = !_selected;
            render();
        }

        private function removeEventListeners(diceView:DiceView):void
        {
            diceView.removeEventListener(MouseEvent.CLICK, onClick);
        }

        private function render():void
        {
            diceBitmap.bitmapData = spriteSheet.getSprite(spriteSheet.spriteNames[_value]).clone();
            highlightBitmap.visible = _selected;
        }

    }
}
