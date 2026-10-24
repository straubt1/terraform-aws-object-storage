# terraform-aws-object-storage

Terraform module for AWS S3 object storage.

Versions are authored on `main` in [`versions/`](versions/). Each `versions/vX.Y.Z/` folder is one module version, and the files in that folder are the module root.

Publish from `main` with [Task](https://taskfile.dev/):

```bash
task publish
```

`task publish` rebuilds the published history in version order. It deletes the published branches and tags, locally and on `origin`, then creates them again. `main` stays as it is.

Starting with the lowest `versions/vX.Y.Z/` folder, it creates that branch with the module files at the repository root, commits (`release: publish module <name>`), and adds a matching annotated tag. Each later version is committed on top of the previous version, so the branches share one lineage. Every other folder in `versions/`, such as `latest-rename`, then becomes a branch based on the highest version. Those branches are not tagged.

Published refs are branches named `vX.Y.Z` or `latest*`, branches named for a current `versions/` folder, and tags named `vX.Y.Z`. Other branches are left in place.
