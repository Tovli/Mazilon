## This is a guide for installing flutter for new devs.
## This assumes thatyou're using Visual Studio Code.

## Required apps (Windows) for developing on VS Code:
- [Android Studio] (https://developer.android.com/studio)
- [Visual Studio Community] (https://visualstudio.microsoft.com/vs/community)
- [Visual Studio Code] (https://code.visualstudio.com)
- [Google Chrome] (https://www.google.com/chrome)
- [Flutter - VS Code Plugin] (https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Git for Windows] (https://git-scm.com/downloads/win)

## Optional - might be required for some installations
- [Gradle for Java - VS Code Plugin] (https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle)
- [Github Desktop - allows UI for Github] (https://github.com/apps/desktop)

## Flutter for VS Code notes
This plugin will require you to choose a folder to download the Flutter SDK into, it's recommended to use C:/ where the flutter folder will be installed.

## Android Studio SDK tools installation
1. Open AS
2. a welcome screen requiring you to open a new project will come up
3. create new project
4. Click on the hamburger menu on the far left of the window, or press "ALT + \" and choose "File > Settings".
- Alternatively press "CTRL + ALT + s" on the keyboard.
5. On the settings window, click "Languages & Frameworks > Android SDK". Then press "SDK Tools".
6. Under SDK Tools choose:
- Android SDK Build Tools
- Android SDK Command-Line Tools
- Android SDK Platform Tools
- Android Emulator
- Android Emulator hypervisor driver
7. Press OK and go through the SDK Tools installation process.

## Android Studio virtual device setup
This is assuming that Android Studio is still open after the prior section.
1. Click on the hamburger menu on the far left of the window, or press "ALT + \" and choose "Tools > Device Manager"
2. The device manager menu should come up on the far right of the app. Hover over the plus icon that says "add a new device" and click.
3. click on the new window's search bar and type in "pixel 6a". Click on the pixel 6a device, then click next.
4. Click on the "Tiramisu" system image, alternatively click on the download icon near it if it's not installed.
- Tiramisu specs - API: 33, Target: Android 13.
5. Click next until you're able to click finish.

## Setting up the Matzilon project on VS Code
1. run VS Code. If it's already running then exit and turn on the app again.
2. Press on the upper menu "View > Source Control" or press keyboard shortcut "CTRL + SHIFT + g".
3. if git is properly installed the left hand "source control" section will allow you to press "Clone Repository". Click it.
4. Fill in "https://github.com/Tovli/Mazilon.git" in the text section that will pop up.
5. Choose the folder to install the repo. Ideally in Documents.
6. Go to Terminal in VS Code and type in "flutter doctor" for diagnostics on what is installed.
It should say:
[√] Flutter (Channel stable, num.num.num, on Microsoft Windows [Version num.num.num.num], locale)
[√] Windows Version (Installed version of Windows is version 10 or higher)
[√] Android toolchain - develop for Android devices (Android SDK version num.num.num)
[√] Chrome - develop for the web
[√] Visual Studio - develop Windows apps (Visual Studio Community)
[√] Android Studio (version num.num)
[√] VS Code (version num.num.num)
[√] Connected device (num available)
[√] Network resources

- anything that includes an X should be addressed, the solution is also provided there
