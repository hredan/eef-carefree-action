# eef-carefree-action
This action will take the last release assets of [ESPEASYFLASHER_2.0](https://github.com/hredan/ESPEASYFLASHER_2.0) and will add eep packages, custom logo and a custom EEF config, if available. The eep packages have to created with the [eep-build-action](https://github.com/hredan/eep-build-action) befor. This artefacts will be downloaded and added to the EEF packages.

# Input of action
| Name               | Type        | Required | Description                                                                                                         |
|--------------------|-------------|----------|---------------------------------------------------------------------------------------------------------------------|
| `target-os`        | String      | true     | Shall one of the following targets: all or win64/linux_x64/linux_arm64/linux_armv7/macos_intel/macos_arm64          |
