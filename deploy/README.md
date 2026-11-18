# API docs deployment

The API docs are a static [Scalar](https://github.com/scalar/scalar) page built from
[MorphoSource-REST-API.yaml](../MorphoSource-REST-API.yaml), served by the MorphoSource
nginx at `/api/docs/`. Deployment follows the
[morphosource-documentation](https://gitlab.oit.duke.edu/morphosource/morphosource-documentation)
repo.

## Local preview

```sh
sh scripts/build-docs.sh
python3 -m http.server 8000 --bind 127.0.0.1 -d build
```

Then open http://localhost:8000/. "Try it" will not reach the live API from
localhost (www.morphosource.org sends no CORS headers); it works once deployed,
since the docs and the API share an origin.

## How it deploys

[.gitlab-ci.yml](../.gitlab-ci.yml), on commits to the default branch:

1. `build_image` runs [scripts/build-docs.sh](../scripts/build-docs.sh) inside the
   [Dockerfile](../Dockerfile) and pushes `$CI_REGISTRY_IMAGE/api-docs:<sha>`. The
   build downloads Scalar from the npm registry and checks it against a pinned
   SHA-512, so the site serves its own copy and never loads code from a CDN. It
   fails if the checksum doesn't match or any site file is missing or empty, so
   nothing deploys.
2. `deploy_dev` and `deploy_prod` each run a one-shot Job
   ([publish-job.yaml](publish-job.yaml)) that mounts the `nginx-public` volume,
   copies the site to `api-docs/releases/<sha>/`, atomically repoints
   `api-docs/current` at it and keeps the newest three releases. Both run
   automatically.

Rollback: re-run an earlier pipeline's deploy job, or point `api-docs/current` at an
older directory under `api-docs/releases/`.

## One-time setup

- **GitLab project.** This repo lives on GitHub; GitLab CI needs a GitLab project
  that mirrors it (pull mirroring), with its container registry enabled.
- **CI/CD variables:** `K8S_URL_DEV`, `K8S_TOKEN_DEV`, `K8S_NAMESPACE_DEV`,
  `K8S_URL_PROD`, `K8S_TOKEN_PROD`, `K8S_NAMESPACE_PROD` (same values as the
  documentation repo). Mark them protected and masked, and protect the default
  branch, so only default-branch pipelines can read them.
- **Registry pull access.** The `gitlab-container-registry` pull secret in each
  namespace must be able to read this project's registry.
- **nginx.** Add the locations in [nginx-api-docs.conf](nginx-api-docs.conf) to the
  nginx config in the helm-chart repo (`charts/hyrax/values.dev.yaml` and
  `values.prod.yaml`) and deploy. Until then the files are published but not served.

## Upgrading Scalar

Change `SCALAR_VERSION` and `SCALAR_SHA512` in
[scripts/build-docs.sh](../scripts/build-docs.sh); the script's header shows how to
get the hash. Check the release notes for new features that call Scalar's hosted
services, and disable them in [docs/scalar-init.js](../docs/scalar-init.js).
