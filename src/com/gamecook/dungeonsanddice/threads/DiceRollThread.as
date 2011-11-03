/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 10/31/11
 * Time: 9:18 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.dungeonsanddice.threads {
import com.jessefreeman.factivity.threads.Thread;

public class DiceRollThread extends Thread
{
    private var collection:Array;
    private var totalRolls:int;
    private var delay:int;
    private var counter:int = 0;
    private var rolls:int = 0;


    public function DiceRollThread(delay:int, totalRolls:int, updateCallback:Function = null, finishCallback:Function = null) {

        super(updateCallback, finishCallback);

        this.collection = collection;
        this.totalRolls = totalRolls;
        this.delay = delay;
    }


    override public function start():void {

        counter = 0;
        rolls = 0;
        super.start();

    }

    override public function run(elapsed:Number = 0):void
    {
        counter += elapsed;
        if (counter > delay)
        {
            rolls ++;
            super.run(elapsed);
            counter = 0;
        }
        if(rolls > totalRolls)
        {
            finish();
        }
    }

    override public function toString():String
        {
            return "DiceRoll" + super.toString();
        }
}
}
