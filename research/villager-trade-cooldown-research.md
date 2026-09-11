# Minecraft Villager Trade Restock/Cooldown Tracking: Research Report
*Generated: 2026-09-11 | Sources: 6 web sources (WebSearch/WebFetch, no firecrawl/exa MCP configured) | Confidence: Medium*

## Executive Summary
Vanilla Minecraft villagers don't use a fixed "cooldown timer" for trade restocking — restocking is tied to the villager **working at its job-site block during work hours**, up to twice per game day, not a countdown you can read directly from NBT. This means a datapack **cannot show an exact countdown** the way you'd picture it (e.g. "0:04:12 until this trade resets") unless we build our own tracked/simulated cooldown system rather than reading a native "time left" value from the game, because vanilla doesn't expose one. A pure datapack (no mod) *can* read a trade's `maxUses`/`uses` NBT via `/data get`, react to it with `execute` + scoreboard, and display a HUD via **actionbar, bossbar, title, or a sidebar scoreboard** — all fully achievable without a mod. Building "real custom NPCs" (not villagers) with client-visible custom trade GUIs, however, is outside pure datapack scope and needs a mod or a resource-pack-assisted trick.

## 1. How vanilla trade limits & restocking actually work
- A trade becomes locked once its `uses` count reaches `maxUses`. `maxUses` "is the maximum number of times a trade can be used before it is disabled, and it increases by a random amount from 2 to 12 when offers are refreshed" ([Craftdex — Villager Trade Restocking](https://craftdex.net/articles/villager-trade-restocking)).
- Restocking happens through **work**, not a clock: "Two times a day, working resupplies any locked trades, even without having a bed or while sitting in a minecart" ([Minecraft Wiki — Villager](https://minecraft.wiki/w/Villager)).
- There is a demand/price-adjustment system layered on top: "Demand is a price adjuster of the first 'cost' item, updated when a villager resupplies. Each time a trade is locked and requires a restock, the price will increase when it next returns. Similarly, a trade that does not sell out by the next restock will lower in price" ([Craftdex](https://craftdex.net/articles/villager-trade-restocking)).
- There's an anti-spam guard on restocks: a `RestocksToday`-type counter and a rule that "when a villager has restocked twice in less than 10 minutes, it waits at least 10 minutes for another restock" ([Craftdex](https://craftdex.net/articles/villager-trade-restocking)). This wasn't independently corroborated on a second source — flagging as **single-source, moderate confidence**.

**Implication for the idea:** there is no vanilla "time remaining" field to read. "Restock" fires opportunistically whenever the villager's AI decides to go work — which itself depends on the day/night schedule, whether a workstation is claimed, pathing, and whether the villager is free (not sleeping, not fleeing, etc.). Any countdown we show players would have to be a **datapack-simulated cooldown** (a timer we invent and enforce ourselves) rather than a readout of an actual vanilla mechanic — see Concept B in the brainstorming step.

## 2. Reading trade data from a datapack (confirmed feasible)
- Trade data lives under the villager's `Offers.Recipes` NBT list. Each entry has `buy`, optional `buyB`, `sell`, and `maxUses` ("how many times the trade can be used") ([DigMinecraft — Villager NBT tags](https://www.digminecraft.com/data_tags/villager_pc_1_11.php); [arktimes — Changing trade offers with data commands](https://2fwww.arktimes.com/how-to-change-a-villagers-trade-offers-with-data-commands-in-minecraft/)).
- You can inspect it directly: `/data get entity <selector> Offers.Recipes`.
- Newer versions (1.14+) add an active-use counter and economy fields alongside `maxUses` — general Minecraft knowledge (uses, demand, specialPrice, priceMultiplier, rewardExp/xp) — but I could **not** find a citable, current source confirming the exact modern tag spelling for all of them; the sources I fetched only document the older (1.11/1.12) tag set. **Flag: verify exact 1.20/1.21 tag names in-game with `/data get` before relying on this in code**, rather than trusting either version of documentation blindly.
- To pull a specific number out of NBT and into game logic/display, the standard pattern is `execute store result score <target> <objective> run data get entity <selector> Offers.Recipes[<index>].uses` (per general command-syntax knowledge; not directly confirmed by a fetched source, but consistent with vanilla `execute store` semantics that were confirmed to exist and be usable this way in the search results on scoreboard-based NBT tracking).

## 3. Feasible player-facing UI, pure datapack (no mod)
All confirmed as real, shipped datapack patterns from working examples found:
- **Actionbar timer**: "Animated Timer" datapack adds an in-game timer via the actionbar with configurable display ([Modrinth — Level Timer](https://modrinth.com/datapack/level-timer)).
- **Bossbar timer**: "Boss Bar Timer" datapack shows a countdown as a bossbar to all players ([PlanetMinecraft — Boss Bar Timer](https://www.planetminecraft.com/data-pack/boss-bar-timer/)); a combined floating-text + bossbar timer exists too ([GitHub — Dennis-0/Timer](https://github.com/Dennis-0/Timer)).
- **Per-entity bossbar**: "Dynamic Bossbars" ties a bossbar instance to a specific entity rather than the whole world, auto-removing it when the entity dies/unloads ([GitHub — Daridon6024/dynamic_bossbars](https://github.com/Daridon6024/dynamic_bossbars)) — directly relevant, since we'd want a bar/label tied to *this specific villager*, not global.
- Scoreboard sidebar and `tellraw` hover-text are standard vanilla features (general knowledge, not separately re-verified here) and commonly combined with the above.

**No source found or needed for confirmation that a pure datapack cannot draw a custom GUI window** — this is a well-known, uncontested vanilla limitation: datapacks are data/logic only, they cannot add custom screens/GUIs. Any "menu"-style trade UI (not just a HUD overlay) requires a resource pack (repurposing existing GUI textures, e.g. villager trade screen or a book/sign) or a mod (Forge/Fabric) for a real custom screen.

## Key Takeaways
- **Vanilla has no native countdown to read** — restock is event-driven (villager does its job) not timer-driven, and is gated by workstation access, day/night schedule, and a "twice per day, ≥10 min apart" throttle (this last detail single-sourced, verify in-game).
- **A datapack absolutely can**: read `maxUses`/uses via `/data get`, track it per-villager in scoreboards/NBT storage, and show players a HUD (actionbar, per-entity bossbar, or scoreboard sidebar) — all without a mod. This is proven by multiple existing shipped datapacks doing exactly this style of thing for generic timers.
- **The realistic product to build is a simulated cooldown**, not a readout of true vanilla internals: e.g., datapack detects "this trade just got used" (uses increased), stamps a gametime, and then *we* define + display "time until this villager is next eligible to restock" based on our own rule (e.g., next work-hour window), rather than pulling a ground-truth number Mojang doesn't expose.
- Custom NPCs with a genuinely custom trade GUI (not reusing the villager trade screen) need a mod, not a pure datapack.

## Gaps / Not Verified
- Exact modern (1.20/1.21) NBT tag names for `uses`, `demand`, `specialPrice`, `priceMultiplier`, `rewardExp`/`xp` — need in-game `/data get` verification before coding against them.
- The "10-minute throttle between restocks" and `RestocksToday`-style tracking — single source (Craftdex), not cross-verified against a second independent source.
- Exact `execute store result score ... run data get ...` syntax for indexed NBT list access — not pulled from a fetched primary source in this pass, though it's standard, well-established vanilla command syntax.

## Sources
1. [Villager – Minecraft Wiki](https://minecraft.wiki/w/Villager) — official wiki, confirms restock is tied to working twice/day.
2. [Villager Trade Restocking — Craftdex](https://craftdex.net/articles/villager-trade-restocking) — maxUses growth range, demand/price mechanic, restock throttle.
3. [NBT Tags for Villager (Java 1.11/1.12) — DigMinecraft](https://www.digminecraft.com/data_tags/villager_pc_1_11.php) — Offers/Recipes structure (buy, buyB, sell, maxUses); noted as an older-version doc, not fully current.
4. [How to Change a Villager's Trade Offers with Data Commands — arktimes](https://2fwww.arktimes.com/how-to-change-a-villagers-trade-offers-with-data-commands-in-minecraft/) — `/data get entity <selector> Offers.Recipes` usage example.
5. [Modrinth — Level Timer / Animated Timer datapack](https://modrinth.com/datapack/level-timer) — proof actionbar timers are a real, working datapack pattern.
6. [PlanetMinecraft — Boss Bar Timer datapack](https://www.planetminecraft.com/data-pack/boss-bar-timer/) — proof bossbar countdowns are a real, working datapack pattern.
7. [GitHub — Dennis-0/Timer](https://github.com/Dennis-0/Timer) — combined floating-text + bossbar timer datapack.
8. [GitHub — Daridon6024/dynamic_bossbars](https://github.com/Daridon6024/dynamic_bossbars) — per-entity (not global) bossbar pattern, directly reusable for a per-villager cooldown display.

## Methodology
Ran 5 WebSearch queries and 2 WebFetch page reads (no firecrawl/exa MCP was configured in this environment, so the built-in WebSearch/WebFetch tools were used instead — coverage is somewhat shallower than a full firecrawl+exa pass would give). Sub-questions covered: vanilla restock/demand mechanics, NBT trade data structure, command patterns for reading trade NBT into scoreboards, and existing datapack/mod prior art for cooldown-style HUD displays.
