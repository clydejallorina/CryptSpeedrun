using BepInEx;
using HarmonyLib;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

namespace CryptSpeedrun
{
    [BepInPlugin(PluginInfo.PLUGIN_GUID, PluginInfo.PLUGIN_NAME, PluginInfo.PLUGIN_VERSION)]
    [BepInProcess("Crypt.exe")]
    public class Plugin : BaseUnityPlugin
    {
        private void Awake()
        {
            Harmony.CreateAndPatchAll(typeof(StopwatchHUD)); // Patch stopwatch to game
            Logger.LogInfo($"{PluginInfo.PLUGIN_NAME} [{PluginInfo.PLUGIN_VERSION}] loaded!");
        }

        private void OnDestroy()
        {
            Harmony.UnpatchAll();
        }

        public static class StopwatchHUD
        {
            private static float time = 0.0f; // Time taken in seconds
            private static bool isStarted = false;
            private static TextMeshProUGUI stopwatchText = null;
            private static BepInEx.Logging.ManualLogSource LogSource = BepInEx.Logging.Logger.CreateLogSource("StopwatchHUD");

            [HarmonyPatch(typeof(OpenSpawn), "OpenDoor")]
            [HarmonyPostfix]
            public static void Postfix()
            {
                LogSource.LogInfo("Door opened!");
                isStarted = true;
            }

            [HarmonyPatch(typeof(Movement), "FixedUpdate")]
            [HarmonyPostfix]
            public static void UpdatePostfix()
            {
                if (!isStarted || stopwatchText == null) return;
                if (!Globals.isPaused) time += Time.fixedDeltaTime;
                int minutes = (int)time / 60;
                int seconds = (int)time % 60;
                int milliseconds = (int)(time * 1000) % 1000;
                stopwatchText.text = $"{minutes:d02}:{seconds:d02}.{milliseconds:d03}";
            }

            [HarmonyPatch(typeof(UIManager), "Awake")]
            [HarmonyPostfix]
            public static void AddStopwatch(UIManager __instance)
            {
                LogSource.LogInfo("Attempting to add new text to canvas...");
                // Generate stopwatch text object
                Canvas canvas = __instance.stamina_obj.GetComponentInParent<Canvas>();
                TMP_FontAsset font = __instance.opts.GetComponentInChildren<TextMeshProUGUI>().font; // Get font from Pause menu text
                GameObject textGO;
                TextMeshProUGUI text;
                textGO = new GameObject("Stopwatch");
                textGO.transform.parent = canvas.transform;
                textGO.layer = 5;

                text = textGO.AddComponent<TextMeshProUGUI>();
                text.text = "Not started yet.";
                text.fontSize = 55;
                text.font = font;
                text.color = Color.white;

                // Set stopwatch text position
                RectTransform rt = text.GetComponent<RectTransform>();
                rt.localPosition = new Vector3(0, 488.5f, 0);
                rt.sizeDelta = new Vector2(1920.0f, 1079.42f);
                rt.offsetMin = new Vector2(-960.0f, -539.71f);
                rt.offsetMax = new Vector2(960.0f, 539.71f);
                rt.position = new Vector3(960, 540, 0);

                stopwatchText = text;

                LogSource.LogInfo("New text object successfully created!");
            }

            [HarmonyPatch(typeof(ExitDoor), "OnTriggerEnter")]
            [HarmonyPrefix]
            public static void WinPrefix()
            {
                isStarted = false; // kill the timer, we've won
            }

            [HarmonyPatch(typeof(DeadWinUI), "PlayAgainPress")]
            [HarmonyPostfix]
            public static void ResetPostfix() {
                // DeadWin: reset everything once playagain is pressed
                isStarted = false;
                time = 0.0f;
            }

            [HarmonyPatch(typeof(MainUI), "Start")]
            [HarmonyPostfix]
            public static void DenoteInVersion(MainUI __instance)
            {
                GameObject version = __instance.mainmenu.transform.GetChild(4).gameObject; // Version is the 5th child in the MainMenu object
                GameObject title = __instance.mainmenu.transform.GetChild(0).gameObject; // Title is the 1st child in the MainMenu object
                TextMeshProUGUI versionText = version.GetComponent<TextMeshProUGUI>();
                TextMeshProUGUI titleText = title.GetComponent<TextMeshProUGUI>();
                versionText.text += "*"; // Append * to the version number to indicate mod hook
            }
        }
    }
}
