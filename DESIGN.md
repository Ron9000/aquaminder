# AquaMinder Design Direction

Date: 2026-05-09
Owner: Staff Engineer
Issue: GST-9
Status: Visual language locked for implementation planning
Source brief: `Resources/AquaMinder-Genesis-Spec.md`

## Verdict

The founder spec has the right product taste but only a 6.5/10 visual brief.

What is already strong:

- the emotional target is clear: calm, adult, warm, forgiving
- the product thesis is correct: pacing and recovery matter more than totals
- the app should help without becoming another noisy habit machine

What is still underspecified:

- the primary visual metaphor
- the material treatment of "water"
- the typography and color system
- the motion rules
- the ambient surfaces for lock screen, widget, and watch

If engineering starts from the current brief alone, the most likely failure mode is a polished clone of either:

- a utility tracker with rings, charts, and settings sprawl
- a softer version of calm habit UI that still looks generic

That is not good enough for AquaMinder.

## Market Pressure Test

The current market creates a clear opening:

- WaterMinder leans on cups, reminders, progress rings, widgets, streaks, and broad customization. It solves tracking, not taste.
- Plant Nanny wins with charm and motivation, but its core language is collectible cuteness, not calm adult focus.
- Refreshly already claims "calm" and "one-tap logging," which means AquaMinder cannot win by saying "quiet hydration app" alone.
- autoDrink pushes toward automation and explicitly speaks to ADHD users, which validates the attention-management wedge.

The research pressure is equally clear:

- H2Office found that manual logging adds cognitive load and becomes tedious over time.
- The same paper found that phone reminders create a distraction tradeoff: if the phone is away, reminders fail; if it is nearby, other notifications interrupt work.
- Participants wanted subtle, always-visible progress and minimal effort.

## Design Review Scorecard

Score the current brief, not the future product.

| Dimension | Score | What is missing to reach 10 |
| --- | --- | --- |
| Product taste | 9/10 | Already strong; mostly needs sharper visual translation. |
| Visual distinctiveness | 5/10 | The spec says "minimalist" but does not yet define a recognizably ownable form. |
| One-glance comprehension | 7/10 | The pace-over-total insight is strong, but the main surface is not defined. |
| Material expression | 4/10 | "Water as material, not gimmick" is correct but currently abstract. |
| Motion language | 3/10 | No rules yet for how liquid movement should feel. |
| Ambient access | 5/10 | Widgets and watch are mentioned, but not treated as first-class design surfaces. |
| Emotional durability | 8/10 | Recovery-first tone is strong; the remaining risk is visual genericness. |

## Eureka

Everyone reaches for a progress ring because health apps trained the market to equate "goal" with "completion circle."

That is the wrong metaphor here.

Hydration failure is usually not "I forgot the final number."
It is "I drifted off pace for six hours and noticed too late."

So AquaMinder should not visualize hydration as a fitness ring to close.
It should visualize hydration as a vessel staying near a living waterline through the day.

This single decision gives the product its own visual language and keeps the UI aligned with the real user problem.

## Locked Direction: Quiet Vessel

This is the 10/10 direction.

### Core Idea

AquaMinder should feel like a beautifully made glass carafe sitting on a desk near a window.

Not luxurious in a lifestyle-brand way.
Not clinical in a health-tech way.
Not cute in a mascot way.

Quiet Vessel means:

- water is shown as a calm material with weight, depth, and light
- progress is shown as a rising level against time, not a ring to close
- the interface feels composed enough to lower stress instead of adding to it

### Primary Metaphor

The home screen is a vessel, not a dashboard.

The central object is a vertically oriented container that shows:

- current fill level
- today's pace line at the current time
- the next useful recovery action when behind

This should answer the user's real question in under one second:

> "Am I steady right now, and what is the easiest next step?"

### Information Hierarchy

The app should have one dominant idea per surface.

Home screen:

- a single calm status sentence at the top
- the vessel centered and oversized
- a small pace marker or target line
- three fast logging actions anchored near the thumb

Quick log sheet:

- default drink sizes first
- custom amounts secondary
- no dense beverage matrix

Reflection surfaces:

- one insight at a time
- tiny trend summaries
- no analytics wall

### Color System

Use a restrained mineral palette, not bright "wellness app" blue.

- `Chalk` `#F6F1E8`: primary background
- `Mist` `#E6EEED`: secondary surface wash
- `Mineral` `#91A5A3`: dividers, secondary labels, vessel outline
- `Tide` `#84C8D7`: primary water fill
- `Current` `#4E8DA0`: active water depth and pace emphasis
- `Ink` `#1F2932`: primary text

Rules:

- backgrounds should feel warm and quiet, never pure white
- water color should feel translucent and mineral, never neon aqua
- use color concentration to show state change, not rainbow badges or category overload
- red should be avoided for hydration lag; use softened slate or deepened water tones instead

### Material Treatment

Water should look physical but restrained.

Allowed:

- soft translucency
- a faint top-edge highlight on the waterline
- subtle depth shift between foreground fill and vessel background
- occasional light refraction in hero moments

Not allowed:

- cartoon droplets everywhere
- glossy skeuomorphism
- heavy glassmorphism blur
- decorative bubbles that compete with information

The user should feel the presence of water without the app performing "water theme" at them.

### Typography

Typography should feel literate and adult.

- Use `SF Pro Text` and `SF Pro Display` for core product UI because lock screen, widget, and watch readability matter more than novelty.
- Use `New York` sparingly for reflective moments, onboarding headlines, and weekly summaries where a touch of editorial calm adds warmth.

Rules:

- keep numerals large and stable
- avoid oversized all-caps labels
- prefer sentence-case copy
- use short status lines that sound grounded, not motivational

### Motion and Haptics

Motion should behave like liquid settling, not gamified celebration.

Rules:

- logging should raise the waterline with a short vertical motion and a soft settle
- reminder surfaces should fade or slide minimally, never bounce
- success states should brighten or steady the surface, not fire confetti
- when the user catches up, the app should feel relieved, not triumphant

Haptic direction:

- light impact for log confirmation
- soft notification for reminder acknowledgement
- no heavy celebratory patterns

### Iconography and Shapes

- Prefer rounded-rect and capsule geometry over circles as the dominant shape language.
- Use thin, quiet icon strokes with slightly softened corners.
- Avoid "fitness dashboard" icon density.
- Avoid mascot faces, expressive stickers, and collectible visual clutter.

### Copy Tone in UI

The copy should sound like a competent, gentle adult.

Use language like:

- "Steady."
- "One glass gets you back on pace."
- "A quieter afternoon starts here."
- "You recovered well today."

Avoid language like:

- "Goal missed"
- "Drink now"
- "Streak saved"
- "Only 23% left!"

## Screen-Level Applications

### 1. Home Screen

This is the signature surface and must carry the brand.

- large centered vessel
- pace line based on time of day
- one-sentence status
- quick-add buttons for the user's real container sizes
- optional small text for today's total, but never as the dominant element

This is where AquaMinder separates from ring-based hydration apps.

### 2. Recovery State

When behind pace, the UI should become slightly denser in water color but never punitive.

- show the gap in plain language
- recommend the smallest useful action
- visually suggest that recovery is still easy

The emotional goal is "recoverable," not "failing."

### 3. Reminder Surface

Reminders should be designed as a gentle interrupt.

- short sentence
- no alarm language
- no emoji or exclamation-driven urgency
- watch and widget versions should be as important as phone notifications

### 4. Weekly Reflection

Weekly reflection should feel like a quiet check-in, not a performance review.

- one headline insight
- one compact visual trend
- one sentence of reinforcement or adjustment

No scorecards.
No achievement cabinet as the center of gravity.

### 5. Widget and Watch

These are core surfaces, not accessory surfaces.

The visual language should translate into:

- a miniature vessel or waterline
- a clear current-state phrase
- extremely low tap friction

This matters because the research and category both show that hydration support works best when progress is ambient and glanceable.

## Anti-Directions

Do not ship any of the following:

- an activity-ring style main progress visualization
- mascot-led onboarding or home screens
- rainbow feature coloring
- dense dashboards with multiple cards competing for attention
- celebratory gamification as the primary retention mechanic
- pure-white medical UI with hard blue accents
- charts that dominate the main experience before the habit is formed

If a design exploration can be mistaken for WaterMinder, Plant Nanny, or a generic habit app from across the room, reject it.

## Implementation Guardrails For The CTO Review

The engineering plan should preserve these non-negotiables:

- the home surface is pace-first, not total-first
- the visual model is a vessel and waterline, not a ring
- quick logging must stay thumb-fast and obvious
- widget, lock screen, and watch are part of the main interaction loop
- motion and haptics must remain subtle enough to protect focus

## Next Handoff

This visual direction is now specific enough for `plan-eng-review`.

The CTO review should turn this into:

- screen architecture
- component inventory
- interaction states
- widget and watch scope
- implementation sequencing that protects the signature home screen first

## Source Notes

External references consulted on 2026-05-09:

- WaterMinder official site: `https://waterminder.com/`
- Plant Nanny official site: `https://sparkful.app/plant-nanny`
- Refreshly official site: `https://refreshly.app/`
- autoDrink official site: `https://autodrink-site.vercel.app/`
- H2Office paper: `https://www.shashankahire.com/assets/img/H2Office-Authors-Version.pdf`
