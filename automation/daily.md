You are updating the Awesome AI Motion Videos repository in the current directory. Work without asking questions. Finish in one pass.

Goal: add up to 8 new, good pieces to `data/videos.json` today, then commit and push. If nothing qualifies, change nothing.

Spread: at most 2 pieces from the same creator per day (`scripts/add.mjs` defers extras to `data/leads.json`). If search turns up little, look wider (other accounts, other models) rather than taking more from one creator.

What qualifies (all must hold):
- A public X post with a video or animated GIF.
- The creator says an AI model made it, mostly in code: three.js, WebGL, canvas, SVG, Remotion, HyperFrames, Blender or a game engine driven by the model. Not plain AI video generation (Sora, Veo, Seedance, Kling) and not edited footage.
- It looks good. Skip low-effort tests, screenshots, memes and ads for courses or tools.
- It is not already in `data/videos.json` or `data/rejected.json`.

Where to look, in this order:
1. Open submissions: `gh issue list --state open --label submission --json number,title,body` (also check open issues without a label whose body has an x.com status link). After handling one, close it with a short comment: added, or why not.
2. `data/leads.json`: handles/ids found earlier. Remove each from the file once handled.
3. Web search for posts from the last 3 days, e.g. `site:x.com "Opus 5.5" three.js`, `site:x.com "one prompt" motion graphics`, `site:x.com "same prompt" vs Opus`, `site:x.com Kimi K3.1 three.js`, `site:x.com Gemini 4 Argon animation`, `site:x.com HyperFrames`, plus any newly released model name you see trending. Also check recent posts by marcthecreatorr, luckeyfaraday, kevin_t_ngo, maxt3chno, rewind02, minchoi, socialwithaayan.

To check a post: `curl -s https://api.fxtwitter.com/<handle>/status/<id>` gives the full text, author, date and media.

For each piece you pick, write an entry into a temp file `automation/tmp/cands.json` (a JSON array):
`{ "handle", "id", "title", "titleZh", "category", "models": [...] }`
- `title`: short English title describing what it is (not the creator's hype). `titleZh`: natural Chinese title.
- `category`: `motion` (videos, launch films, animation), `3d` (3D scenes, worlds), `interactive` (games, playable or explorable web pages, tools), `comparison` (same prompt across models).
- `models`: only models the creator names, e.g. "Opus 5.5", "GPT-6 Astra", "Gemini 4 Argon", "Kimi K3.1 Pro", "DeepSeek V4.1 Flash".
- Add `"prompt"` and `"promptUrl"` only when the creator published the exact prompt (in the post or their own reply); copy it verbatim.
- For posts you looked at and rejected, add `{ "handle", "id", "reject": "<short reason>" }` so they are not checked again.

Then run `node scripts/add.mjs automation/tmp/cands.json`. It fetches the facts itself, validates, and rebuilds the READMEs.

If at least one piece was added: `git add -A && git commit -m "Add <n> pieces (<YYYY-MM-DD>)" && git push`. If only rejects or leads changed, commit those too with message "Update review lists".

Never re-host videos, never invent prompts, never edit README.md by hand.
Print a one-line summary at the end: added N, rejected M, submissions handled K.
