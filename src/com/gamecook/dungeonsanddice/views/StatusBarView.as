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

    import flash.display.Sprite;
    import flash.text.TextField;

    public class StatusBarView extends Sprite
    {
        [Embed(source='../../../../../build/assets/fonts/nokiafc22.ttf', fontName="system", embedAsCFF=false, mimeType="application/x-font-truetype")]
        private static var EMBEDDED_FONT:String;
        private var scoreTF:TextField;
        private var levelTF:TextField;
        //private var turnsTF:TextField;

        private var _message:TextField;

        public function StatusBarView()
        {
            createDisplays();
        }

        private function createDisplays():void
        {
            scoreTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, TextFieldFactory.INVENTORY_LABEL + TextFieldFactory.padScore(), 150)) as TextField;

            /*levelTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, TextFieldFactory.KILL_LABEL + TextFieldFactory.padLevel())) as TextField;
            levelTF.x = scoreTF.x + scoreTF.width;*/

           /* turnsTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, TextFieldFactory.TURNS_LABEL + TextFieldFactory.padLevel())) as TextField;
            turnsTF.x = levelTF.x + levelTF.width;*/

            _message = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "", 150)) as TextField;
            _message.y = 140;
            clear();
        }

        public function updateStats(score:int, kills:int, inventory:int):void
        {
            scoreTF.htmlText = TextFieldFactory.SCORE_LABEL + " " + TextFieldFactory.padScore(score.toString()) +"  "+ TextFieldFactory.KILL_LABEL + " "+ TextFieldFactory.padScore(kills.toString()) + "\n"+ TextFieldFactory.INVENTORY_LABEL.replace("@percent@",inventory.toString() );
        }

        public function setLevel(value:int):void
        {
            //levelTF.htmlText = ;
        }

       /* public function setTurns(value:int):void
        {
            //turnsTF.htmlText = TextFieldFactory.TURNS_LABEL + TextFieldFactory.padLevel(value.toString());
        }*/

        public function setMessage(value:String):void
        {
            _message.htmlText = value;
        }

        public function clear():void
        {
            scoreTF.htmlText = TextFieldFactory.SCORE_LABEL + " " +TextFieldFactory.padScore() + "  " +TextFieldFactory.KILL_LABEL + TextFieldFactory.padLevel();
            //levelTF.htmlText = ;
            //turnsTF.htmlText = TextFieldFactory.TURNS_LABEL + TextFieldFactory.padLevel();
            _message.htmlText = "";
        }

        public function get message():TextField
        {
            return _message;
        }
    }
}
