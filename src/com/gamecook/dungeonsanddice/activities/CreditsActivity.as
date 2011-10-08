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
    import com.jessefreeman.factivity.activities.IActivityManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;

    public class CreditsActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/credits.png")]
        private var CreditsImage:Class;

        [Embed(source="../../../../../build/assets/sponsors.png")]
        private var SponsorsImage:Class;

        public function CreditsActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            // Setup Credits image and lay it out
            var credits:Bitmap = addChild(Bitmap(new CreditsImage())) as Bitmap;
            credits.x = ((BACKGROUND_WIDTH - credits.width) * .5)+HUD_WIDTH
            credits.y = (fullSizeHeight - credits.height) * .5;

            // Setup Credits image and lay it out
            var sponsors:Bitmap = addChild(Bitmap(new SponsorsImage())) as Bitmap;
            sponsors.x = (HUD_WIDTH - sponsors.width) * .5;
            sponsors.y = HUD_MESSAGE_Y + 5;

            // Enable the logo to go back
            displayContextualButton();

            // create a time delay to show the StartActivity
            startNextActivityTimer(StartActivity, 10);

            // Add click handler to skip the timer and go to start
            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function onClick(event:MouseEvent):void
        {
            // Load the start activity
            nextActivity(StartActivity);
        }
    }
}
