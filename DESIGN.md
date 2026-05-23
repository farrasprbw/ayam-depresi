---
name: Ayam Depresi
colors:
  surface: '#fdf8f8'
  surface-dim: '#ddd9d8'
  surface-bright: '#fdf8f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f7f3f2'
  surface-container: '#f1edec'
  surface-container-high: '#ebe7e6'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#444748'
  inverse-surface: '#313030'
  inverse-on-surface: '#f4f0ef'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c8c6c5'
  secondary: '#5f5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e4e2e1'
  on-secondary-container: '#656464'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1c1b1a'
  on-tertiary-container: '#868382'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474746'
  secondary-fixed: '#e4e2e1'
  secondary-fixed-dim: '#c8c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#474747'
  tertiary-fixed: '#e6e2df'
  tertiary-fixed-dim: '#cac6c4'
  on-tertiary-fixed: '#1c1b1a'
  on-tertiary-fixed-variant: '#484645'
  background: '#fdf8f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  display:
    fontFamily: Bricolage Grotesque
    fontSize: 72px
    fontWeight: '800'
    lineHeight: '1.0'
    letterSpacing: -0.04em
  headline-lg:
    fontFamily: Bricolage Grotesque
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Bricolage Grotesque
    fontSize: 36px
    fontWeight: '800'
    lineHeight: '1.1'
  headline-md:
    fontFamily: Bricolage Grotesque
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '500'
    lineHeight: '1.6'
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
spacing:
  base: 8px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 64px
  container-max: 1200px
---

## Brand & Style
The brand identity centers on "ironic sadness"—a gritty, dark, and playfully nihilistic approach to the chicken delivery experience. It targets a young, digitally-native audience that appreciates self-deprecating humor and bold, unconventional aesthetics. 

The visual style is a fusion of **Modern Brutalism** and **Zine Culture**. It utilizes heavy black borders, stark contrast, and hand-drawn textures to evoke a sense of "street-food urgency." The emotional response should be one of intrigue and appetite; the UI feels raw and unpolished yet meticulously structured, mirroring the intense heat and chaotic flavor of *ayam geprek*.

## Colors
This design system uses a high-contrast palette rooted in a "Noir-Kraft" aesthetic. 

- **Primary Black (#1A1A1A):** Used for heavy strokes, primary text, and deep shadows.
- **Secondary Grey (#333333):** Used for secondary information and texture overlays.
- **Accent Red (#E63946):** Represents the spice levels and "warning" elements. It is used sparingly for CTAs, price points, and heat indicators.
- **Kraft Beige (#F1E3D3):** The primary canvas color. It mimics the appearance of unbleached delivery packaging, providing a warm, tactile counterpoint to the cold black and red.

## Typography
The typography strategy contrasts expressive, "distressed" energy with clean legibility.

- **Headlines:** Bricolage Grotesque provides a quirky, slightly distorted feel that matches the "depressed" persona. Use tight tracking and leading for a compact, aggressive look.
- **Body:** Plus Jakarta Sans ensures high readability for menu descriptions and delivery details. It offers a soft balance to the sharp headlines.
- **Technical Info:** JetBrains Mono is used for prices, timestamps, and order IDs to lean into the "industrial/glitch" side of the brand's gritty personality.

## Layout & Spacing
The layout follows a **Fixed-Grid Brutalist** model. Elements are contained within thick-bordered boxes that align strictly to an 8px grid.

- **Desktop:** 12-column grid with 24px gutters. Use asymmetrical layouts (e.g., content spanning columns 1-7 while 8-12 remain empty or hold large decorative text) to reinforce the "unstable" brand vibe.
- **Mobile:** Single column with 20px side margins. 
- **Rhythm:** Use generous vertical spacing between sections to let the high-contrast elements breathe. Avoid soft transitions; use hard breaks and solid horizontal rules (`<hr>`) with 4px weight.

## Elevation & Depth
Depth is not communicated through realism or shadows, but through **Hard-Edge Layering**.

- **Shadows:** Use "Hard-Drop" shadows only. These are solid black offsets (e.g., 4px down, 4px right) with 100% opacity. No blurs are permitted.
- **Overlays:** Use 45-degree hatched patterns or "noise" textures on top of surfaces to give them a tactile, paper-printed feel.
- **Tonal Layers:** The background is always Kraft Beige. Cards and containers use a white or primary black fill with a 2px - 4px solid black border.

## Shapes
The shape language is strictly **Sharp and Angular**. 

- **Corners:** All buttons, cards, and input fields must have 0px border-radius. This reinforces the raw, "street" aesthetic of the brand.
- **Icons:** Use thick-stroke, monolinear icons. Hand-drawn "doodle" style icons are encouraged for spice levels or decorative elements to contrast the rigid UI structure.

## Components

- **Buttons:** Primary buttons are Accent Red with a 2px solid Black border and a Hard-Drop shadow. Text is uppercase Label-Mono. On hover, the button shifts -2px, -2px to "cover" its shadow.
- **Cards:** Product cards use a White fill on the Kraft background. Use a 3px solid black border. Images should be high-contrast with slightly desaturated colors.
- **Input Fields:** Thick 2px black bottom border only (no full box) for a minimalist "form" feel.
- **Spice Indicators:** Instead of stars, use custom hand-drawn "flame" or "skull" icons in Accent Red.
- **Chips/Labels:** Use the Black background with White Label-Mono text for tags like "EXTREME SPICY" or "SOLD OUT."
- **Lists:** Use heavy horizontal rules between menu items. Include "strikethrough" text effects for items that are out of stock to lean into the "depressive" theme.