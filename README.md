# MorphoSource REST API

[MorphoSource](https://www.morphosource.org) is a publicly accessible 3D data repository  that enables museums, researchers, and scholars to upload, curate, and share 3D and 2D media representing physical objects of scholarly importance that can be found, viewed, and downloaded by other subject experts, educators, and the public. The MorphoSource REST API allows users to query and search repository records, including Media, Physical Objects, Organizations, and media collections like Projects and Teams. Users can also use the API to download MorphoSource media. Users who manage projects and teams can use the API to retrieve usage information for media in their media collections, including numbers of downloads, download requests, and other usage statistics. 

The API is described with intuitive human-readable [documentation](https://morphosource.stoplight.io/docs/morphosource-api/rm6bqdolcidct-morpho-source-rest-api) powered by Stoplight. This documentation includes example requests and responses which can be very helpful when getting started with the API. We also make available an [OpenAPI 3 Schema specification document](https://github.com/MorphoSource/morphosource-api) that expresses and describes the API in ways that machines can interpret.  

## Endpoints

This is a list of major API endpoints that are described in this documentation, with links to pages describing each endpoint.

### Media

| Endpoint | Description |
| --- | --- |
| [/api/media/{media-id}](https://morphosource.stoplight.io/docs/morphosource-api/b474e3d7c2ccc-get-individual-media-record) | Get individual media record |
| [/api/media](https://morphosource.stoplight.io/docs/morphosource-api/2d534286cca2e-search-media-records) | Search media records |
| [/api/download/{media-id}](https://morphosource.stoplight.io/docs/morphosource-api/stzmm22vruz2k-download-media-file) | Download media file |

### Physical Objects

| Endpoint | Description |
| --- | --- |
| [/api/physical-objects/{physical-object-id}](https://morphosource.stoplight.io/docs/morphosource-api/aea3fb04ec708-get-individual-physical-object-record) | Get individual physical object record |
| [/api/physical-objects](https://morphosource.stoplight.io/docs/morphosource-api/2da44118dab34-search-physical-object-records) | Search physical object records |

### Organizations

| Endpoint | Description |
| --- | --- |
| [/api/organizations/{organization-id}](https://morphosource.stoplight.io/docs/morphosource-api/a544f2a31073a-get-individual-organization-record) | Get individual organization record |
| [/api/organizations](https://morphosource.stoplight.io/docs/morphosource-api/fa3dc1d3c66be-search-organization-records) | Search organization records |

### Projects or Teams

| Endpoint | Description |
| --- | --- |
| [/api/projects/{project-or-team-id}](https://morphosource.stoplight.io/docs/morphosource-api/a14e662377b48-get-individual-project-or-team-record) | Get individual project or team records |
| [/api/projects](https://morphosource.stoplight.io/docs/morphosource-api/01a98fbf58a8b-search-project-or-team-records) | Search project or team records |
| [/api/projects/{project-or-team-id}/media](https://morphosource.stoplight.io/docs/morphosource-api/12c02c9cbcce0-get-media-in-project-or-team) | Get media in project or team |
| [/api/projects/{project-or-team-id}/biological-specimens](https://morphosource.stoplight.io/docs/morphosource-api/3bb4484b02180-get-biological-specimens-in-project-or-team) | Get biological specimens in project or team |
| [/api/projects/{project-or-team-id}/cultural-heritage-objects](https://morphosource.stoplight.io/docs/morphosource-api/4c194247a13ee-get-cultural-heritage-objects-in-project-or-team) | Get cultural heritage objects in project or team |
| [/api/projects/{project-or-team-id}/media-download-counts](https://morphosource.stoplight.io/docs/morphosource-api/01d554d45ad00-get-metadata-and-download-counts-of-media-in-project-or-team) | Get metadata and download counts of media in project or team |
| [/api/projects/{project-or-team-id}/media-downloads](https://morphosource.stoplight.io/docs/morphosource-api/ecc384615696f-get-downloads-of-media-in-project-or-team) | Get downloads of media in project or team |
| [/api/projects/{project-or-team-id}/media-requests](https://morphosource.stoplight.io/docs/morphosource-api/0e6860f269b72-get-requests-to-download-restricted-media-in-project-or-team) | Get requests to download restricted media in project or team |
| [/api/projects/{team-id}/view-only-media-projects](https://morphosource.stoplight.io/docs/morphosource-api/67b9b4443769a-get-projects-containing-media-in-a-team-but-not-owned-by-team) | Get projects containing media in a team but not owned by team |

## Other Resources

To better understand the metadata fields and terms used in the API, consult the [MorphoSource Terms Vocabulary](https://www.morphosource.org/terms/ms) and [MorphoSource Controlled Vocabularies](https://www.morphosource.org/terms/mscv) terms ontologies. These ontologies define and characterize the data model and metadata fields used by MorphoSource to record important attributes of media and physical object records, as well as the imaging and processing workflows that produce media.  

## Attribution

The creation of this API documentation was supported by the National Science Foundation under Grant Number DBI-2149257. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.