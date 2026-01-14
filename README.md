# dockercleanup

A collection of small, safe shell scripts intended to help maintain Docker hosts
by pruning unused images, caches, volumes, and trimming large container logs.

This repository is designed to be used standalone on a Docker host or invoked
from a CI job (for example, a Jenkins pipeline) on a schedule.

## Contents

- `scripts/docker-clean-logs.sh` — truncate large container logs and remove rotated
  JSON logs older than 30 days.
- `scripts/docker-prune-cache.sh` — prune BuildKit/buildx cache or classic builder
  cache with sensible defaults and before/after disk-usage reporting.
- `scripts/docker-prune-images.sh` — run container/image/volume/network/system
  prune commands to free disk space.

## Requirements

- A Linux Docker host with administrative privileges to run the scripts.
- `docker` CLI installed. `docker buildx` is optional but supported when present.

Tested with Jenkins 2.516.2 and Docker CE 24.x, but scripts are portable and
should work with other similar versions.

## Usage (manual)

Run a script directly on the Docker host as root or with equivalent permissions:

```bash
bash scripts/docker-clean-logs.sh
bash scripts/docker-prune-cache.sh
bash scripts/docker-prune-images.sh
```

Each script prints simple progress information and attempts to be safe by
reporting disk usage before and after major operations.

## Jenkins integration

Create a pipeline job that checks out this repo and runs the desired script(s).
This repository includes a `Jenkinsfile` at the repository root which demonstrates
pipeline usage and can be used as a starting point.
Example minimal scripted pipeline stage:

```groovy
stage('Docker cleanup') {
  steps {
    sh 'bash scripts/docker-prune-cache.sh'
    sh 'bash scripts/docker-prune-images.sh'
    sh 'bash scripts/docker-clean-logs.sh'
  }
}
```

Schedule the job according to your policy (daily/weekly/monthly). Review the
commands and adjust retention/size thresholds to match your environment.

### Using Jenkinsfile


- Create a copy of this repository so you can configure your own parameters
- Create a jenkins pipeline job and reference your repository via SCM checkout with git
- Trigger the build
- The default configuration is to schedule the job monthly

## Safety notes & customization

- Inspect each script before running in production. Adjust retention and size
  values (for example, the `find`/`-mtime` and `-size` thresholds) as needed.
- Consider running in a staging environment first to ensure no critical images
  or caches are removed unintentionally.

## Contributing

Issues and pull requests are welcome. Keep changes small and document any
behavioral changes in the PR description.


To contribute:

1. Fork this repository
2. Create a new branch:
  ```bash
  git checkout -b feature/your-feature-name
  git commit -m "Add your message here"
  git push origin feature/your-feature-name
  ```
3. Open a Pull Request

## License

This project is licensed under the MIT License.


## Authors

- **Michael Moscovitch** – Primary Developer  
  GitHub: @cimichaelm

Additional contributors are listed in the project's commit history.
