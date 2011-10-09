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

package com.gamecook.dungeonsanddice.activities
{
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.sounds.MHSoundClasses;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.threads.effects.CountUpTextEffect;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import uk.co.soulwire.display.PaperSprite;

    /**
     *
     * Shown when the player wins and is ready to move onto the next level.
     *
     */
    public class WinActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/you_win.png")]
        private var YouWinImage:Class;

        [Embed(source="../../../../../build/assets/click_to_continue.png")]
        private var ContinueImage:Class;

        private var scoreTF:TextField;
        private var bonusTF:TextField;
        private var treasureChest:PaperSprite;
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var treasureTF:TextField;
        private var equipmentMessage:String;
        private var countUpEffect:CountUpTextEffect;
        private var continueLabel:Bitmap;

        public function WinActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            activeState.increaseTotalWins();

            //TODO need to update player stats and save out state.
            var youWin:Bitmap = addChild(Bitmap(new YouWinImage())) as Bitmap;
            youWin.x = ((BACKGROUND_WIDTH - youWin.width) * .5) + HUD_WIDTH;
            youWin.y = 0;

            treasureChest = addChild(new PaperSprite()) as PaperSprite;
            treasureChest.x = ((BACKGROUND_WIDTH - treasureChest.width) * .5) + HUD_WIDTH;
            treasureChest.y = youWin.y + youWin.height + 50;
            treasureChest.front = new Bitmap(spriteSheet.getSprite(TileTypes.getTileSprite("T")));

            if (data.droppedEquipment)
            {
                var tileID:String = data.droppedEquipment.tileID;
                treasureChest.back = new Bitmap(spriteSheet.getSprite(TileTypes.getEquipmentPreview(tileID)));
                equipmentMessage = "<span class='green'>You found a " + data.droppedEquipment.description+"</span";

                activeState.unlockEquipment(tileID);
            }
            else
            {
                var coinID:String = getCoin();
                if (coinID)
                {
                    treasureChest.back = new Bitmap(spriteSheet.getSprite(TileTypes.getTileSprite(coinID)));
                    equipmentMessage = "<span class='yellow'>You got a " + TileTypes.getTileName(coinID)+"</span>";
                    activeState.addCoin(coinID);
                }
                else
                {
                    equipmentMessage = "<span class='grey'>The treasure chest was empty.</span>";
                }
            }

            treasureTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmallCenter, "You have discovered a treasure chest.", 200)) as TextField;
            treasureTF.x = ((BACKGROUND_WIDTH - treasureTF.width) * .5) + HUD_WIDTH;
            treasureTF.y = treasureChest.y + treasureChest.height - 20;

            bonusTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, formatBonusText(), 160)) as TextField;
            bonusTF.x = ((BACKGROUND_WIDTH - bonusTF.width) * .5) + HUD_WIDTH;
            bonusTF.y = treasureTF.y + treasureTF.height + 10;

            scoreTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, "SCORE\n<span class='green'>" +TextFieldFactory.padScore(), 160)) as TextField;
            //scoreTF.textColor = 0x33ff00;
            scoreTF.x = ((BACKGROUND_WIDTH - scoreTF.width) * .5) + HUD_WIDTH;
            scoreTF.y = bonusTF.y + bonusTF.height + 10;

            activeState.score = generateNewScore();

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

            continueLabel = addChild(Bitmap(new ContinueImage())) as Bitmap;
            continueLabel.visible;
            continueLabel.x = ((BACKGROUND_WIDTH - continueLabel.width) * .5) + HUD_WIDTH;
            continueLabel.y = fullSizeHeight - (continueLabel.height + 10);

            countUpEffect = new CountUpTextEffect(scoreTF, null, onCountUpComplete);
            countUpEffect.resetValues(activeState.score, activeState.initialScore, 1, scoreTF.text);
            addThread(countUpEffect);

        }

        private function getCoin():String
        {
            if (activeState.levelTurns == 5)
                return "C3"
            else if (activeState.levelTurns == 6)
                return "C2"
            else if (activeState.levelTurns == 7)
                return "C1";

            return "";
        }

        private function onCountUpComplete():void
        {
            treasureChest.flip();
            treasureTF.htmlText = equipmentMessage;
            continueLabel.visible = true;
        }

        private function generateNewScore():int
        {
            var score:int = 0;

            score += activeState.playerLife;
            score += activeState.levelTurns;
            score *= activeState.playerLevel;

            return score + activeState.score;
        }

        private function formatBonusText():String
        {
            var message:String = "SUCCESS BONUS\n" +
                    "<span class='lightGrey'>Life:</span> <span class='orange'>+" + activeState.playerLife + "</span>\n" +
                    "<span class='lightGrey'>Turns:</span> <span class='orange'>+" + activeState.levelTurns + "</span>\n" +
                    "<span class='lightGrey'>Level:</span> <span class='orange'>x" + activeState.playerLevel + "</span>";

            return message;
        }

        private function onClick(event:MouseEvent):void
        {
            if (countUpEffect.isRunning())
            {
                threadManager.removeThread(countUpEffect);
                countUpEffect.forceStop();
                continueLabel.visible = true;
            }
            else
            {
                activeState.playerLevel ++;
                soundManager.destroySounds(true);
                soundManager.play(MHSoundClasses.WalkStairsSound);
                nextActivity(GameActivity);
            }
        }

        /**
         * We are loading, there is nothing to go back to.
         */
        override public function onBack():void
        {

        }
    }
}
