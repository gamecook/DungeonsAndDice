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


        override protected function onCreate():void {
            super.onCreate();

            //TODO need to update player stats and save out state.
            var youWin:Bitmap = addChild(Bitmap(new YouWinImage())) as Bitmap;
            youWin.x = ((BACKGROUND_WIDTH - youWin.width) * .5) + HUD_WIDTH;
            youWin.y = 50;

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
            treasureTF.y = treasureChest.y + treasureChest.height - 10;

            bonusTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, formatBonusText(), 250)) as TextField;
            bonusTF.x = HUD_PADDING-2;
            bonusTF.y = 45;

            scoreTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, "<span class='white'>Score: </span> <span class='green'>" +TextFieldFactory.padScore(), 160)) as TextField;
            scoreTF.x = ((BACKGROUND_WIDTH - scoreTF.width) * .5) + HUD_WIDTH;
            scoreTF.y = treasureTF.y + treasureTF.height + 20;

            activeState.score = generateNewScore();
            activeState.increasePlayerExperience(activeState.getPlayerLevel() * 5);

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

            continueLabel = addChild(Bitmap(new ContinueImage())) as Bitmap;
            continueLabel.visible;
            continueLabel.x = ((BACKGROUND_WIDTH - continueLabel.width) * .5) + HUD_WIDTH;
            continueLabel.y = fullSizeHeight - (continueLabel.height + 10);

            countUpEffect = new CountUpTextEffect(scoreTF, null, onCountUpComplete);
            countUpEffect.resetValues(activeState.score, activeState.initialScore, 1, scoreTF.text);
            addThread(countUpEffect);

            var instructionText:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='white'>The Hero has defeated the Monster.</span>",150)) as TextField
            instructionText.x = (HUD_WIDTH - instructionText.width) * .5;
            instructionText.y = HUD_MESSAGE_Y + 5;
        }

        override public function onStart():void
        {
            super.onStart();

            activeState.increaseTotalWins();


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
            //TODO Need a new way to calculate score.
            var score:int = 0;
            score += activeState.playerLife;
            score += activeState.levelTurns;
            score *= activeState.dungeonLevel;

            return score + activeState.score;
        }

        private function formatBonusText():String
        {
            var message:String = "Success Bonus\n" +
                    "<span class='lightGrey'>Life:</span> <span class='orange'>+" + activeState.playerLife + "</span>\n" +
                    "<span class='lightGrey'>Turns:</span> <span class='orange'>+" + activeState.levelTurns + "</span>\n" +
                    "<span class='lightGrey'>EXP:</span> <span class='orange'>+" + activeState.getPlayerLevel() * 5 + "</span>";

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
                activeState.dungeonLevel ++;
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
