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
    import flash.geom.Matrix;

    public class SlideActivityManager extends ActivityManager
    {
        private static const leftSideWidth:int = 174;
        private var lastActivity:BaseActivity;
        private var lastActivityBitmap:Array;
        private var currentActivityBitmap:Array;

        public function SlideActivityManager(tracker:ITrack = null, threadManager:IThreadManager = null, soundManager:ISoundManager = null)
        {
            super(tracker, threadManager, soundManager);
        }

        override protected function onSwapActivities(newActivity:BaseActivity):void
        {
            if (currentActivity)
            {
                lastActivityBitmap = createBitmapSnapshot(currentActivity);

                var lastLeftSide:Bitmap = _target.addChild(lastActivityBitmap[0]) as Bitmap;
                var lastRightSide:Bitmap = _target.addChild(lastActivityBitmap[1]) as Bitmap;
                lastRightSide.x = lastLeftSide.x + lastLeftSide.width;

                removeActivity();

                TweenLite.to(lastLeftSide,1,{y:-BaseActivity.fullSizeHeight, delay: .2});
                TweenLite.to(lastRightSide,1,{y:BaseActivity.fullSizeHeight, delay: .2,onComplete: removeLastActivityBitmap});
            }

            newActivity.visible = false;
            addActivity(newActivity);

            currentActivityBitmap = createBitmapSnapshot(currentActivity);

            var currentLeftSide:Bitmap = _target.addChild(currentActivityBitmap[0]) as Bitmap;
            var currentRightSide:Bitmap = _target.addChild(currentActivityBitmap[1]) as Bitmap;
            currentLeftSide.y = BaseActivity.fullSizeHeight;
            currentRightSide.x = currentLeftSide.x + currentLeftSide.width;
            currentRightSide.y = -BaseActivity.fullSizeHeight;

            TweenLite.to(currentLeftSide,1,{y:0, delay: .2});
            TweenLite.to(currentRightSide,1,{y:0, delay: .2, onComplete: showCurrentActivity});
        }

        protected function removeLastActivityBitmap():void
        {
            _target.removeChild(lastActivityBitmap[0]);
            _target.removeChild(lastActivityBitmap[1]);

        }

        private function showCurrentActivity():void
        {
            _target.removeChild(currentActivityBitmap[0]);
            _target.removeChild(currentActivityBitmap[1]);
            currentActivity.visible = true;
        }

        private function createBitmapSnapshot(target:DisplayObject):Array
        {
            var sides:Array = [];
            var tmpBitmapLeft:Bitmap = new Bitmap(new BitmapData(leftSideWidth, BaseActivity.fullSizeHeight, true, 1));
            tmpBitmapLeft.bitmapData.draw(target);
            sides.push(tmpBitmapLeft);

            var tmpBitmapRight:Bitmap = new Bitmap(new BitmapData(BaseActivity.fullSizeWidth - leftSideWidth, BaseActivity.fullSizeHeight, true, 1));
            var matrix:Matrix = new Matrix();
            matrix.translate(-leftSideWidth, 0)
            tmpBitmapRight.bitmapData.draw(target, matrix);
            sides.push(tmpBitmapRight);

            return sides;
        }
    }
}
