# terraform-aws-object-storage

Terraform module for AWS S3 object storage.

Versions are authored on `main` in [`versions/`](versions/). Each `versions/vX.Y.Z/` folder is one module version, and the files in that folder are the module root.

Publish from `main` with [Task](https://taskfile.dev/):

```bash
task publish
task publish -- v1.0.0
task publish -- latest
```

`task publish` copies each `versions/<name>/` folder onto a branch of the same name, with those files at the repository root. It commits when the files changed (`release: publish module <name>`) and force-pushes the branch to `origin`. A folder named `vX.Y.Z` also gets a matching annotated tag, moved to that commit and force-pushed with the branch. Other folder names, such as `latest`, are branches only. Passing one folder name publishes only that folder.
