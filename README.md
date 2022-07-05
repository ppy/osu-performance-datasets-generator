# osu-performance-datasets-generator [![dev chat](https://discordapp.com/api/guilds/188630481301012481/widget.png?style=shield)](https://discord.gg/ppy)

Set of scripts generating SQL and .osu dumps from production for osu-performance developers to use locally.

# Usage

Run `./dump_all.sh` monthly with the following environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET`, `DATABASE_HOST`, `DATABASE_USER`. Default canned ACL can also be set using `S3_ACL`.

For DigitalOcean Spaces support, also set `AWSCLI_SUFFIX`, eg `AWSCLI_SUFFIX=--endpoint=https://nyc3.digitaloceanspaces.com`. `S3_ACL` can be set to `private` or `public-read`

~16GB of free disk space is recommended (estimated).

# Contributing

Contributions can be made via pull requests to this repository. We hope to credit and reward larger contributions via a [bounty system](https://www.bountysource.com/teams/ppy). If you're unsure of what you can help with, check out the [list of open issues](https://github.com/ppy/osu-performance-datasets-generator/issues).

Note that while we already have certain standards in place, nothing is set in stone. If you have an issue with the way code is structured; with any libraries we are using; with any processes involved with contributing, *please* bring it up. I welcome all feedback so we can make contributing to this project as pain-free as possible.

# Licence

The osu! client code, framework, and server-side components are licensed under the [MIT licence](https://opensource.org/licenses/MIT). Please see [the licence file](LICENCE) for more information. [tl;dr](https://tldrlegal.com/license/mit-license) you can do whatever you want as long as you include the original copyright and license notice in any copy of the software/source.

Please note that this *does not cover* the usage of the "osu!" or "ppy" branding in any software, resources, advertising or promotion, as this is protected by trademark law.
