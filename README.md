# Flash Toy Sync V3

Flash toy sync is being developed to make existing flash games able to control different kind of sex toys. For stroker toys, it does that by syncing the toy's movements, to the movements in the animations.

It has a built in scripting editor, designed to make the process as quick as possible. The main tool for scripting are the base, stimulation and tip markers, which you can attach to different parts of the animation, then as the animation plays, it calculates the stroke depth based on how close the stimulation marker is to the base and tip marker.

There will be more information about how scripting works later.

&nbsp;

## Download

You will be able to download a build of the project [here](https://github.com/notSafeForDev/flash-toy-sync-v3/releases).

&nbsp;

## Currently Supported Toys

- [theHandy](https://www.thehandy.com/)

&nbsp;

## Development Overview

Two versions are being developed in parallel, the Actionscript 3.0 (AS3) version, and the Actionscript 2.0 (AS2). Actionscript is the programming language that is used for creating flash games, and either version can only run flash games written in the corresponding language. In order to keep feature parety and avoid rewriting the entire application twice, a core library have been made which provides the same functionality in both AS2 and AS3. A transpiler from AS3 to AS2 have also been made to make the porting process a lot less timeconsuming.

It requires [Node.js](https://nodejs.org/) in order to run the transpiler. You can use either the Current or LTS version.

If you're on windows, you can run the transpile.bat found in the root of the project.
You can also run the node script directly by opening command prompt/terminal, navigating to the root and run:
```sh
node transpile
```

When it comes to writting and debugging the code and compiling the project, [FlashDevelop](https://www.flashdevelop.org/) is recommended as it was made specifically for flash development.
For VSCode there is the [Actionscript & MXML](https://github.com/BowlerHatLLC/vscode-as3mxml) extension. (I haven't used it as I wasn't able to get it to work.)

... I will add more instructions later. Probably as wiki pages.


&nbsp;

## Troubleshooting

### FlashDevelop

<details>
  <summary>It closes as soon as you open the program:</summary>
  Try opening a different script file through the folder.
</details>

<details>
  <summary>When attempting to test the project, it gives you an error: Exception: The process cannot access the file ... because it is being used by another process:</summary>
  This usually happens if you get an exception before the flash player opens.
  To fix it, end the flash player process through the task manager (windows) or activity monitor (mac).
</details>

<details>
  <summary>The flash player process doesn't appear in the task manager:</summary>
  Click the stop button near the test button.
</details>

<details>
  <summary>Logs doesn't appear in the output panel:</summary>
  Make sure that you have changed it from Release to Debug mode, at the top.
</details>

&nbsp;

## License

MIT
