package;

class PlayerStats {
    public static var hp = 20;

    public static var maxHP = 20;
    public static var maxEP = 50;
    public static var def = 0;
    public static var atk = 2;

    public static var level = 1;
    public static var exp = 0;

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