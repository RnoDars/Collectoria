```markdown
# Design System Document: The Curated Gallery

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Curator"**

This design system rejects the "database-entry" aesthetic of traditional collection apps. Instead, it adopts a high-end editorial approach, treating every user's collection as a museum-grade exhibit. We move beyond the "template" look by utilizing intentional asymmetry, tonal depth, and high-contrast typography scales. 

The goal is to provide a sense of **quiet authority**. We achieve this through "breathing room" (generous whitespace) and a departure from rigid structural lines. By removing borders and relying on tonal shifts and soft layering, the interface feels less like a software tool and more like a physical, frosted glass gallery.

---

### 2. Colors & Surface Logic

Our palette centers on a sophisticated "Royal Amethyst" spectrum, balanced by a neutral foundation that mimics the clean walls of a contemporary art space.

#### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders to section off content. Traditional lines create visual noise and "trap" the eye. Instead, define boundaries through:
- **Background Shifts:** Place a `surface-container-low` section against a `surface` background.
- **Tonal Transitions:** Use subtle shifts in the surface-container tiers to denote hierarchy.

#### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following tiers to create "nested" depth:
- **Base Level:** `surface` (#f8f9fa) – The gallery floor.
- **Sectioning:** `surface-container-low` (#f3f4f5) – To group related categories.
- **Primary Elements:** `surface-container-lowest` (#ffffff) – For cards and interactive elements that need to pop.
- **Active States:** `surface-container-highest` (#e1e3e4) – For pressed or selected states.

#### The "Glass & Gradient" Rule
To elevate the experience, the primary brand gradient (#667eea to #764ba2) should rarely be used as a flat background. Instead:
- **Hero CTAs:** Use the gradient with a subtle 15-degree angle.
- **Glassmorphism:** For floating navigation or modals, use `surface` at 70% opacity with a `24px` backdrop-blur. This ensures the collection colors bleed through the UI, making the app feel alive and integrated.

---

### 3. Typography: Editorial Authority

We use a "Dual-Type" system to balance professional curation with approachable utility.

*   **Display & Headlines (Manrope):** This is our "Editorial" voice. Use `display-lg` through `headline-sm` to create a bold, confident hierarchy. The geometric nature of Manrope provides a modern, premium feel.
*   **Body & Labels (Inter):** This is our "Utility" voice. Inter provides maximum legibility for metadata, descriptions, and system feedback.

**Typographic Hierarchy Note:**
Always pair a `headline-md` (Manrope) with a `body-md` (Inter). The high contrast between the two font families signals to the user exactly where the "Story" (the collection title) ends and the "Data" (the item details) begins.

---

### 4. Elevation & Depth: Tonal Layering

We avoid the "floating card" cliché by using **Tonal Layering** rather than heavy shadows.

*   **The Layering Principle:** Place a `surface-container-lowest` card on top of a `surface-container-low` background. This creates a "soft lift" that feels architectural rather than digital.
*   **Ambient Shadows:** If a card must float (e.g., a dragged item), use a custom shadow: `0px 12px 32px rgba(25, 28, 29, 0.06)`. The shadow color is a tinted version of `on-surface`, ensuring it looks like natural ambient light.
*   **The Ghost Border:** If accessibility requires a container boundary, use `outline-variant` (#c5c5d5) at **15% opacity**. It should be felt, not seen.

---

### 5. Components

#### Buttons
*   **Primary:** A gradient fill (`primary` to `primary-container`) with `on-primary` text. Use `xl` (1.5rem) roundedness for a pill-like, premium feel.
*   **Secondary:** `surface-container-high` background with `primary` text. No border.
*   **Tertiary:** Transparent background with `primary` text. Use for low-emphasis actions.

#### Cards & Collection Items
*   **The Rule:** No dividers. Use `md` (0.75rem) spacing to separate metadata points.
*   **Layout:** Use asymmetrical layouts for collection previews—alternate between large image focus and detail-heavy cards to keep the user engaged.
*   **Radius:** Always use the `lg` (1rem / 16px) or `xl` scale for cards to maintain the "Collectoria" signature softness.

#### Data Visualization: Progress Bars
*   **Track:** `surface-container-highest`.
*   **Indicator:** The signature purple gradient.
*   **Refinement:** Add a subtle inner-glow to the indicator to make the progress feel like a liquid "energy" bar.

#### Input Fields
*   **State:** Use `surface-container-low` for the default background.
*   **Focus:** Transition to `surface-container-lowest` with a `primary` 2px bottom-accent only. Avoid full-box focus rings.

#### Custom Component: "The Curator’s Lens"
A specialized filter chip that uses Glassmorphism. When active, it uses the `secondary` color at 20% opacity with a saturated `on-secondary-container` text color, blurring the content beneath it.

---

### 6. Do’s and Don’ts

#### Do:
*   **Do** use asymmetrical margins (e.g., 24px left, 32px right) for header sections to create an editorial, magazine-like feel.
*   **Do** use `display-lg` typography for empty states or welcome screens to lean into the brand's bold personality.
*   **Do** use vertical white space (from the Spacing Scale) as your primary separator.

#### Don’t:
*   **Don’t** use 1px solid borders for anything other than high-contrast accessibility needs.
*   **Don’t** use pure black (#000000) for text. Always use `on-surface` (#191c1d) to maintain tonal softness.
*   **Don’t** overcrowd the screen. If you can’t fit it with "generous whitespace," it belongs on a different layer or a nested surface.
*   **Don’t** use standard "drop shadows." If a component needs elevation, use the Tonal Layering logic first.

---

**Director’s Final Note:**
The beauty of this system lies in its restraint. Let the user's collection provide the color; our UI provides the elegant, quiet frame. When in doubt, add more whitespace and remove a line.```