<p align="center">
  <a href="https://github.com/jcouture/incr">
    <img src="https://user-images.githubusercontent.com/5007/160249855-dc0eb32f-f77d-4c5a-a995-93ac46408a68.png" alt="incr" />
  </a>
  <br />
  incr is a tool to help you easily increment the version number of your NPM or Mix packages.
  <br /><br />
  <a href="https://rubygems.org/gems/incr"><img src="http://img.shields.io/gem/v/incr.svg" /></a>
</p>

## What does `incr` do?

The process is detailed as follow:

*  Find the relevant file(s) (e.g.: `package.json` and `package-lock.json` or `mix.exs`).
* Determine the existing version number.
* Increment the specified segment. If you increment the minor segment, the patch segment is set to 0 and the same goes for the major segment, the minor and patch segments are set to 0.
* Write the newly incremented version number in the relevant file(s).
* Create a new `git commit` with the relevant file with the version number as the default message (e.g.: 0.2.1).
* Create a new annotated `git tag` pointing to the new `git commit` with the version number prefixed by a 'v' as the name (e.g.: v0.2.1).
* 💥

## Installation

### incr

```shell
~> gem install incr
```

## Usage

To increment the patch segment of your NPM package version number:

```shell
~> incr npm patch
```

To increment the minor segment of your Mix package version number:

```shell
~> incr mix minor
```

To start or increment a prerelease:

```shell
# 1.2.3 -> 1.2.3-alpha.0
~> incr npm prerelease alpha

# 1.2.3-alpha.0 -> 1.2.3-alpha.1
~> incr npm prerelease
```

To start or increment build metadata:

```shell
# 1.2.3 -> 1.2.3+ci.0
~> incr npm build ci

# 1.2.3+ci.0 -> 1.2.3+ci.1
~> incr npm build
```

Prerelease increments clear build metadata. Major, minor, and patch increments clear both prerelease and build metadata. Supplying an identifier that conflicts with the existing identifier returns an error without changing the version. Identifiers use the SemVer character rules and their trailing numeric component is incremented; for example, `alpha` starts at `alpha.0` and then becomes `alpha.1`.

### Arguments

Here are some arguments that can be used with `incr`:

- `-d` : Directory where to search for the version files (default: `.`)
- `-t` : Tag name pattern, where `%s` will be replaced with the new version (default: `v%s`)
- `--[no-]commit` : Commit changes. (default: enabled)
- `--[no-]tag` : Create a git tag. (default: enabled)
- `major`, `minor`, `patch` : Increment the corresponding numeric segment.
- `prerelease [identifier]` : Start or increment a prerelease identifier.
- `build [identifier]` : Start or increment build metadata.

Example:

```shell
~> incr --no-tag -d ./subprojects/web/ -t my-custom-tag-prefix/%s npm patch
```

This will :

- Search for `package.json` and `package-lock.json` files inside `./subprojects/web/` and update the patch version
- Commit the changes under the message `my-custom-tag-prefix/2.3.4`
- Not create a tag with the new version

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jcouture/incr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
