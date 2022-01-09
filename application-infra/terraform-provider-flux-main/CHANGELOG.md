# Changelog

All notable changes to this project are documented in this file.

## 0.8.1

**Release date:** 2021-12-10

This prerelease includes flux2 [v0.24.1](https://github.com/fluxcd/flux2/releases/tag/v0.24.1).

## 0.8.0

**Release date:** 2021-11-24

This prerelease includes flux2 [v0.24.0](https://github.com/fluxcd/flux2/releases/tag/v0.24.0),
and allows for [enabling bootstrap customization of Flux components](https://github.com/fluxcd/terraform-provider-flux/pull/217)
through Terraform config.

## 0.7.3

**Release date:** 2021-11-12

This prerelease includes flux2 [v0.23.0](https://github.com/fluxcd/flux2/releases/tag/v0.23.0).

## 0.7.2

**Release date:** 2021-11-11

This prerelease includes flux2 [v0.22.1](https://github.com/fluxcd/flux2/releases/tag/v0.22.1).

## 0.7.1

**Release date:** 2021-11-10

This prerelease includes flux2 [v0.22.0](https://github.com/fluxcd/flux2/releases/tag/v0.22.0).

## 0.7.0

**Release date:** 2021-11-05

This prerelease includes flux2 [v0.21.1](https://github.com/fluxcd/flux2/releases/tag/v0.21.1),
and adds support for defining Tag, SemVer and Commit references in `data.flux_sync`.

## 0.6.1

**Release date:** 2021-11-01

This prerelease includes flux2 [v0.20.1](https://github.com/fluxcd/flux2/releases/tag/v0.20.1).

## 0.6.0

**Release date:** 2021-10-28

This prerelease includes flux2 [v0.20.0](https://github.com/fluxcd/flux2/releases/tag/v0.20.0).

## 0.5.1

**Release date:** 2021-10-22

This prerelease includes flux2 [v0.19.1](https://github.com/fluxcd/flux2/releases/tag/v0.19.1).

## 0.5.0

**Release date:** 2021-10-19

This prerelease includes flux2 [v0.19.0](https://github.com/fluxcd/flux2/releases/tag/v0.19.0).

## 0.4.0

**Release date:** 2021-10-15

This prerelease includes flux2 [v0.18.3](https://github.com/fluxcd/flux2/releases/tag/v0.18.3).

Flux v0.18 comes with breaking changes, new features, performance improvements and many bug fixes.

Please see the [Upgrade to Flux v0.18 and the v1beta2 API](https://github.com/fluxcd/flux2/discussions/1916) discussion for more details.

**Breaking changes**
With the introduction of Kustomization v1beta2 there is a breaking change that requires a manual state update.

All that is required is to remove the `kubectl_manifest` resource for the Kustomization manifest. This will cause the kubectl provider to overwrite the existing manifest.

```shell
terraform state rm 'kubectl_manifest.sync["kustomize.toolkit.fluxcd.io/v1beta1/kustomization/flux-system/flux-system"]'
```

Future versions of the provider will solve this long term.

## 0.3.1

**Release date:** 2021-09-13

This prerelease includes flux2 [v0.17.1](https://github.com/fluxcd/flux2/releases/tag/v0.17.1).

## 0.3.0

**Release date:** 2021-08-26

This prerelease includes flux2 [v0.17.0](https://github.com/fluxcd/flux2/releases/tag/v0.17.0).

## 0.2.2

**Release date:** 2021-08-06

This prerelease includes flux2 [v0.16.2](https://github.com/fluxcd/flux2/releases/tag/v0.16.2).

## 0.2.1

**Release date:** 2021-07-30

This prerelease includes flux2 [v0.16.1](https://github.com/fluxcd/flux2/releases/tag/v0.16.1).

## 0.2.0

**Release date:** 2021-07-01

This prerelease includes flux2 [v0.16.0](https://github.com/fluxcd/flux2/releases/tag/v0.16.0).

## 0.1.12

**Release date:** 2021-06-23

This prerelease includes flux2 [v0.15.3](https://github.com/fluxcd/flux2/releases/tag/v0.15.3).

## 0.1.11

**Release date:** 2021-06-18

This prerelease includes flux2 [v0.15.2](https://github.com/fluxcd/flux2/releases/tag/v0.15.2).

## 0.1.10

**Release date:** 2021-06-15

This prerelease includes flux2 [v0.15.0](https://github.com/fluxcd/flux2/releases/tag/v0.15.0).

## 0.1.9

**Release date:** 2021-06-03

This prerelease includes flux2 [v0.14.2](https://github.com/fluxcd/flux2/releases/tag/v0.14.2).

## 0.1.8

**Release date:** 2021-05-28

This prerelease includes flux2 [v0.14.1](https://github.com/fluxcd/flux2/releases/tag/v0.14.1).

## 0.1.7

**Release date:** 2021-05-27

This prerelease includes flux2 [v0.14.0](https://github.com/fluxcd/flux2/releases/tag/v0.14.0).

## 0.1.6

**Release date:** 2021-05-10

This prerelease includes flux2 [v0.13.4](https://github.com/fluxcd/flux2/releases/tag/v0.13.3).

## 0.1.5

**Release date:** 2021-05-10

This prerelease includes flux2 [v0.13.3](https://github.com/fluxcd/flux2/releases/tag/v0.13.3).

## 0.1.4

**Release date:** 2021-04-28

This prerelease includes flux2 [v0.13.1](https://github.com/fluxcd/flux2/releases/tag/v0.13.1).

**Breaking changes**
In this version the image automation APIs have been promoted to `v1alpha2`.
The new APIs come with breaking changes, please follow the [image automation upgrade guide](https://github.com/fluxcd/flux2/discussions/1333).

## 0.1.3

**Release date:** 2021-04-08

Remove `image-reflector-controller` and `image-automation-controller` as default values
for `components_extra` to reflect the behavior of the CLI.

## 0.1.2

**Release date:** 2021-04-08

This prerelease includes flux2 [v0.12.0](https://github.com/fluxcd/flux2/releases/tag/v0.12.0).

## 0.1.1

**Release date:** 2021-03-26

This prerelease includes flux2 [v0.11.0](https://github.com/fluxcd/flux2/releases/tag/v0.11.0).

## 0.1.0

**Release date:** 2021-03-18

This prerelease includes flux2 [v0.10.0](https://github.com/fluxcd/flux2/releases/tag/v0.10.0).

## 0.0.14

**Release date:** 2021-03-17

This prerelease adds two new properties to new properties, one
for each datasource. A notable change is that the name property in
data sync no longer set the sync secret name. Instead this should
be done with the secret property.

Improvements:
* Add components extra to data sync data source
  [#115](https://github.com/fluxcd/terraform-provider-flux/pull/115)
* Make secret ref configurable
  [#113](https://github.com/fluxcd/terraform-provider-flux/pull/113)
* Add an example for GKE and Github
  [#112](https://github.com/fluxcd/terraform-provider-flux/pull/112)

## 0.0.13

**Release date:** 2021-03-09

This prerelease includes flux2 [v0.9.1](https://github.com/fluxcd/flux2/releases/tag/v0.9.1)

## 0.0.12

**Release date:** 2021-02-12

A new `toleration_keys` parameter has been added to the install
data source to enable installtion in cluster with node taints.

Improvements:
* Add tolerations parameter to install datasource
  [#96](https://github.com/fluxcd/terraform-provider-flux/pull/96)
* Fix resource name
  [#90](https://github.com/fluxcd/terraform-provider-flux/pull/90)

## 0.0.11

**Release date:** 2021-01-29

The example guides have changed to improve the upgrading experience.
The resource keys will change from being based on the content applied
to the identifier of the resource being applied. This change will
make moving from one version of Flux to another more stable.

Improvements:
* Refactor provider to reliably track changes in manifestgen output
  [#85](https://github.com/fluxcd/terraform-provider-flux/pull/85)
* Add verification and check of image versions
  [#81](https://github.com/fluxcd/terraform-provider-flux/pull/81)

## 0.0.10

**Release date:** 2021-01-15

The `arch` parameters has been removed from the `flux_install` resource
as multi-arch images are now published under the same tag.

Improvements:
* Update flux to v0.6.0
  [#77](https://github.com/fluxcd/terraform-provider-flux/pull/77)
* Add git implementation to sync datasource
  [#76](https://github.com/fluxcd/terraform-provider-flux/pull/76)
