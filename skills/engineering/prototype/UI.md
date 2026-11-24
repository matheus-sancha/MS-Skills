# UI Prototype

Generate **several radically different UI variations** on a single screen, switchable from a floating bottom bar. The user flips between variants in the running app, picks one (or steals bits from each), then throws the rest away.

"Screen" below means a Flutter screen or a web route. The **variant key** lives wherever the toolchain keeps debug state: in Flutter a `ValueNotifier` seeded from `--dart-define=VARIANT=B`; on the web a `?variant=` URL search param.

If the question is about logic/state rather than what something looks like — wrong branch. Use [LOGIC.md](LOGIC.md).

## When this is the right shape

- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- Any time the user would otherwise spend a day picking between three vague mockups in their head.

## Two sub-shapes — strongly prefer sub-shape A

A UI prototype is much easier to judge when it's **butting up against the rest of the app** — real header, real sidebar, real data, real density. A throwaway screen on its own is a vacuum: every variant looks fine in isolation. Default to sub-shape A whenever there's a plausible existing page to host the variants. Only reach for sub-shape B if the prototype genuinely has no nearby home.

### Sub-shape A — adjustment to an existing page (preferred)

The screen already exists. Variants are rendered **on the same screen**, gated by the variant key. The existing providers, data fetching, params, and auth all stay — only the rendering swaps. This is the default; pick it unless there's a specific reason not to.

If the prototype is for something that doesn't yet have a page but _would naturally live inside one_ (a new section of the dashboard, a new card on the settings screen, a new step in an existing flow) — that's still sub-shape A. Mount the variants inside the host page.

### Sub-shape B — a new page (last resort)

Only use this when the thing being prototyped genuinely has no existing page to live inside — e.g. an entirely new top-level surface, or a flow that can't be embedded anywhere sensible.

Create a **throwaway route** following whatever routing convention the project already uses (a `go_router` route beside its siblings, a file in the existing routes folder) — don't invent a new top-level structure. Name it so it's obviously a prototype (e.g. include the word `prototype` in the path or filename). Same variant key.

Before committing to sub-shape B, sanity-check: is there really no existing page this could be embedded in? An empty screen hides design problems that a populated one would expose.

In both sub-shapes the floating bottom bar is identical.

## Process

### 1. State the question and pick N

Default to **3 variants**. More than 5 stops being radically different and starts being noise — cap there.

Write down the plan in one line, in the prototype's location or a top-of-file comment:

> "Three variants of the settings screen, switchable from the debug bar, on the existing settings route."

This works whether the user is here to push back or not.

### 2. Generate radically different variants

Draft each variant. Hold each one to:

- The page's purpose and the data it has access to.
- The project's theme and component library (the app's `ThemeData` and shared widgets; Tailwind, MUI, whatever the web project uses).
- A clear widget / component name, e.g. `VariantA`, `VariantB`, `VariantC`.

Variants must be **structurally different** — different layout, different information hierarchy, different primary affordance, not just different colours. Three slightly-tweaked card grids isn't a UI prototype, it's wallpaper. If two drafts come out too similar, redo one with explicit "do not use a card grid" guidance.

### 3. Wire them together

Switch on the variant key in one place on the screen. Flutter:

```dart
// Start on a variant: flutter run --dart-define=VARIANT=B
final variant = ValueNotifier(
  const String.fromEnvironment('VARIANT', defaultValue: 'A'),
);

Widget build(BuildContext context) {
  if (!kDebugMode) return VariantA(data: data); // release never sees the prototype
  return ValueListenableBuilder<String>(
    valueListenable: variant,
    builder: (context, v, _) => Stack(
      children: [
        switch (v) {
          'B' => VariantB(data: data),
          'C' => VariantC(data: data),
          _ => VariantA(data: data),
        },
        Align(
          alignment: Alignment.bottomCenter,
          child: PrototypeSwitcher(variants: const ['A', 'B', 'C'], current: variant),
        ),
      ],
    ),
  );
}
```

Web is the same shape: `const variant = searchParams.get("variant") ?? "A"`, render the matching component, then the switcher.

For sub-shape A (existing page): keep all the existing data fetching above the switch; only the rendered subtree changes per variant.

For sub-shape B (new page): the throwaway route mounts the same switch.

### 4. Build the floating switcher

A small fixed-position bar at the bottom-centre of the screen with three pieces:

- **Left arrow** — cycles to the previous variant (wraps around).
- **Variant label** — shows the current variant key and, if the variant exports a name, that name too. e.g. `B — Sidebar layout`.
- **Right arrow** — cycles forward (wraps around).

Behaviour:

- An arrow writes the variant key: set the notifier in Flutter (hot reload keeps it; `--dart-define` picks the starting one); on the web, replace the URL search param through the framework's router so the variant is shareable and reload-stable.
- Keyboard: `←` and `→` arrow keys also cycle (`CallbackShortcuts` in Flutter) — never while a text field is focused.
- Visually distinct from the page (e.g. high-contrast pill, subtle shadow) so it's obviously not part of the design being evaluated.
- Hidden in release builds — gate on `kDebugMode` in Flutter, on the bundler's production check on the web — so a stray prototype merge can't ship the bar to users.

Put the switcher in a single shared component so both sub-shapes can reuse it. Locate it wherever shared UI lives in the project.

### 5. Hand it over

Surface how to reach it — the run command and screen, or the URL — and the variant keys. The user will flip through whenever they get to it. The interesting feedback is usually **"I want the header from B with the sidebar from C"** — that's the actual design they want.

### 6. Capture the answer and clean up

Once a variant has won, write down which one and why (commit message, ADR, issue, or a `NOTES.md` next to the prototype if running AFK and the user hasn't responded yet). Then:

- **Sub-shape A** — delete the losing variants and the switcher; fold the winner into the existing page.
- **Sub-shape B** — promote the winning variant to a real route, delete the throwaway route and the switcher.

Don't leave variant components or the switcher on main; they rot fast and confuse the next reader. To keep the losers for reference, park the full set on the throwaway branch first ([SKILL.md](SKILL.md), rule 6).

## Anti-patterns

- **Variants that differ only in colour or copy.** That's a tweak, not a prototype. Real variants disagree about structure.
- **Sharing too much code between variants.** A shared `<Header>` is fine; a shared `<Layout>` defeats the point. Each variant should be free to throw out the layout.
- **Wiring variants to real mutations.** Read-only prototypes are fine. If a variant needs to mutate, point it at a stub — the question is "what should this look like", not "does the backend work".
- **Promoting the prototype directly to production.** The variant code was written under prototype constraints (no tests, minimal error handling). Rewrite it properly when you fold it in.
