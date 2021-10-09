# Flash Toy Sync V3

Flash toy sync is being developed to make existing flash games able to control different kind of sex toys. For stroker toys, it does that by syncing the toy's movements, to the movements in the animations.

&nbsp;

## Download

You will be able to download a build of the project [here](https://github.com/notSafeForDev/flash-toy-sync-v3/releases).

&nbsp;

## Supported Toys

- None ([theHandy](https://www.thehandy.com/) will be implemented first)

&nbsp;

## Development

Flash Toy Sync requires [Node.js](https://nodejs.org/) in order to run the script which transpiles some of the Actionscript 3.0 (AS3) code to 2.0 (AS2). You can use either the Current or LTS version.

If you're on windows, you can run the transpile.bat found in the root of the project.
You can also run the node script directly by opening command prompt/terminal, navigating to the root and run:
```sh
node transpile
```

Features are developed for the AS3 version, then transpiled to work in the AS2 version. Both versions are needed as the AS3 version can only run flash games written in AS3, same with AS2.

The only AS3 code that isn't transpiled, are from the core library and Main. The core library takes care of providing classes and functions that can be used in identical ways both in AS3 and AS2. However, there's a consideration to remove some parts of it and take care of more of the differences as part of the transpiler. That way there will be less duplicate code.

When it comes to writting and debugging the code and compiling the project, [FlashDevelop](https://www.flashdevelop.org/) is recommended as it was made specifically for flash development.
For VSCode there is the [Actionscript & MXML](https://github.com/BowlerHatLLC/vscode-as3mxml) extension. (I haven't used it as I wasn't able to get it to work.)

... I will add more instructions later.


&nbsp;

## Troubleshooting

### FlashDevelop

<details>
  <summary>It closes as soon as you open the program:</summary>
  Try opening a different script file.
</details>

<details>
  <summary>When attempting to test the project, it gives you an error: Exception: The process cannot access the file ... because it is being used by another process:</summary>
  End the flash player process through the task manager (windows).
</details>

<details>
  <summary>The flash player process doesn't appear in the task manager:</summary>
  Click the stop button near the test button.
</details>

&nbsp;

## License

MIT
