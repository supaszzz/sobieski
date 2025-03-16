package;

class PlayerStats {
    public static var hp : Int;

    public static var maxHP : Int;
    public static var maxEP : Int;
    public static var def : Int;
    public static var atk : Int;

    public static var level : Int;
    public static var exp : Int;

    public static function defaultStats() {
        hp = 20;
        maxHP = 20;
        maxEP = 50;
        def = 0;
        atk = 2;
        level = 1;
        exp = 0;
    }

    public static function updateLevel() : String {
        var newLevel = Math.floor(50*Math.pow(1.3, level));
        if (exp > newLevel) {
            level++;
            hp += 5;
            maxHP += 5;
            maxEP += 10;
            def += 4;
            atk += 4;
            exp -= newLevel;
            var res = '\nAwansowales na $level poziom!%cMaksymalne HP wzroslo o 5.\nMaksymalne EP wzroslo o 10.\nAtak wzrosl o 4.\nObrona wzrosla o 4.';
            if (level % 2 == 0) {
                return '$res%cOdblokowales nowy ULT - "${Strings.ultName[Math.floor(level / 2)]}"!!!';
            }
            return res;
        }
        return "";
    }
}