# OCEAN PULSE
### AI-Assisted Maritime Safety, Digital Ocean Twin & Fisher Fleet Coordination Platform
**Built for the SELF(E) College Hackathon 2026**

> *"See the risk. Prioritize the fleet. Protect lives."*

---

## 1. Executive Summary & Problem Statement

Across India's coastal waters, over **35.74 Lakh active fishers** are enrolled under the Group Accident Insurance Scheme (GAIS). Premier scientific and defense agencies provide critical services: **INCOIS** produces advanced wave and storm overturning advisories up to 10 days ahead, **IMD** operates Doppler weather radars, and **ISRO** has deployed more than **20,000 Distress Alert Terminals (DATs)** for satellite-linked rescue.

However, a major operational gap remains between weather forecasting and timely life-saving interventions:

1. **Fragmented Signals:** Weather bulletins, satellite position fixes, ocean current maps, and VHF radio signals exist across separate systems.
2. **One Warning ≠ One Risk:** Two small fishing crafts caught in the outer band of the same gale storm experience drastically different danger depending on engine horsepower, hull profile, current heading, and radio range.
3. **Shore Attention is Limited:** Shore safety controllers cannot continuously scan hundreds of vessels simultaneously. They need an automated, **explainable prioritization layer** that highlights *who needs help first, why, and what action to take*.

**Ocean Pulse** solves this challenge with a unified platform comprising two connected user-facing interfaces:
- **Shore Safety Command Center:** An operational digital ocean twin with interactive geographic mapping, autonomous fleet urgency ranking, 15-minute projected hazard intersections, multi-operator incident dispatch, and evidence-grounded AI copilot briefings.
- **Fisherman HUD:** A mobile-first, touch-friendly cockpit for fishers aboard small vessels featuring press-and-hold emergency SOS (2-second confirmation to prevent accidental triggers), multilingual speech synthesis (English, Malayalam, Tamil, Hindi), safe heading vectors, and IndexedDB offline queueing.

---

## 2. Core Architecture & Differentiators

```
ocean-pulse/
  ├── apps/
  │   ├── api/             # Node.js/Express + Socket.IO + Prisma ORM + Risk Engine
  │   └── web/             # React 18 + Vite + Tailwind CSS + Leaflet/Canvas + idb
  ├── packages/
  │   └── shared/          # Shared Zod schemas, TypeScript types, constants, events
  ├── docs/                # Architecture, DB Schema, Risk Engine, Demo Script
  ├── render.yaml          # Render Blueprint deployment config
  ├── Dockerfile           # Multi-stage production container
  ├── .env.example         # Environment template
  └── package.json         # Root npm workspaces
```

### Key Differentiators:
1. **Deterministic, Authoritative Risk Engine (`ocean-pulse-rule-v1.0`):** Risk scores and fleet rankings are 100% rule-based and versioned. The system never relies on ungrounded AI percentages for navigation safety.
2. **Evidence-Grounded AI Copilot:** The AI copilot operates behind strict prompt constraints: it explains verified telemetry and radar evidence, but cannot fabricate sensor data, override mathematical scores, or declare a vessel safe without contact.
3. **Resilient Offline Queueing with Idempotency:** The Fisherman HUD caches unsent distress calls in local IndexedDB with UUID idempotency keys. Upon reconnection, messages reconcile automatically with zero duplicates.
4. **Honest Data Provenance:** The system explicitly marks simulated data and never claims physical connectivity to certified satellite beacons or real-world radar unless an active adapter is present.

---

## 3. Technology Stack

- **Frontend:** React 18, Vite, TypeScript, Tailwind CSS, Lucide Icons, Leaflet / HTML5 Canvas mapping, Web Speech API (speechSynthesis), `idb` (IndexedDB promise wrapper).
- **Backend:** Node.js, Express, TypeScript, Socket.IO (authenticated real-time rooms), Prisma ORM, Zod runtime validation, Bcrypt password hashing, JWT authentication.
- **Database:** SQLite for zero-dependency local execution (`dev.db`); PostgreSQL for production deployments on Render.
- **Testing:** Vitest, Supertest (21 unit and integration tests covering risk calculations, tie-breakers, and idempotent SOS flows).

---

## 4. Quickstart & Local Installation

### Prerequisites
- Node.js v18+ (tested on Node v20 and v24)
- npm v9+

### 1. Clone & Install Dependencies
```bash
git clone <repository-url> ocean-pulse
cd ocean-pulse
npm install
```

### 2. Configure Environment
```bash
cp .env.example apps/api/.env
```
*(The default `.env` is pre-configured with SQLite for instant zero-config startup).*

### 3. Initialize & Seed Database
```bash
# Push Prisma schema to SQLite
npm run db:push

# Seed users, 10 Indian fishing vessels, and hazard zones
npm run db:seed
```

### 4. Run the Test Suite
```bash
npm run test --workspace=apps/api
```
*(Runs all 21 unit and integration tests).*

### 5. Start Development Servers
```bash
# In terminal 1 (starts backend API & simulation on port 3001)
npm run dev:api

# In terminal 2 (starts web frontend on port 5173)
npm run dev:web
```
Open your browser at **`http://localhost:5173`** (or **`http://localhost:3001`** in production).

---

## 5. Evaluator Sample Accounts

Ocean Pulse includes 5 pre-seeded role accounts. A convenient **one-click role switcher** is built directly into the UI header and login page:

| Role | Email | Password | Intended Workflow |
| :--- | :--- | :--- | :--- |
| **Shore Operator** | `operator@oceanpulse.org` | `ShorePass123!` | Manages fleet triage, acknowledges distress alerts, dispatches logistics. |
| **Fisherman** | `fisher@oceanpulse.org` | `FisherPass123!` | Master of B01 Sagar Kanya; triggers SOS, tests multilingual audio HUD. |
| **Supervisor** | `supervisor@oceanpulse.org` | `SuperPass123!` | Coast Guard commander; authorizes external MRCC search-and-rescue escalations. |
| **Admin** | `admin@oceanpulse.org` | `AdminPass123!` | System configuration and security oversight. |
| **Demo Viewer** | `viewer@oceanpulse.org` | `DemoPass123!` | Read-only evaluation account for hackathon judges. |

---

## 6. Predefined Hackathon Scenarios

In the Shore Command toolbar, select any of the 5 repeatable scenarios:

1. **1. Approaching Storm Cell (Track Intersection):** Deep depression moves WSW at 18 km/h. Sagar Kanya (B01) is on a projected collision track reaching storm perimeter in ~12 min.
2. **2. Propulsion Breakdown & Reef Drift:** Samudra Ratna (B04) loses main engine propulsion; maneuvering speed drops by 50% and drift carries it toward rocky reefs.
3. **3. Communication Blackout & Stale Telemetry:** Kadal Rani (B03) enters a signal deadzone. Last contact age increments; status is marked *"CONTACT LOST — STATUS UNKNOWN"*.
4. **4. Multiple Concurrent SOS Alerts:** Matsya Jyoti (B02) reports flooding while Varuna (B07) reports a medical emergency; tests life-safety prioritization.
5. **5. Offline HUD Reconnection & Sync:** Fisherman HUD loses network, queues SOS locally in IndexedDB, and automatically reconciles without duplicates upon reconnection.

---

## 7. Render Production Deployment

Ocean Pulse is designed for frictionless deployment on Render as either a **Single Web Service** (serving the built React frontend and Express API together) or with a **Render PostgreSQL database**.

### Option A: Render Blueprint (One-Click)
1. Fork or push this repository to GitHub.
2. Log into **Render.com** and navigate to **Blueprints**.
3. Connect your repository and select `render.yaml`.
4. Render will automatically provision the Node web service and PostgreSQL database.

### Option B: Manual Web Service on Render
- **Environment:** Node
- **Build Command:** `npm install && npm run build`
- **Start Command:** `node apps/api/dist/index.js`
- **Health Check Path:** `/health`
- **Environment Variables:**
  - `NODE_ENV=production`
  - `PORT=3001`
  - `JWT_SECRET=your-random-secret-key`
  - `DATABASE_URL=your-render-postgresql-url` *(or leave blank to use file:./dev.db)*
  - `DEMO_MODE=true`

---

## 8. Safety & Operational Disclaimer

> [!CAUTION]
> **ACADEMIC & HACKATHON PROTOTYPE ONLY**  
> Ocean Pulse is an experimental decision-support prototype developed for the SELF(E) 2026 college hackathon. It has not undergone IMO, SOLAS, or ISO maritime safety certification. In an actual distress situation at sea, mariners must always rely on certified emergency equipment:
> - **ISRO Distress Alert Terminals (DAT / DAT-SG)**
> - **VHF Marine Radio Channel 16 (156.8 MHz)**
> - **406 MHz Satellite EPIRBs**
> - Direct contact with the **Indian Coast Guard Maritime Rescue Coordination Centre (MRCC)**.

---

## 9. Documentation Directory

For deeper architectural, mathematical, and algorithmic specifics:
- [System Architecture](file:///docs/ARCHITECTURE.md)
- [Deterministic Risk Engine Formulae](file:///docs/RISK_ENGINE.md)
- [Database Schema & ERD](file:///docs/DATABASE_SCHEMA.md)
- [REST API & Socket Reference](file:///docs/API_REFERENCE.md)
- [5-Minute Hackathon Presentation Script](file:///docs/HACKATHON_DEMO_SCRIPT.md)
- [Prototype Migration Checklist](file:///docs/MIGRATION_CHECKLIST.md)

---

## 10. License & Credits

Developed for the **SELF(E) 2026 Hackathon**.  
Data models and advisory structures reference public documentation from **INCOIS (SVAS)**, **IMD**, **Ministry of Fisheries (PIB)**, and **ISRO**.
