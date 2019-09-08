# github-clone
A small bash script to quickly clone repositories matching a regex from a specific user or organization.

## Dependencies
+ jq: <https://stedolan.github.io/jq/>
+ git: <https://git-scm.com/>

## How to use
+ You can specify a github api url for: 
  + A user: <https://api.github.com/users/crispydrone/repos>
  + An organization: <https://api.github.com/orgs/microsoft/repos>

The script will ask for credentials but these are not obligatory. As an anonymous user you are limited to 60 requests per hour, find more information about the rate limit here: <https://developer.github.com/v3/#rate-limiting>.

## Examples
+ To clone all repositories from a specific user into a target directory:

  ```
  github-clone https://api.github.com/users/crispydrone <target-dir>
  ```

+ To clone all repositories from a specific organization with current directory as root:

  ```
  github-clone https://api.github.com/orgs/<organization-name>
  ```

+ Clone all repositories having "notes" (case insensitive) in the repository name into a NOTES directory

   ```
   github-clone https://api.github.com/users/crispydrone NOTES notes
   ```

## In the pipeline
1. Improve command line experience:
   + Make the soliciting for credentials optional
   + Support for command line flag `-t <type>` (user or org) so it's not necessary to type a raw url every time.
2. Support for parallel processing
3. Cross platform support
4. Skip existing repositories in a smarter way, based on remote urls (in case repositories are not all on the same depth in the root directory).

## Change history
+ v0.21:
  + Removed "exit on error", and added support to skip repositories that already have been cloned with the default directory name.
+ v0.20:
  + Added support for pagination in case the number of repositories to clone is returned by github across multiple pages.
+ v0.12:
  + Hotfix, fixed broken regex.
+ v0.11: 
  + Made regex case insensitive, added default values for directory and regex.
+ v0.10:
  + Clone all directories or a subset matching a specific regex from a github api user or organization url into a specific directory.

