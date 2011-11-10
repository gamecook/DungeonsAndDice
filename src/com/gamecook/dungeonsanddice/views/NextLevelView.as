/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 10/17/11
 * Time: 9:20 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.views
{
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.states.ActiveGameState;

    import flash.display.Shape;

    import flash.display.Sprite;
    import flash.text.TextField;

    public class NextLevelView extends Sprite
    {
        private var state:ActiveGameState;
        private var label:TextField;
        private var levelBar:Shape;

        public function NextLevelView(state:ActiveGameState)
        {
            this.state = state;
            createDisplay();
        }

        private function createDisplay():void
        {
            //Need to make sure the level is padded by a space so it always is aligned with right side of level bar
            label = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, "<span class='grey'>Next Level</span>               <span class='grey'>Level</span><span class='white'> "+state.getPlayerLevel()+"</span>", 150)) as TextField;

            var levelDifference:int = state.calculateExperiencePoints(state.getPlayerLevel()+1) - state.calculateExperiencePoints(state.getPlayerLevel());
            var currentLevelEXP:int = state.getPlayerExperience() - state.calculateExperiencePoints(state.getPlayerLevel());
            var percent:Number = currentLevelEXP/levelDifference;
            var maxWidth:int = 133;
            var maxHeight:int = 10;
            var border:int = 2;

            levelBar = addChild(new Shape()) as Shape;
            levelBar.x = border;
            levelBar.y = label.y + label.height + 4
            levelBar.graphics.lineStyle(2,0x999999);
            levelBar.graphics.beginFill(0x0)
            levelBar.graphics.drawRect(0,0,maxWidth,maxHeight);

            levelBar.graphics.lineStyle(0,0,0);
            levelBar.graphics.beginFill(0xcccccc);
            levelBar.graphics.drawRect(border*.5,border*.5,(maxWidth-(border)) * percent, maxHeight- border);
            levelBar.graphics.endFill();

        }
    }
}
