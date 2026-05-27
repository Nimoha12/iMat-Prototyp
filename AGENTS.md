```markdown
# Agent instructions — iMAT-prototyp

## Purpose

Design an online food shop aimed at older users. **Primary goal is strong UI/UX**, not production-complete backend or integrations.

## Design references

Ground UX, flows, and interaction decisions in **About Face** (Alan Cooper) and **Designing Interfaces** (Jenifer Tidwell), aligned with the goals and constraints in this file.

## Stack (this repo)

Flutter + dart

## Prototype scope — what is OK vs what must work


**Must work reliably:** forms (labels, validation UX, keyboard), app navigation, **varukorg** (shopping cart), and **mock session login** (fake login flow is fine). Usage of API detailed in BACKEND.md.

## Language and accessibility

- **UI copy and content: Swedish.**
- **Answer the programmer in english.**
- **Prioritize accessibility** (semantics, focus, contrast, touch targets, screen readers) over purely visual polish.

## Product owner

There is a **single programmer** (the repo owner). If requirements are unclear or conflict with these rules, **ask them** instead of guessing. Prefers concise answers that are straight to the point. 

## Visual design

- **Follow the existing design system** and components already in the project.
- **Light mode only** — do not add or optimize for dark mode unless explicitly requested.

## Tests

Add **only the tests needed** so the prototype behaviors in “what must work” stay correct while you implement or change them. Write tests **alongside the work**, not as a large retrospective suite. If the project has no test runner yet, introduce a minimal setup only when tests are required for that change.

## Out of scope

Prototype-level work only: **no git workflow mandates**, **no real payment providers**, **no changes to unrelated repositories**, and no production hardening unless asked.

## Agent tasks

- **Coding:** Implement features as specified by the programmer.
- **Design support:** Discuss trade-offs and UI choices when useful.


```

