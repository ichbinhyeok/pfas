# Design Lock 2026-03-20

## Product stance

This interface is not a generic PFAS blog and not a cheerful SaaS landing page.
It is a premium action engine that interprets public evidence and routes households
to the next responsible action.

The visual model is:

- Stripe or Ramp for information control
- Mercury for calm trust
- Editorial infrastructure, not lifestyle branding

## Implementation baseline

- Tailwind CSS v4 is the primary frontend styling layer.
- Existing legacy CSS can coexist during migration, but new work should default to
  Tailwind utilities and theme tokens.

## Fixed visual tokens

- App background: soft ivory `#f7f7f4`
- Primary surface: `#fdfcf8`
- Muted surface: `#f1f0ea`
- Primary text: deep slate `#17212b`
- Body text: `#30414f`
- Muted text: `#66737f`
- Accent: deep teal `#0f766e`
- Secondary accent: mineral blue `#31576b`
- Border: `rgba(15, 23, 42, 0.06)`

## Typography

- Sans base: Manrope with Korean fallbacks
- Serif accent: Newsreader
- Serif is used only for key declarations and framing lines, not dense UI labels

## Interaction rules

- Quiet hover only
- No loud scale effects
- No bounce, float, glow, or decorative motion
- Buttons and cards can lift by roughly 1px or shift border tint slightly

## Surface rules

- Generous spacing wins over decorative styling
- Borders are more important than shadows
- Shadows stay soft and layered, never heavy
- Cards should feel like structured records, not marketing tiles

## Trust rules

- Caveats stay visible in the main reading path
- Commercial paths must explain why the user is seeing a product lane
- No fake expert or reviewer surfaces

## Forbidden directions

- Purple themes
- Neon gradients
- Heavy glassmorphism
- Blob backgrounds
- Floating marketing animations
- Fear-based warning styling
