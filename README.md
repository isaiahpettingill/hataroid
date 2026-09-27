# Hataroid Android fork

Hataroid is an Android Atari ST emulator based on Hatari. This fork builds a
64-bit APK for current Android devices. The bundled [EmuTOS](https://emutos.sourceforge.io/)
ROM is selected by default; you may select another TOS ROM in Settings. EmuTOS
is GPLv2-licensed and is already included in the upstream assets.

On Android 13 and newer, insert floppy through the system file picker. Hataroid
imports a private copy of the disk image; changes to that disk stay in the copy.

GitHub Actions builds on every pull request, master push, and monthly check.
A signed APK is attached to each successful [release](https://github.com/isaiahpettingill/hataroid/releases).
The signing key is stored in private repository Actions secrets and should be
backed up locally so later releases can update earlier installations.

To set up signing from Windows Git Bash with GitHub CLI authenticated:

```bash
setup_dir="$(mktemp -d)" && gh repo clone isaiahpettingill/hataroid "$setup_dir/hataroid" && bash "$setup_dir/hataroid/scripts/setup-signing.sh"
```

To build locally, install JDK 17, Android SDK platform 36 and NDK 27.2.12479018,
then run `gradle :Hataroid:assembleDebug -PandroidCompileSdk=36` with Gradle 8.9.

Hataroid and its bundled Hatari core are GPLv2-licensed; see `gpl.txt` and
`Projects/Hataroid/src/main/jni/hatari/gpl.txt`.
