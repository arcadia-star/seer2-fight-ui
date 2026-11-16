package animation.hub {
import data.pet.SkillData;
import flash.display.MovieClip;

internal interface ISkillButton {
    function get view():MovieClip;
    function skill():SkillData;
}
}
