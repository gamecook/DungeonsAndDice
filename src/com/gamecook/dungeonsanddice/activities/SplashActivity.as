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
    import com.gamecook.dungeonsanddice.factories.SpriteSheetFactory;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;

    /**
     *
     * This is displayed when the game loads up.
     *
     */
    public class SplashActivity extends BaseActivity
    {

        [Embed(source="../../../../../build/assets/gamecook_presents.png")]
        private var SplashImage:Class;

        public function SplashActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {
            var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
            spriteSheet.clear();
            SpriteSheetFactory.parseSpriteSheet(spriteSheet);

            super.onCreate();
        }

        override public function onStart():void
        {
            super.onStart();

            // Setup the splash image and align it
            var img:Bitmap = addChild(Bitmap(new SplashImage())) as Bitmap;
            img.x = (fullSizeWidth * .5) - (img.width * .5);
            img.y = (fullSizeHeight * .5) - (img.height * .5);

            //TODO For debug set to activity you want to test and comment out StartActivity.
            // Go to the main activity after 3 seconds
            startNextActivityTimer(StartActivity, 3);
            //startNextActivityTimer(DungeonActivity, 0);
            //startNextActivityTimer(GameActivity, 0);
        }
    }
}
