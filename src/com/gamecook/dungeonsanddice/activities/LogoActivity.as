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
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.states.ActiveGameState;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.activities.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     *
     * This is the base Activity all of the game Activities should extend from. It has logic for displaying the LOGO
     * and also enabling the logo to be clickable to go back to the home screen.
     *
     */
    public class LogoActivity extends BaseActivity
    {
        public static const HUD_WIDTH:int = 174;
        public static const HUD_PADDING:int = 14;
        public static const HUD_MESSAGE_Y:int = 180;
        public static const BACKGROUND_WIDTH:int = 226;

        [Embed(source="../../../../../build/assets/logo.png")]
        private var LogoImage:Class;

        [Embed(source="../../../../../build/assets/hud_background.png")]
        private var HudBackground:Class;

        protected var logo:Bitmap;
        protected var logoContainer:Sprite;
        protected var activeState:ActiveGameState;
        private var contextualButton:TextField;

        public function LogoActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            // This fills in the Activity's background with a solid color so there is something to click on.
            graphics.beginFill(0xff0000, 0);
            graphics.drawRect(0, 0, fullSizeWidth, fullSizeHeight);
            graphics.endFill();

            addChild(Bitmap(new HudBackground()));
            // Sets up the ActiveGameState object
            activeState = new ActiveGameState();
            activeState.load();



            super.onCreate();
        }

        protected function onContextualButtonClick(event:MouseEvent):void
        {
            trace("Click Contextual Button");
        }

        override public function onStart():void
        {
            super.onStart();

            //TODO remove dependency on Logo Container.
            // Creates a container for the logo
            logoContainer = addChild(new Sprite()) as Sprite;
            logoContainer.visible = false;

            // Attaches the logo
            logo = logoContainer.addChild(Bitmap(new LogoImage())) as Bitmap;
            logo.x = (fullSizeWidth - logo.width) * .5;
            logo.y = 6;

        }

        /**
         *
         * Call this to turn the Logo into a Back Button.
         *
         */
        protected function displayContextualButton(label:String):void
        {
            contextualButton = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, label, 60)) as TextField;
            contextualButton.x = fullSizeWidth - contextualButton.width;
            contextualButton.y = 5;
            contextualButton.addEventListener(MouseEvent.CLICK, onContextualButtonClick);
        }

        /**
         *
         * Called when the logo is clicked and returns to StartActivity.
         *
         * @param event
         */
        protected function onHome(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.CLICK, onHome);
            nextActivity(StartActivity);
        }

        /**
         *
         * Forces the ActiveState object to save when an activity stops.
         *
         */
        override public function onStop():void
        {
            saveState();

            if (logoContainer.hasEventListener(MouseEvent.CLICK))
                logoContainer.removeEventListener(MouseEvent.CLICK, onHome);

            super.onStop();
        }

        override public function saveState():void
        {
            activeState.mute = soundManager.mute;
            activeState.save();
            super.saveState();
        }

        override public function onBack():void
        {
            super.onBack();
            nextActivity(StartActivity);
        }
    }
}
