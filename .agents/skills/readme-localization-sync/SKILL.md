---
name: readme-localization-sync
description: Use when README.md changes and localized README files under doc/README.*.md should be updated to match it with natural, idiomatic language rather than literal translation.
---

# README Localization Sync

Use `README.md` as the source of truth and update every localized README matching:

```shell
rg --files doc -g 'README.*.md'
```

## Workflow

1. Read `README.md`.
2. Find all target files matching `doc/README.*.md`.
3. Read each target before editing so its existing language style can be preserved.
4. Update every target so it matches the meaning, structure, links, lists, versions, and technical details of `README.md`.
5. Keep Markdown structure aligned, but write localized prose naturally for each language.

## Localization Rules

- Prefer idiomatic expression over word-for-word translation.
- Preserve code blocks, commands, paths, URLs, package names, class names, and version numbers.
- Keep project and technology names unchanged unless the target file already has a clear convention.
- Keep the language switcher synchronized across README variants.
- For `README.zh-CN.md`, use natural Simplified Chinese.
- For `README.zh-TW.md`, use natural Traditional Chinese and avoid Simplified Chinese characters.
- For future locales, infer the language from the filename and follow the existing tone of that file.

## Final Check

Before finishing, compare all localized files with `README.md` and make sure no target is missing newly added sections, links, lists, or important details.
