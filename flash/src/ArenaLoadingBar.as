package {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

public class ArenaLoadingBar extends Sprite {


    private var _isLoaded:Boolean;

    private var _loadingBar:MovieClip;

    private var _digitalVec:Vector.<MovieClip>;

    private var _infoHolder:MovieClip;

    private var _animation:MovieClip;

    private var _leftFighterNameTxt:TextField;

    private var _leftLevelTxt:TextField;

    private var _leftIconHolder:MovieClip;

    private var _rightFighterNameTxt:TextField;

    private var _rightLevelTxt:TextField;

    private var _rightIconHolder:MovieClip;

    private var _lHolder:MovieClip;

    private var _leftSubIconHolder:MovieClip;

    private var _rHolder:MovieClip;

    private var _rightSubIconHolder:MovieClip;

    public function ArenaLoadingBar(loadingBar:MovieClip) {
        super();
        this._loadingBar = loadingBar;
        this.initialize();
    }

    private function initialize():void {
        this._isLoaded = false;
        this.createChildren();
        this.addAnimationEventListener();
    }

    private function createChildren():void {
        this._animation = this._loadingBar["animation"];
        this._infoHolder = this._loadingBar["fighterInfoHolder"];
        this._infoHolder.visible = false;
        this._digitalVec = Vector.<MovieClip>([this._loadingBar["digital0"], this._loadingBar["digital1"], this._loadingBar["digital2"]]);
        this._leftFighterNameTxt = this._infoHolder["leftNameTxt"];
        this._rightFighterNameTxt = this._infoHolder["rightNameTxt"];
        this._leftLevelTxt = this._infoHolder["leftLevelTxt"];
        this._rightLevelTxt = this._infoHolder["rightLevelTxt"];
        this._leftIconHolder = this._infoHolder["leftIconHolder"];
        this._rightSubIconHolder = this._infoHolder["rightSubIconHolder"];
        this._rightIconHolder = this._infoHolder["rightIconHolder"];
        this._leftSubIconHolder = this._infoHolder["leftSubIconHolder"];
        this._rightIconHolder.scaleX = -1;
        this._rightSubIconHolder.scaleX = -1;
        this._lHolder = this._infoHolder["lHolder"];
        this._rHolder = this._infoHolder["rHolder"];
        addChild(this._loadingBar);
        this.updateDigitalVec(this._digitalVec, 0);
        this._lHolder.visible = false;
        this._rHolder.visible = false;
    }

    private function addAnimationEventListener():void {
        this._animation.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(param1:Event):void {
        if (this._animation.currentFrame == this._animation.totalFrames) {
            this._animation.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            dispatchEvent(new Event(Event.CLOSE));
        } else if (this._animation.currentFrame == 40) {
            this._infoHolder.visible = true;
        }
    }

    private function updateDigitalVec(param1:Vector.<MovieClip>, param2:int):void {
        var _loc7_:MovieClip = null;
        var _loc3_:int = int(param1.length);
        var _loc4_:Vector.<int>;
        var _loc5_:int = int((_loc4_ = parseNumberToDigitVec(param2)).length - 1);
        var _loc6_:int = _loc3_ - 1;
        while (_loc6_ >= 0) {
            (_loc7_ = param1[_loc6_]).gotoAndStop(1);
            _loc7_.visible = false;
            if (_loc5_ >= 0) {
                _loc7_.gotoAndStop(_loc4_[_loc5_] + 1);
                _loc7_.visible = true;
                _loc5_--;
            }
            _loc6_--;
        }
    }

    public static function parseNumberToDigitVec(param1:int):Vector.<int> {
        var _loc4_:int = 0;
        var _loc2_:Vector.<int> = new Vector.<int>();
        var _loc3_:int = 0;
        if (param1 > 0) {
            while (param1 > 0) {
                _loc4_ = param1 % 10;
                _loc2_.push(_loc4_);
                param1 /= 10;
                _loc3_++;
            }
        } else if (param1 == 0) {
            _loc2_.push(0);
        }
        return _loc2_.reverse();
    }

    public function updateProgress(param1:int):void {
        this.updateDigitalVec(this._digitalVec, param1);
        if (param1 == 100 && !this._isLoaded) {
            this._isLoaded = true;
            this._animation.gotoAndPlay("vanish");
            this._infoHolder.visible = false;
        }
    }
}
}
