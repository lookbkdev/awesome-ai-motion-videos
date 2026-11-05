# Contributing

## Add a piece

Use the [submission form](https://github.com/lookbkdev/awesome-ai-motion-videos/issues/new?template=submit.yml) or open a pull request that adds one object to `data/videos.json`.

An entry qualifies when:

- it's a public post on X with a video or animation,
- the creator says an AI model made it (mostly in code: three.js, canvas, SVG, Remotion, HyperFrames, game engines driven by the model),
- it isn't already listed.

Fields: `id`, `handle`, `name`, `url` (`https://x.com/<handle>/status/<id>`), `date`, `title`, `titleZh`, `category` (`motion`, `3d`, `interactive`, `comparison`), `models`, `text` (the post, verbatim), `thumb` (X's thumbnail URL), `duration`, and `prompt` + `promptUrl` only when the creator published the exact prompt.

Then run `node scripts/build.mjs`, which checks every entry and regenerates both READMEs and `prompts/`.

## Fix or remove an entry

See [MEDIA-RIGHTS.md](MEDIA-RIGHTS.md).

## How the list is kept up to date

A scheduled job (`automation/`) runs once a day. It reviews open submissions first, then earlier leads, then recent public posts, adds the pieces that qualify through `scripts/add.mjs`, and closes each submission with a note saying whether it was added. Posts it turns down are recorded in `data/rejected.json` with the reason, so they aren't reviewed twice. To appeal a decision, open an issue.
