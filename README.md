# portable-workstation

## RoadMap

- Automatically create shortcuts
- Download binaries and unpackage them automatically
- Automatically look for applications and stuff under path - add them automatically

### Todo
- Stop using For-Eachobject in favor of foreach
- Fix some variable names that should be more specific

## Schema for portable.config.json

will have actual good documentation later

```json
{
  "config": {
    "name": "Edwin Kofler", // doesn't do anything yet
    "relativePathToBinary": "../_binary",
    "relativePathToCmderConfig": "../cmder/config",
    "relativePathToApplications": "../",
    "applications": [
      {
        "name": "Cmder",
        "path": "cmder/Cmder"
      },
      {
        "name": "QuickLook",
        "path": "quicklook/QuickLook",
        "launch": "auto" // optional. Launch keywords include auto, prompt, and autoForce. "prompt" is default. autoForce launches the app even if it already exists
      }
    ],
    "paths": [
      {
        "name": "cmake", // optional. Just for better logging in output
        "path": "cmake/bin"
      }
    ],
    "variables": [
      {
        "name": "six",
        "value": "6"
      },
      {
        "name": "seven",
        "value": "7"
      }
    ],
    "aliases": [
      {
        "name": "gs",
        "value": "git status"
      }
    ]
  }
}
```
