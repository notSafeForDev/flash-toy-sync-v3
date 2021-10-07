/**
 * This script has to be run before the ActionScript 2.0 version can be compiled
 * 
 * It copies directories and files from flash-toy-sync-as3 to flash-toy-sync-as2
 * Then transpiles the Actionscript 3.0 code into 2.0
 * 
 * Note: It won't necessarily work for any other Actionscript 3.0 file, as it is only written based on the code that should be transpiled
 */

// https://stackoverflow.com/a/26038979

var fs = require('fs');
var path = require('path');

function copyFileSync(source, target) {

    var targetFile = target;

    // If target is a directory, a new file with the same name will be created
    if (fs.existsSync(target)) {
        if (fs.lstatSync(target).isDirectory()) {
            targetFile = path.join(target, path.basename(source));
        }
    }

    fs.writeFileSync(targetFile, fs.readFileSync(source));
}

function copyFolderRecursiveSync(source, target, ignoreFolders = [], ignoreFiles = []) {
    var files = [];

    // Check if folder needs to be created or integrated
    // var targetFolder = path.join( target, path.basename( source ) );
    /* var targetFolder = path.join(target); // EDIT
    if (!fs.existsSync(targetFolder)) {
        fs.mkdirSync(targetFolder);
    } */

    if (!fs.existsSync(target)) {
        fs.mkdirSync(target);
    }

    // Copy
    if (fs.lstatSync(source).isDirectory()) {
        files = fs.readdirSync(source);
        files.forEach(file => {
            var curSource = path.join(source, file);
            var curTarget = curSource.replace(source, target); // NEW, In order to keep the folder structure the same

            if (ignoreFolders.includes(curSource) === true || ignoreFiles.includes(curSource) === true) {
                return;
            }

            if (fs.lstatSync(curSource).isDirectory()) {
                console.log("Copied directory: " + curSource + ", to: " + curTarget);
                // copyFolderRecursiveSync(curSource, targetFolder); // ORIGINAL
                copyFolderRecursiveSync(curSource, curTarget); // NEW
            } else {
                console.log("Copied file: " + curSource + ", to: " + curTarget);
                // copyFileSync(curSource, targetFolder); // ORIGINAL
                copyFileSync(curSource, curTarget); // NEW
            }
        });
    }
}

function findActionScriptLineIndex(lines, words) {
    return lines.findIndex(line => {
        const commentIndex = line.indexOf("//");

        const wordIndexes = words.map(word => {
            return line.indexOf(word);
        });

        const lowestWordIndex = Math.min(...wordIndexes);
        const highestWordIndex = Math.max(...wordIndexes);

        if (lowestWordIndex < 0) {
            return false;
        }

        for (let i = 0; i < wordIndexes.length; i++) {
            if (i > 0 && wordIndexes[i - 1] > wordIndexes[i]) {
                return false;
            }
        }

        if (commentIndex >= 0 && commentIndex < highestWordIndex) {
            return false;
        }

        return true;
    });
}

function findActionScriptLineIndexes(lines, words) {
    const indexes = [];
    for (let i = 0; i < lines.length; i++) {
        const index = i + findActionScriptLineIndex(lines.slice(i), words);
        if (index >= i) {
            indexes.push(index);
            i = index;
        } else {
            break;
        }
    }
    return indexes;
}

function removeActionScriptLines(lines, words) {
    while (findActionScriptLineIndex(lines, words) >= 0) {
        const index = findActionScriptLineIndex(lines, words);
        lines.splice(index, 1);
    }
}

function replaceInActionScriptLines(lines, words, find, replace) {
    const indexes = findActionScriptLineIndexes(lines, words);
    for (let i of indexes) {
        lines[i] = lines[i].split(find).join(replace);
    }
}

function getStringBetween(string, leftPart, rightPart) {
    return string.substring(string.indexOf(leftPart) + leftPart.length, string.indexOf(rightPart));
}

function transpileActionScript3To2(actionscript) {
    const warnings = [];

    let lines = actionscript.split("\r\n");

    let packageLineIndex = findActionScriptLineIndex(lines, ["package ", "{"]);

    if (packageLineIndex < 0) {
        return actionscript;
    }

    packageLineIndex = findActionScriptLineIndex(lines, ["package ", "{"]);
    const packageLine = lines[packageLineIndex];
    const packageName = getStringBetween(packageLine, "package", "{").trim();

    // Import everything from the base package, incase something else from it is being used, as AS3 doesn't require import for that
    if (packageName !== "") {
        const packageNameStart = packageName.split(".")[0];
        lines.unshift("");
        lines.unshift("import " + packageNameStart + ".*");
    }

    // Add transpiler info
    lines.unshift("");
    lines.unshift(" */");
    lines.unshift(" * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again");
    lines.unshift("/**");

    let emptyLinesAfterPackage = 0;
    for (let i = packageLineIndex + 1; i < lines.length; i++) {
        if (lines[i].trim() === "") {
            emptyLinesAfterPackage++;
        } else {
            break;
        }
    }

    // Remove package line and any empty lines after
    removeActionScriptLines(lines, ["package ", "{"]);

    // Remove 1 indentation from each line
    for (let i = 0; i < lines.length; i++) {
        lines[i] = lines[i].replace("\t", "");
    }

    // Remove last closing curly bracket
    const closingBracketIndexes = findActionScriptLineIndexes(lines, ["}"]);
    const lastClosingBracketIndex = closingBracketIndexes[closingBracketIndexes.length - 1];
    lines.splice(lastClosingBracketIndex, 1);

    // Replace imports
    replaceInActionScriptLines(lines, ["flash.ui.Keyboard;"], "flash.ui.Keyboard;", "core.Keyboard;");

    // Remove standard imports
    removeActionScriptLines(lines, ["import flash.display"]);

    const classLineIndex = findActionScriptLineIndex(lines, ["public class"]);
    const className = getStringBetween(lines[classLineIndex], "class ", " {");
    const constructorLineIndex = lines.findIndex(line => line.includes("function " + className + "("));

    // Check for new Instance declarations above the constructor
    const newInstanceDeclarationIndexes = findActionScriptLineIndexes(lines, ["var ", " = new "]);

    for (let i = 0; i < newInstanceDeclarationIndexes.length; i++) {
        if (newInstanceDeclarationIndexes[i] < constructorLineIndex) {
            warnings.push("Warning: new Instance declaration above the constructor, in " + className);
        }
    }

    // Transpile class line
    const classLineParts = lines[classLineIndex].split("public class ");
    if (packageName !== "") {
        classLineParts.splice(1, 0, "class " + packageName + ".");
    } else {
        classLineParts.splice(1, 0, "class ");
    }
    lines[classLineIndex] = classLineParts.join("");

    // Remove : void
    lines = lines.map(line => {
        return line.split(" : void ").join(" : Void ");
    });

    // Repace : DisplayObjectContainer with : MovieClip
    replaceInActionScriptLines(lines, [" : DisplayObjectContainer"], " : DisplayObjectContainer", " : MovieClip");

    // Repace : DisplayObject with : MovieClip
    replaceInActionScriptLines(lines, [" : DisplayObject"], " : DisplayObject", " : MovieClip");

    // Remove : * (any type declaration)
    replaceInActionScriptLines(lines, ["(", " : *", ")"], " : *", "");

    if (warnings.length > 0) {
        console.log(warnings.join("\n"));
    }

    return lines.join("\r\n");
}

function transpileActionScriptFiles(target, ignoreFolders = [], ignoreFiles = []) {
    if (fs.lstatSync(target).isDirectory() === false) {
        throw new Error("Unable to transpile actionscript, the target directory: " + target + " doesn't exist");
    }

    files = fs.readdirSync(target);
    files.forEach(file => {
        const filePath = path.join(target, file);
        if (fs.lstatSync(filePath).isDirectory() === true && ignoreFolders.includes(filePath) === false) {
            transpileActionScriptFiles(filePath);
        } else if (filePath.includes(".as") === true && ignoreFiles.includes(filePath) === false) {
            fs.readFile(filePath, "utf-8", (err, data) => {
                console.log("Transpiling: " + filePath);
                const transpiled = transpileActionScript3To2(data);
                fs.writeFile(filePath, transpiled, "utf-8", (err) => {
                    if (err) {
                        throw err
                    }
                });
            });
        }
    });
}

console.log("--------------------------------------------------------------------------------");
copyFolderRecursiveSync("flash-toy-sync-as3\\src", "flash-toy-sync-as2\\src", ["flash-toy-sync-as3\\src\\core"], ["flash-toy-sync-as3\\src\\Main.as"]);
transpileActionScriptFiles("flash-toy-sync-as2\\src", ["flash-toy-sync-as2\\src\\core"], ["flash-toy-sync-as2\\src\\Main.as"]);
console.log("--------------------------------------------------------------------------------");