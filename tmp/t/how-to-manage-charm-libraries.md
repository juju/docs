(how-to-manage-charm-libraries)=
# How to manage charm libraries


> See also: {ref}`Library <library>`, {ref}`Popular charm library index <popular-charm-library-index>`

<!--This document shows you how to execute various tasks related to charm libraries, from discovering existing libraries to creating and publishing your own. As you will see, all these tasks can be easily accomplished using  {ref}`Charmcraft <charmcraft-charmcraft>`.-->


- {ref}`How to find and use a charm library <how-to-find-and-use-a-charm-library>`
- {ref}`How to create and share a charm library <how-to-create-and-share-a-charm-library>`
- {ref}`How to document your charm library <how-to-document-your-charm-library>` 

<!--COMMENT: PARTS OF THIS CAN BE USED IN A RATIONALE SECTION OF THE "ABOUT CHARM LIBRARIES" DOC, BUT RIGHT NOW THE STORY ISN'T VERY CLEAR. 
Charm authors need a way to easily share and reuse logic, charms make that even more important given the two-sided nature of relations. That is, a given interface type needs logic on the providing side and on the required side, this is better handled when the responsibility lies on the same entity.

The Charmcraft tool supports a first-class mechanism to reuse logic in a form of python modules named libraries which are published on Charmhub for easy consumption.
 
This model diverges from generic versioning systems (as git/Github) and packages publishing systems (like PyPI) because we aim for simplicity as there is no need to create further structures to distribute and install the library, nor do we need to have registered users in other platforms.

Furthermore, libraries shared through this mechanism are directly integrated with Charmhub, allowing other users to find our shared libraries (including their documentation) when exploring our charms on that platform.  
-->