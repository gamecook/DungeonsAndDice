/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 10/30/11
 * Time: 2:56 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.activities
{
    import com.greensock.TweenLite;
    import com.jessefreeman.factivity.activities.ActivityManager;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.analytics.ITrack;
    import com.jessefreeman.factivity.sounds.ISoundManager;
    import com.jessefreeman.factivity.threads.IThreadManager;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;

    public class SlideActivityManager extends ActivityManager
    {
        private var lastActivity:BaseActivity;
        private var lastActivityBitmap:Bitmap;
        private var currentActivityBitmap:Bitmap;

        public function SlideActivityManager(tracker:ITrack = null, threadManager:IThreadManager = null, soundManager:ISoundManager = null)
        {
            super(tracker, threadManager, soundManager);
        }

        override protected function onSwapActivities(newActivity:BaseActivity):void
        {
            if (currentActivity)
            {
                lastActivityBitmap = _target.addChild(createBitmapSnapshot(currentActivity)) as Bitmap;
                removeActivity();
                TweenLite.to(lastActivityBitmap,1,{y:-BaseActivity.fullSizeHeight, delay: .2,onComplete: removeLastActivityBitmap});
            }

            newActivity.visible = false;
            addActivity(newActivity);

            currentActivityBitmap = _target.addChild(createBitmapSnapshot(currentActivity)) as Bitmap;
            currentActivityBitmap.y = BaseActivity.fullSizeHeight;

            TweenLite.to(currentActivityBitmap,1,{y:0, delay: .2, onComplete: showCurrentActivity});
        }

        protected function removeLastActivityBitmap():void
        {
            _target.removeChild(lastActivityBitmap);

        }

        private function showCurrentActivity():void
        {
            _target.removeChild(currentActivityBitmap);
            currentActivity.visible = true;
        }

        private function createBitmapSnapshot(target:DisplayObject):Bitmap
        {
            var tmpBitmap:Bitmap = new Bitmap(new BitmapData(BaseActivity.fullSizeWidth, BaseActivity.fullSizeHeight, true, 1));
            tmpBitmap.bitmapData.draw(target);
            return tmpBitmap;
        }
    }
}
