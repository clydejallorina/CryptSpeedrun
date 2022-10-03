state("Crypt") {}

startup
{
    vars.Log = (Action<object>)((output) => print("[CryptSplit] " + output));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true;

    // Timing method reminder from Amnesia TDD autosplitter
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var timingMessage = MessageBox.Show(
            "This game uses in-game time as the main timing method.\n" +
            "LiveSplit is currently set to use Real Time.\n" +
            "Would you like the timing method to be set to game time for you?",
            "CryptSplit",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.Log("Detected Crypt.exe running...");
    // TODO: Setup tome collection as a split
    vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper => {
        var globals = helper.GetClass("Assembly-CSharp", "Globals");
        vars.Unity.Make<int>(globals.Static, globals["phase"]).Name = "phase";
        return true;
    });

    vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;

    vars.Unity.Update();

    current.scene = vars.Unity.Scenes.Active.Name;
    current.phase = vars.Unity["phase"].Current;
}

start {
    return current.scene == "dungeon3";
}

reset {
    return current.scene == "intro_cutscene"; // The intro cutscene is its own separate cutscene. Try Again always leads to this cutscene.
}

split {
    if (current.phase == null) current.phase = old.phase;
    if (current.scene == null) current.scene = old.scene;

    if (current.scene == "win" && current.scene != old.scene) return true;
    if (current.phase == old.phase + 1) return true;
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
