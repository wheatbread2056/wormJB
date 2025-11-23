# WormJB Documentation

> Complete technical overview of the WormJB project, covering the A-Shell automation scripts, the web UI, theming systems, persistence layer, and supporting utilities.

## Table of contents
1. [Project overview](#project-overview)
2. [Repository layout](#repository-layout)
3. [Getting started](#getting-started)
4. [Web application architecture](#web-application-architecture)
   - [Boot & theming pipeline](#boot--theming-pipeline)
   - [Layout & navigation](#layout--navigation)
   - [Feature sections](#feature-sections)
5. [Deep-dive: front-end code map](#deep-dive-front-end-code-map)
   - [Navigation & animation helpers](#navigation--animation-helpers)
   - [Modal & alert service](#modal--alert-service)
   - [Tweak data pipeline](#tweak-data-pipeline)
   - [Repo browser pipeline](#repo-browser-pipeline)
   - [Profile system](#profile-system)
   - [Theme & appearance controllers](#theme--appearance-controllers)
   - [Ambient audio manager](#ambient-audio-manager)
   - [Utility helpers](#utility-helpers)
6. [UI primitives & popups](#ui-primitives--popups)
7. [Building tweaks, repos, and modules](#building-tweaks-repos-and-modules)
8. [Extension playbook](#extension-playbook)
9. [Glass mode and visual customization](#glass-mode-and-visual-customization)
10. [Persistent data and local storage keys](#persistent-data-and-local-storage-keys)
11. [Ambient audio and console tooling](#ambient-audio-and-console-tooling)
12. [CLI/install scripts](#cliinstall-scripts)
   - [`jb/main.sh`](#jbmainsh)
   - [`jb/liquidra1n.sh`](#jbliquidra1nsh)
   - [`jb/loader` and Hookworm](#jbloader-and-hookworm)
   - [`tools/` utilities](#tools-utilities)
13. [Mobile configuration profile](#mobile-configuration-profile)
14. [Development workflow](#development-workflow)
15. [Troubleshooting checklist](#troubleshooting-checklist)

---

## Project overview
WormJB is a jailbreak-like experience that runs entirely inside the A-Shell / A-Shell Mini terminal on iOS. The project is split into two major parts:

- **Shell-based installer + tooling** (`jb/`, `tools/`): bootstraps a semi-rootless filesystem simulation, installs helper commands (`worm`, `wormjb`, `apt`), and deploys the Hookworm tweak loader.
- **Rich browser UI** (`index.html`, `assets/`): usable directly inside A-Shell7s WebView or any modern browser. It simulates common jailbreak UX elements, tweak management, repo browsing, and profile customization.

The repository intentionally avoids real iOS exploits. Everything runs in user space for experimentation and entertainment.

## Repository layout

| Path | Purpose |
| ---- | ------- |
| `README.md` | Quick-start requirements and basic FAQ for end users. |
| `index.html` | Single-page WormJB interface (HTML, CSS, JavaScript). Handles navigation, theming, data persistence, and tweak/repo management. |
| `assets/` | Static assets such as icons, banner art, and the standalone JS console (`console.html`). |
| `jb/main.sh` | Primary installer/updater invoked from the Shortcut. Sets up directories, installs tools, and calls Liquidra1n & Hookworm. |
| `jb/liquidra1n.sh` | Simulates creating/removing the semi-rootless environment under `~/Documents`. |
| `jb/loader/` | Hookworm tweak loader and module templates. |
| `tools/` | Helper commands copied to `~/Documents/bin` (APT shim, `worm`, `wormjb`, `ashellfetch`, etc.). |
| `docs/` | Long-form project documentation (this file). |

## Getting started

1. **Device requirements**: iOS/iPadOS 14.0.0+ with the [A-Shell](https://apps.apple.com/app/a-shell/id1473805438) or [A-Shell Mini](https://apps.apple.com/app/a-shell-mini/id1543537943) app.
2. **Install the Shortcut** for your chosen A-Shell flavor (links in `README.md`). The Shortcut downloads this repo into `~/Documents/wormJB` and launches `jb/main.sh`.
3. **Follow the terminal prompts**:
   - The script re-initializes the semi-rootless directories, installs Liquidra1n 2, Hookworm, and command shims.
   - Optionally opens `jb/WormJB.mobileconfig` in Safari so you can add the WormJB profile.
4. **Launch the UI**: from A-Shell, run `open index.html` or host the repo locally via a static server to interact with the web app portion.

Once installed, `wormjb` (in `~/Documents/bin`) exposes helper commands: `wormjb credits`, `wormjb help`, `wormjb revert`, etc.

## Web application architecture

### Boot & theming pipeline
- Before first paint, `index.html` runs an inline bootstrap script that reads `localStorage` to pre-set theme variables (`themeMode`, `customBg`, `accentColor`, etc.). This avoids light/dark flashes.
- CSS custom properties (prefixed with `--ios-*`) control colors, typography, and surface glass effects. Switching themes updates these variables globally.
- Major toggles persist using dedicated keys (see [Persistent data](#persistent-data-and-local-storage-keys)): theme mode, font choice, glass mode, tall tabs, ambient sound, etc.

### Layout & navigation
- **Header**: fixed at the top, shows the WormJB title, current version token, and a profile button that reflects the user7s preferred mode (Icon vs Button).
- **Version bar**: a slim banner under the header echoes `APP_VERSION` for quick reference.
- **Main area**: houses all sections (`<section id="home">`, `#tweaks`, `#tweakBrowser`, `#repoItems`, `#profile`, `#settings`, `#devsettings`). Only one section is visible at a time.
- **Tab bar**: persistent bottom navigation with `Tweaks`, `Home`, `Settings`, plus a dynamically-added `Dev` tab once developer settings are unlocked.

### Feature sections
**Home**
- Welcome card greets the stored profile name and exposes CTA buttons: Remove Jailbreak (alert), Install SideStore, Open GitHub Repo, Show Script (opens `jb/main.sh` on GitHub), Open Terminal via `ashell://`, Mystery button (playful alert), and Copy WormJB Device Hash.
- Status card lists sandbox indicators with color-coded pills.

**Tweaks**
- Displays locally stored tweaks from `wormjb_tweaks_v1` with animated cards. Each entry shows name, description, author, version, date, and an ID badge.
- Toggles change `enabled` state and, when turning on, can run stored `onEnable` JavaScript via `new Function(...)` (browser-side actions like opening IPAs or websites).
- **Dev-only controls** (visible after `devUnlocked=true`): gear icons launch a modal editor enabling full CRUD over tweak metadata.
- `Add Tweak` seeds a stub entry and immediately opens the editor.
- `Browser` jumps to the Repo browser.

**Tweak Browser / Repo Items**
- `getAllRepos()` loads user-defined repos from `localStorage` and auto-injects two local demo repos ("FAKE TWEAKS" and "brainworm's repo") to guarantee content.
- Repo rows inherit the repo7s background color and show icon + description.
- Selecting a repo populates `#repoItemsList` with multi-type entries (tweaks vs apps) and filter buttons (All/Tweaks/Apps).
- `Add Repo` modal accepts either a JSON URL or pasted JSON array (fields: `type`, `name`, `desc`, `ver`, `date`, `author`, `bg`).

**Profile**
- Hero panel mirrors Apple7s identity cards. Users can change display name, switch between Icon vs Button header modes, and upload a custom avatar (stored as data URL in `wormjb_profile_v1`).
- Changes reflect immediately across header, hero, and welcome text.

**Settings**
- Toggles for logs, auto-update, developer settings access.
- **Appearance**: theme selector (system/light/dark), custom background color, accent picker, font selector (System/Inter/Other), Glass Mode toggle, ambient sound toggle, Tall Tabs toggle.
- **System Info**: shows Safari user agent info on mobile, or a "Testing Mode" panel with curated copy on desktop.
- **Credits**: acknowledges contributors, license tagline, and surfaces version info.

**Developer Settings**
- Verbose/external toggles, "Force Apple Font", quick actions: Clear App Data (removes local/session storage, caches, service workers), Disable Dev Mode, Reload App, Export/Import `.wormdata`, Open JS Console.
- Export includes a JSON dump of localStorage; import rehydrates those entries before reloading.

## Deep-dive: front-end code map
The entire web experience lives in `index.html`. There is no build step, so understanding the inline functions is the fastest path to shipping fixes. Below is a roadmap grouped by responsibility.

### Navigation & animation helpers
| Function | Purpose | How to extend |
| --- | --- | --- |
| `switchTab(target)` | Activates the tab + section matching `data-tab` and triggers enter animation. | Call this when you add new navigation affordances (e.g., a CTA that should open `settings`). Make sure the section has an `id` that matches the tab `data-tab`. |
| `playSectionEnter(section)` | Adds/removes the `section-enter` class so sections fade/slide on entry. Honors `prefers-reduced-motion`. | If you add new sections, you automatically get the animation because `switchTab` calls this helper. |
| `prepareAnimatedListItem(el, index)` | Staggers list animations via the CSS variable `--stagger-index`. | Call this on any repeated element (cards, repos) to keep the iOS-like cascade. |
| `shouldReduceMotion()` | Wraps the media query for reduced-motion. | Use this guard around any new animation you add. |

### Modal & alert service
| Function | Purpose | Notes |
| --- | --- | --- |
| `showModal(el)` / `hideModal(el)` | Generic presenters for `.ios-alert` blocks. Toggle `visible`/`closing` classes, handle transition cleanup, and prevent rapid reopen glitches by forcing reflow. | Reuse these for any new modal markup: create a `<div class="ios-alert" id="myModal">...</div>` and call `showModal(document.getElementById('myModal'))`. |
| `showAlert(message)` | Convenience wrapper for the stock "one button" popup living in `#alert`. Updates `#alert-text` and calls `showModal`. | Use this whenever you need an iOS-style heads-up. To change the primary button, edit the HTML under `<div id="alert" class="ios-alert">`. |
| `hideAlert()` | Hides `#alert` via `hideModal`. | Wire additional buttons to `hideAlert` as needed. |

**Changing alert buttons:**
1. Open `index.html`, locate the `#alert` block near the end of the `<body>`.
2. Replace the existing button markup with your preferred layout (e.g., two buttons side-by-side, destructive vs default styles). Buttons already inherit `.ios-button` appearances—swap classes or add inline styles to differentiate colors.
3. Point each button at `hideAlert()` or a custom handler: `<button class="ios-button" onclick="myHandler();">Allow</button>`.
4. If you want to pass dynamic labels, upgrade `showAlert` to accept an object:
    ```js
    function showAlert(opts) {
       const { message, confirmLabel = 'OK', onConfirm = hideAlert } = typeof opts === 'string'
          ? { message: opts }
          : opts;
       alertConfirmBtn.textContent = confirmLabel;
       alertConfirmBtn.onclick = () => { onConfirm(); hideAlert(); };
       alertText.textContent = message;
       showModal(alertBox);
    }
    ```
    This tiny change lets you configure buttons per call without rewriting markup.

### Tweak data pipeline
| Function | Description |
| --- | --- |
| `defaultTweaks()` | Seed data used when `wormjb_tweaks_v1` is empty/corrupted. Edit this when you want baked-in tweaks on a fresh install. |
| `loadTweaks()` / `saveTweaks(tweaks)` | Thin wrappers over `localStorage`. All tweak mutations funnel through these helpers. |
| `renderTweaks()` | Generates the cards, toggle switches, ID tag, and optional dev gear button. Calls `prepareAnimatedListItem` for each row. |
| `openTweakEditor(idx)` / `closeTweakModal()` | Populate + hide the edit modal. `currentEditIndex` tracks which tweak is being edited. |
| `resolveTweakBg(color)` | Adjusts tweak card backgrounds in dark mode by inverting the brightness while preserving hue. |

**Where to hook custom behavior:**
- Toggle side effects live inside the `checkbox.addEventListener('change', ...)` block. If you need to run extra logic (analytics, remote requests) whenever a tweak is toggled, add it there after `saveTweaks(ts)`.
- To inject new per-tweak UI (e.g., a "Configure" button), modify `renderTweaks` and append DOM nodes to `right` or `left` before calling `container.appendChild(item)`.

### Repo browser pipeline
| Function | Description |
| --- | --- |
| `loadRepos()` / `saveRepos()` | Persistence helpers backed by the `wormjb_repos_v1` key. |
| `getDefaultLocalRepo()` / `getAllRepos()` | Guarantee that "FAKE TWEAKS" and "brainworm's repo" always appear by injecting them when absent. |
| `renderReposList()` | Builds the repo cards and attaches handlers for "Open" / "Delete". Also demonstrates how to use `prepareAnimatedListItem` outside the tweaks list. |
| `openRepo(id)` | Sets `currentRepoId`, resets the filter to `all`, and navigates to `#repoItems`. |
| `renderRepoItems()` | Applies the active filter, paints entries, and wires the per-item "Install" button which copies repo items into the tweak list. |
| `showAddRepoModal()` / `hideAddRepoModal()` + confirm handler | Drive the repo creation modal. Fetches JSON if a URL is provided, normalizes entries, and persists them. |

### Profile system
| Function | Description |
| --- | --- |
| `loadProfile()` / `saveProfile(profile)` | Manage `wormjb_profile_v1`. |
| `applyProfileToHeader()` | Syncs the stored name/icon/mode to the header, profile hero, and welcome text. Call this after any action that should refresh the identity. |
| `renderProfileDisplayMode(mode)` | Applies Icon vs Button presentation to the header control, including tooltip, image size, and button label visibility. |
| File upload IIFE | Converts an uploaded image to a data URL, stores it, then re-applies the profile so the UI updates instantly. |

### Theme & appearance controllers
- `applyTheme()` is the master switch. It reads `themeMode`, `customBg`, `accentColor`, `glassMode`, `tabsNotch`, `themeFontChoice`, etc., updates CSS variables, and re-renders tweaks/repos to adopt any per-item background tweaks.
- `syncDocumentFont()`, `ensureInterLoaded()`, and `setForceAppleFont()` cooperate to inject the Inter font from Google Fonts when required.
- `applyTabHeight(enabled)` toggles `.tabs.tall` and adjusts `main` padding depending on whether glass mode is active.
- `injectDarkCSS()` appends a `<style>` block at runtime so dark mode overrides stay scoped to `.dark`.

### Ambient audio manager
- `isMusicEnabled()`/`setMusicEnabled()` store the users preference and pause/resume audio accordingly.
- `requestMusicPlayback()` handles iOS autoplay restrictions by attaching temporary `pointerdown`/`keydown` listeners until playback succeeds.
- `syncMusicUI()` updates button labels and toggle state so the UI mirrors the actual audio element.
- `setupAmbientAudio()` (IIFE) loads `assets/test 104.mp3`, loops it, and wires the CTA button plus event listeners that keep `syncMusicUI` in sync.

### Utility helpers
- **System info**: `renderSystemInfo()` inspects `navigator.userAgent` or `navigator.userAgentData` to decide between the System Info grid and the Testing Mode banner.
- **Data export/import**: `exportDataBtn` / `importDataBtn` listeners serialize/restore the entire `localStorage` namespace.
- **Device hash**: `getDeviceHash()` (declared further down) plus `setupCopyHash()` provide a reusable fingerprint for support requests.
- **Console launcher**: `openConsole()` simply `window.location.href = 'assets/console.html'` so you can debug inline without cluttering the main file.

## UI primitives & popups
Creating "iOS-looking" UI consistently revolves around a few reusable building blocks:

### `.ios-card`
- Rounded, subtly shadowed container used for every major section. Drop new content inside `<div class="ios-card">...</div>` to match the aesthetic.
- Cards stack vertically inside each section, so try to keep each card focused on a single responsibility (settings list, profile hero, etc.).

### `.ios-list` + `.ios-list-item`
- Mimic grouped settings tables. Use `.ios-list` as the wrapper, and place `.ios-list-item` for each row. Add `display:flex` helpers inline for custom layouts.
- Hover and active states are already defined. Keep rows flexible by leveraging `justify-content: space-between` and `align-items: center` for quick 2-column designs.

### `.ios-button`
- Primary action pill. Add `.danger` or `.magenta` for alternative colors. Buttons automatically pick up accent color overrides when you change `--ios-blue`.

### `.ios-switch`
- Wraps a native checkbox and draws the slider (with `.slider:before`). Reuse this pattern anywhere you need toggles. Remember to read/write the underlying checkbox state.

### `.ios-alert` (modal)
- Base style for every popup or modal. The stock alert uses this component, as do the tweak editor and add-repo modal.
- Structure guidelines:
   ```html
   <div id="myModal" class="ios-alert">
      <h3>Title</h3>
      <p>Body copy...</p>
      <div class="modal-actions">
         <button class="ios-button">Primary</button>
         <button class="ios-button danger">Cancel</button>
      </div>
   </div>
   ```
   Then call `showModal(document.getElementById('myModal'))` to present it.

### Stock alert (`showAlert`)
- Ideal for quick confirmations, error banners, or success toasts. If you need multiple buttons, expand the HTML as described above or pass callbacks into an enhanced `showAlert`.
- Example: change the default button copy to "Close" by editing `<button class="ios-button" onclick="hideAlert()">OK</button>`.

### Custom popups/questions
To prompt users with Yes/No choices:
1. Duplicate the `#alert` block, rename it to `#confirmAlert`, and include two `<button>` elements (e.g., `Confirm` and `Cancel`).
2. Write a helper:
    ```js
    function confirmAction({ message, onConfirm }) {
       const box = document.getElementById('confirmAlert');
       box.querySelector('.confirm-copy').textContent = message;
       const confirmBtn = box.querySelector('[data-role="confirm"]');
       confirmBtn.onclick = () => { hideModal(box); onConfirm?.(); };
       showModal(box);
    }
    ```
3. Call `confirmAction({ message: 'Install tweak?', onConfirm: install })` anywhere.

## Building tweaks, repos, and modules

### Tweak object schema (front-end)
```ts
type Tweak = {
   id: string;              // unique identifier, usually tweak.slug
   name: string;
   description: string;
   author: string;
   version: string;
   date: string;            // YYYY-MM-DD
   bg: string;              // any CSS color; used for card background
   enabled: boolean;
   onEnable?: string;       // JS snippet executed when toggled on
   enableConfirmationPrompt?: string;
   disableConfirmationPrompt?: string;
};
```

### Adding a tweak (UI method)
1. Click **Add Tweak** inside the Tweaks tab. This seeds `tweak.<timestamp>` with placeholder data and opens the editor.
2. Fill in fields for name, ID, description, author, semantic version, date, and card color.
3. Optional: paste JS inside **onEnable (JS code)**. This runs inside a new `Function` scope, so you can call `window.open`, modify DOM, trigger alerts, etc. Wrap everything in an IIFE if you need asynchronous logic.
4. Save. The tweak persists to `wormjb_tweaks_v1`.

### Adding a tweak (code method)
```js
const tweaks = loadTweaks();
tweaks.unshift({
   id: 'tweak.example.respring',
   name: 'Example Respring',
   description: 'Demo entry added via script',
   author: 'you',
   version: '0.0.1',
   date: '2025-11-22',
   bg: '#fef3c7',
   enabled: false,
   onEnable: "showAlert('Pretend respring triggered.');"
});
saveTweaks(tweaks);
renderTweaks();
```

### Developing repo content
- Each repo entry mirrors the tweak schema but also stores `type: 'tweak' | 'app'` so the filter buttons work.
- Use the **Add Repo** modal to import JSON from a URL (`https://example.com/repo.json`) or paste raw JSON.
- The confirm handler slugifies names into `repoId = slugifyName(name)` so keep names unique. To edit an existing repo, load from `localStorage`, change the data, and call `saveRepos(newArray)`.

### Hookworm modules (shell side)
1. Drop a script into `jb/loader/modules/` (e.g., `respring.sh`).
2. Run `jb/main.sh` again or call `hookworm.sh install` to copy modules into `~/Documents/wormJB/hookworm/` and expose them to the `hookworm` command.
3. Modules are plain shell scripts—use them to implement real actions triggered by tweak toggles. For example, your tweaks `onEnable` JS could call `window.location.href = 'ashell://hookworm respring'` to invoke a CLI module.

## Extension playbook
Use this checklist whenever you need to ship an update without re-vibecoding the entire file.

### Task: add a new CTA button on the Home card
1. Locate the `<div class="ios-list">` under `#home` by searching for `id="removeJBBtn"`.
2. Duplicate one of the existing `<div class="ios-list-item">` blocks.
3. Give the button a new `id` (e.g., `openDocsBtn`).
4. Scroll down to the `wireButtons()` helper and add:
    ```js
    const docsBtn = document.getElementById('openDocsBtn');
    if (docsBtn) docsBtn.addEventListener('click', () => window.open('docs/WormJB_Documentation.md', '_blank'));
    ```

### Task: show an iOS-style popup with custom text + buttons
1. Edit the `#alert` block and add additional buttons or icons.
2. Change `showAlert` to accept an options object as described earlier, or create a new helper such as `showTwoButtonAlert(opts)` that swaps button text and handlers before calling `showModal`.
3. Reuse `.ios-button danger` for destructive paths and `.ios-button` for defaults.

### Task: add a brand-new section
1. Inside `<main>`, append `<section id="mySection">...</section>` with cards/lists.
2. Duplicate one of the existing `.tab` divs inside `<nav class="tabs">` or programmatically add one (see `showDevTab`). Set `data-tab="mySection"`.
3. Either add the tab statically or append it with JS using the same pattern as `showDevTab`. Once the user clicks it, `switchTab('mySection')` handles the rest.

### Task: wire a new modal
1. Add a `<div class="ios-alert" id="myModal">` near the end of `<body>`.
2. Create helper functions:
    ```js
    const myModal = document.getElementById('myModal');
    document.getElementById('openMyModalBtn').addEventListener('click', () => showModal(myModal));
    myModal.querySelector('[data-role="close"]').addEventListener('click', () => hideModal(myModal));
    ```
3. Use `.modal-actions` for inline button spacing or roll your own with flexbox.

### Task: debug or tweak data
- Use the built-in JS console (`assets/console.html`) to inspect `localStorage`, run `loadTweaks()` manually, or prototype new UI interactions before copying them into the main file.

---

## Glass mode and visual customization
- `html.glass-mode` applies frosted-glass styling across header, lists, cards, tabs, and alerts using translucent gradients, border overlays, and blur filters.
- Toggling Glass Mode updates the `--glass-surface`, `--glass-border`, and `--glass-shadow` variables (separate profiles for light/dark).
- In glass mode, `main` runs beneath the translucent header (with compensating padding) so underlying cards remain visible through the bar.
- Tall Tabs toggle (`tabsNotch`) increases tab height and adds extra bottom padding to avoid notches.
- Accent color updates `--ios-blue` and `--ios-blue-rgb`, influencing buttons, pills, and gradients.

## Persistent data and local storage keys
| Key | Purpose |
| --- | ------- |
| `wormjb_tweaks_v1` | Array of tweak/app objects (id, name, desc, author, version, date, bg, enabled, optional prompts, optional `onEnable` code). |
| `wormjb_repos_v1` | User-managed repo definitions with metadata and item arrays. Defaults are injected if not present. |
| `wormjb_profile_v1` | User profile (display name, avatar data URL, display mode). |
| `devUnlocked` | Enables the Developer tab and controls dev-only UI. |
| `themeMode` | Stores `system`, `light`, or `dark`. |
| `customBg` | Hex color for background override. |
| `accentColor` | Custom accent hex; influences `--ios-blue`. |
| `themeFontChoice` / `themeFontOther` | Tracks System/Inter/Other font choices. |
| `forceAppleFont` | Forces Inter stack for an Apple-like aesthetic. |
| `glassMode` | `true`/`false` toggle for frosted surfaces. |
| `musicEnabled` (plus legacy `musicDisabled`) | Controls ambient audio playback. |
| `tabsNotch` | Tall tab preference. |
| `wormjb_console_history` & `wormjb_console_theme` | State for the standalone JS console. |
| Misc. | Export/import features may temporarily add additional keys when syncing data.

## Ambient audio and console tooling
- **Ambient sound**: `musicEnableToggle` drives local audio playback through `#bgAudio`. Playback waits for user interaction to satisfy iOS media policies.
- **JavaScript console** (`assets/console.html`): full-screen web console with history, timers, a mini file manifest browser, and support for generating `.mobileconfig` files on the fly. Launch via Developer Settings 2Open JS Console2 or repo items pointing to `assets/console.html`.

## CLI/install scripts

### `jb/main.sh`
1. Prints installer version and ensures `~/Documents/.wormjbver` reflects the current release.
2. Removes stale state, shows playful progress output, and installs a custom `neofetch` shim (`tools/ashellfetch.sh`).
3. Ensures Liquidra1n is executable and executes it to set up the semi-rootless directory tree under `~/Documents`.
4. Cleans previous `~/Documents/bin/{apt,worm,wormjb}` binaries.
5. Installs Hookworm (`jb/loader/hookworm.sh install`) which copies tweak modules into `~/Documents/wormJB/hookworm` and exposes a `hookworm` command.
6. Copies helper scripts from `tools/` to `~/Documents/bin/`.
7. Offers to open `jb/WormJB.mobileconfig` in Safari for optional profile installation.
8. Runs `neofetch` (customized) and prints final instructions, including `wormjb revert` for uninstalling.

### `jb/liquidra1n.sh`
- Simulates enabling/disabling security daemons and sets up (or tears down) a semi-rootless filesystem structure within the user documents directory.
- Creates directories such as `var`, `usr`, `System`, `Library`, etc., plus nested placeholders (`var/jb`, `var/liquidra1n`, `var/apple/piss`).
- `liquidra1n.sh uninstall` reverses the process, removing those directories and cleaning up.

### `jb/loader` and Hookworm
- `hookworm.sh` installs the tweak loader by copying itself to `~/Documents/bin/hookworm`, preparing `~/Documents/wormJB/hookworm/modules`, and staging bundled modules from `jb/loader/modules/` (currently a demo `test.sh`).
- `hookworm init` provides a placeholder command hook; build additional modules by dropping scripts into `jb/loader/modules/` and re-running the installer.

### `tools/` utilities
| Script | Installed as | Purpose |
| ------ | ------------- | ------- |
| `tools/ashellfetch.sh` | `neofetch` | Customized system info display for A-Shell (ASCII art, WormJB version). |
| `tools/apt.sh` | `apt` | Simple shim that forwards arguments to `pkg`. |
| `tools/worm.sh` | `worm` | Placeholder command that prints "im worming it" (example hook point). |
| `tools/wormjb.sh` | `wormjb` | User-facing CLI with `credits`, `help`, `cydia` (placeholder), and `revert` to uninstall everything. |

## Mobile configuration profile
- `jb/WormJB.mobileconfig` is distributed so users can install a profile/web clip that links back to the WormJB tooling.
- During installation (`main.sh`), the script can open the raw GitHub URL in Safari; users approve the profile inside iOS Settings.
- The JS console also contains a small mobileconfig generator for ad-hoc profiles.

## Development workflow
1. **Serve or open `index.html`** locally in a desktop browser for rapid development. The UI works without any backend.
2. **Testing glass mode**: flip `glassModeToggle` or set `localStorage.setItem('glassMode','true')` from DevTools to preview frosted surfaces.
3. **Simulate tweaks/repos**: edit `defaultTweaks()` / `REPO_ITEMS` in `index.html`, or modify localStorage via the console to test dynamic content.
4. **Validate scripts**: run `sh jb/main.sh` from a POSIX shell (macOS/Linux) to ensure no syntax errors before shipping.
5. **Profile assets**: drop new images into `assets/` and update references accordingly. Remember to keep file sizes small for A-Shell environments.
6. **Contribute modules/tools**: add a script in `jb/loader/modules/`, ensure it7s executable, and update documentation/README so installers know about new functionality.

## Troubleshooting checklist
- **Installer says wormJB already installed**: remove `~/Documents/.wormjbver` or run `wormjb revert`, then rerun the Shortcut.
- **Hookworm command missing**: ensure `~/Documents/bin` is in `$PATH` inside A-Shell (`export PATH=$HOME/Documents/bin:$PATH`). Re-run `jb/main.sh` if necessary.
- **Glass mode looks opaque**: confirm `glassMode` is `true` in `localStorage` and that you7re not forcing a custom solid background color.
- **Tweaks not saving**: Inspect `wormjb_tweaks_v1` via DevTools or the JS console; invalid JSON will be reset to defaults.
- **Ambient sound doesn7t start**: iOS requires a user gesture. Tap anywhere or toggle the Ambient Sound switch again after interacting.
- **Developer tab missing**: `Settings → Developer Settings` prompt stores `devUnlocked=true`. Clear app data to reset.
- **Uninstall completely**: run `wormjb revert` to remove binaries and semi-rootless directories, then delete `wormJB` from `~/Documents`.

---
_Last updated: 22 Nov 2025_
