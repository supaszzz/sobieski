package;

class Strings {
    public static var ultUse = [
        "Leci mocny strzal!",
        "Zarybienie w toku...",
        "Husaria nadciaga!",
        "Uderzasz we wroga cala sila Sobieskiego!"
    ];

    public static var ultName = [
        "Lewy sierpowy",
        "Dzikie zarybienie",
        "Szarza husarii",
        "Bitwa pod Wiedniem"
    ];

    public static function getUlt() {
        return ultUse[Math.floor(Math.min(ultUse.length - 1, PlayerStats.level / 2))];
    }

    public static function getAttackText(a : String, name : String) {
        var teksty = ['$name dostal$a lomot!\n', '$name oberwal$a!\n', 'Atakujesz $name!\n'];

        return teksty[Math.floor(Math.random()*teksty.length)];
    }
}