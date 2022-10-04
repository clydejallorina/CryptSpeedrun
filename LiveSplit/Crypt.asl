state("Crypt") {}

startup
{
    // This script uses asl-help from https://github.com/just-ero/asl-help
    // Huge thanks to Ero and the Speedrun Tool Development Discord for helping me out
    // and for putting up with my stupid questions.
    Assembly.Load(File.ReadAllBytes(@"Components\asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

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
    // TODO: Setup tome collection as a split
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["phase"] = mono.Make<int>("Globals", "phase");
        vars.Helper["isPaused"] = mono.Make<int>("Globals", "isPaused");
        return true;
    });
}

update
{
    current.scene = vars.Helper.Scenes.Active.Name;
}

start {
    return current.scene == "dungeon3";
}

reset {
    return current.scene == "intro_cutscene"; // The intro cutscene is its own separate cutscene. Try Again always leads to this cutscene.
}

split {
    if (current.scene == "win" && current.scene != old.scene) return true;
    if (current.phase == old.phase + 1) return true;
}

isLoading
{
    return current.isPaused; // Stop the timer whenever the game is paused
}
