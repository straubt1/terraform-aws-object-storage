# terraform-aws-object-storage

Terraform module for AWS S3 object storage.

Versions are authored on `main` in [`versions/`](versions/). Each `versions/vX.Y.Z/` folder is one module version, and the files in that folder are the module root.

Publish from `main` with [Task](https://taskfile.dev/):

```bash
task publish
task publish -- v1.0.0
task publish -- latest
```

`task publish` copies each `versions/vX.Y.Z/` folder onto a branch of the same name, with those files at the repository root. It commits when the files changed (`release: publish module vX.Y.Z`), moves the annotated tag `vX.Y.Z` to that commit, and force-pushes the branch and the tag to `origin`.

It does the same for `versions/latest/`, onto a branch named `latest`, and force-pushes that branch without creating a tag. A full publish includes `latest`. Passing one version publishes only that version.
