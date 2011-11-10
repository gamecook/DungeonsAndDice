/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/18/11
 * Time: 9:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.views
{
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.states.ActiveGameState;
    import com.gamecook.frogue.sprites.SpriteSheet;

    import flash.display.DisplayObject;

    import flash.display.Sprite;
    import flash.text.TextField;

    public class StatusBarView extends Sprite
    {
        [Embed(source='../../../../../build/assets/fonts/nokiafc22.ttf', fontName="system", embedAsCFF=false, mimeType="application/x-font-truetype")]
        private static var EMBEDDED_FONT:String;
        private var playerLabel:TextField;
        private var _message:TextField;
        private var state:ActiveGameState;
        private var nextLevel:DisplayObject;
        public var inventoryPreview:InventoryPreviewView;
        private var spriteSheet:SpriteSheet;

        public function StatusBarView(state:ActiveGameState)
        {
            this.state = state;
            createDisplay();
        }

        private function createDisplay():void
        {
            //TODO remove Test Data
            state.playerClass = "Player Class";
            state.playerName  = "Player Name";
            //state.playerLevel  = 1;
            state.increasePlayerExperience(100);

            playerLabel = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>"+state.playerName + "</span>  <span class='grey'>"+state.playerClass+"</span>", 150)) as TextField;
            nextLevel = addChild(new NextLevelView(state));
            nextLevel.y = playerLabel.y + playerLabel.height;

            inventoryPreview = addChild(new InventoryPreviewView(state)) as InventoryPreviewView;
            inventoryPreview.y = nextLevel.y + nextLevel.height + 5;

            _message = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "", 150)) as TextField;
            _message.y = 140;
            clearMessage();
        }

        public function setMessage(value:String):void
        {
            _message.htmlText = value;
        }

        public function clearMessage():void
        {
            _message.htmlText = "";
        }

        public function get message():TextField
        {
            return _message;
        }
    }
}
