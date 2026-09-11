# GCC 3.4.2 Gentoo 2005 Docker Image

This repository builds a Docker image containing Gentoo's `gcc-3.4.2-r2` in a Gentoo 2005.0 x86 userland.

The target compiler identity is:

```text
gcc (GCC) 3.4.2  (Gentoo Linux 3.4.2-r2, ssp-3.4.1-1, pie-8.7.6.5)
```

The image is intended for source-reconstruction work that needs the compiler and binutils generation matching that banner. It is used only to compile and link; it is not a general-purpose Gentoo runtime.

## Published Image

GitHub Actions builds and publishes:

```text
ghcr.io/philpem/gcc-3.4.2-gentoo2005-docker:latest
```

For consumers, pin by digest once the first image is published:

```sh
docker pull --platform linux/386 ghcr.io/philpem/gcc-3.4.2-gentoo2005-docker@sha256:...
```

## Inputs

Binary inputs are stored with Git LFS under `inputs/` and verified by MD5 before every build. The MD5s are historical provenance checks from the recovered Gentoo digest or the stage3 sidecar; they are not cryptographic trust in modern terms.

### Stage3

| file | MD5 | provenance |
|---|---|---|
| `stage3-x86-2005.0.tar.bz2` | `4ea12f4ae446c72164c28aa0b836453e` | Extracted from `https://archive.org/download/GentooLinux2005MinimalInstallLiveCD/Gentoo_Linux_2005_Minimal_Install_Live_CD.iso`, which is labelled “Minimal Install Live CD” but carries the 2005.0 x86 stage tarballs. The ISO member is `STAGES/STAGE3_X86_2005_0_TAR.BZ2`; the CD's own sidecar is `STAGES/STAGE3_X86_2005_0_TAR_BZ2.MD5` and matches this hash. |

The build imports this tarball as the local Docker base image `gentoo-2005.0-stage3:x86`.

The extracted tarball size is `88,982,705` bytes.

To reproduce the extraction from the ISO with `7z`:

```sh
iso=Gentoo_Linux_2005_Minimal_Install_Live_CD.iso
url=https://archive.org/download/GentooLinux2005MinimalInstallLiveCD/$iso
curl -L -o "$iso" "$url"

7z e -so "$iso" STAGES/STAGE3_X86_2005_0_TAR.BZ2 \
  > inputs/stage3/stage3-x86-2005.0.tar.bz2
7z e -so "$iso" STAGES/STAGE3_X86_2005_0_TAR_BZ2.MD5 \
  > inputs/stage3/stage3-x86-2005.0.tar.bz2.MD5

(cd inputs/stage3 && md5sum -c stage3-x86-2005.0.tar.bz2.MD5)
```

### GCC Distfiles

The original URLs are reconstructed from Gentoo's `gcc-3.4.2-r2.ebuild` and matching `toolchain.eclass` at Gentoo CVS conversion commit `789964eafd96`.

| file | MD5 | original URL | recovered URL |
|---|---|---|---|
| `gcc-3.4.2.tar.bz2` | `2fada3a3effd2fd791df09df1f1534b3` | `ftp://gcc.gnu.org/pub/gcc/releases/gcc-3.4.2/gcc-3.4.2.tar.bz2` | `https://gcc.gnu.org/pub/gcc/releases/gcc-3.4.2/gcc-3.4.2.tar.bz2`, `http://bloodnoc.org/~roy/olde-distfiles/gcc-3.4.2.tar.bz2` |
| `protector-3.4.1-1.tar.gz` | `ccb950ac035c057bbc766426756072d2` | `http://www.research.ibm.com/trl/projects/security/ssp/gcc3_4_1/protector-3.4.1-1.tar.gz` | `https://grok.org.uk/tools/ssp/protector-3.4.1-1.tar.gz`, `http://bloodnoc.org/~roy/olde-distfiles/protector-3.4.1-1.tar.gz`, `https://www.jabawok.net/gentoo/distfiles/protector-3.4.1-1.tar.gz` |
| `gcc-3.4.2-patches-1.1.tar.bz2` | `1d077ca6b3119eecade935829b399f82` | `http://dev.gentoo.org/~lv/GCC/gcc-3.4.2-patches-1.1.tar.bz2` | `http://bloodnoc.org/~roy/olde-distfiles/gcc-3.4.2-patches-1.1.tar.bz2` |
| `gcc-3.4.0-piepatches-v8.7.6.5.tar.bz2` | `c6d950e8f61cbac4590061a116669b56` | `http://dev.gentoo.org/~lv/GCC/gcc-3.4.0-piepatches-v8.7.6.5.tar.bz2` | `http://bloodnoc.org/~roy/olde-distfiles/gcc-3.4.0-piepatches-v8.7.6.5.tar.bz2` |
| `gcc-3.4.2-manpages.tar.bz2` | `bdec16a59f044190fa51e28cae30da34` | `http://dev.gentoo.org/~lv/GCC/gcc-3.4.2-manpages.tar.bz2` | `http://bloodnoc.org/~roy/olde-distfiles/gcc-3.4.2-manpages.tar.bz2` |
| `bounds-checking-gcc-3.4.2-1.00.patch.bz2` | `b1040fff7d8cd069347080b8ec3e87b7` | `http://web.inter.nl.net/hcc/Haj.Ten.Brugge/bounds-checking-gcc-3.4.2-1.00.patch.bz2` | `http://bloodnoc.org/~roy/olde-distfiles/bounds-checking-gcc-3.4.2-1.00.patch.bz2` |

The bounds-checking patch is part of Gentoo's digest for the ebuild but is not used for this target build.

Historical Gentoo distfile mirrors and archives are discussed in [Gentoo bug 834712](https://bugs.gentoo.org/834712). Thanks to Cursed Silicon, Roy Bamford's preserved `bloodnoc.org` archive, John Cartwright's `grok.org.uk/tools/ssp/` ProPolice archive, snargawok's jabawok.net Gentoo distfiles archive, Archive.org, and the Gentoo archive maintainers for keeping enough of this material reachable to make the build reproducible.

## Build Locally

Install Git LFS before checkout or run `git lfs pull` after checkout. Then:

```sh
scripts/verify-inputs.sh
IMAGE=gcc-3.4.2-gentoo2005:latest scripts/build.sh
IMAGE=gcc-3.4.2-gentoo2005:latest scripts/smoke-test.sh
```

The build imports `inputs/stage3/stage3-x86-2005.0.tar.bz2` into Docker if `gentoo-2005.0-stage3:x86` is not already present.

## GitHub Actions

`.github/workflows/publish.yml` builds on pull requests, pushes to `master`/`main`, tags, and manual dispatch. Pull requests build and smoke-test only. Pushes and tags also publish to GHCR using `GITHUB_TOKEN`.

## Verification

The Dockerfile runs `bash /recipe/build-gentoo-gcc.sh verify`, which checks the built compiler. The workflow also compiles a small object and verifies its `.comment` section contains:

```text
GCC: (GNU) 3.4.2  (Gentoo Linux 3.4.2-r2, ssp-3.4.1-1, pie-8.7.6.5)
```
