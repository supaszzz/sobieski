package map;

class DialogBox extends Window {
    private var overworld : Overworld;

    public function new(ov : Overworld) {
        super(129, 8, 21, 8);
        overworld = ov;
        visible = false;
    }
    public function show(text : String, ?endCb: () -> Void, ?breakCb: () -> Void) {
        if (text == "")
            return;
        visible = true;
        overworld.focused = false;
        Text.print(this, text, 8, 8, true, () -> {
            visible = false;
            overworld.focused = true;
            if (endCb != null)
                endCb();
        }, breakCb);
    }
}