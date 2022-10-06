state("Crypt") {}

startup
{
    // This script uses asl-help from https://github.com/just-ero/asl-help
    // Huge thanks to Ero and the Speedrun Tool Development Discord for helping me out
    // and for putting up with my stupid questions.
    Assembly.Load(File.ReadAllBytes(@"Components\asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Crypt";
    vars.Helper.LoadSceneManager = true;

    settings.Add("splitOnPhase", true, "Split on Key Pickups");

    vars.Helper.AlertGameTime();
}

init
{
    // TODO: Setup tome collection as a split
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["phase"] = mono.Make<int>("Globals", "phase");
        vars.Helper["isPaused"] = mono.Make<bool>("Globals", "isPaused");
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
    if ((current.scene == "win") && (current.scene != old.scene)) return true;
    if (settings["splitOnPhase"] && (current.phase == old.phase + 1)) return true;
}

isLoading
{
    return current.isPaused; // Stop the timer whenever the game is paused
}
