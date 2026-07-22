# Ham Radio ↔ Computer Connection — Universal Rules

These rules apply to **every** radio + software combination. The per-radio and per-software
CSVs give you the specific values (baud, CI-V address, sound-card name, etc.); this sheet is
the shared "how it actually works" that isn't worth repeating on every row.

---

## 1. The two things every digital-mode connection needs

1. **CAT / rig control** (optional but recommended) — a **serial link** (real RS-232 or a USB
   virtual COM port) that lets software read/set frequency & mode and (often) key PTT.
2. **Audio** — the radio's receive audio into the PC and the PC's transmit audio into the radio,
   through a **sound device** (the radio's built-in USB codec, or an outboard interface such as a
   **Digirig** or **SignaLink**).

A radio can have (a) both on one USB cable (modern rigs with a built-in codec), (b) CAT on one
cable + audio on an interface, or (c) no CAT at all → audio-only interface and you tune by hand.

---

## 2. The ALC / drive golden rule (do this for ANY radio + ANY digital app)

Over-driving is the #1 cause of bad signals (splatter, wide FT8, distorted VARA). Set it once:

1. Put the radio in its **data mode** (`USB-D`, `DATA-U`, `PKT`, or `DATA` — see §4).
2. Set the **radio RF power** to your target (e.g. 25–50 W for FT8 on a 100 W rig).
3. Start with the **PC transmit audio LOW** (WSJT-X `Pwr` slider ~10–20%, or the interface's
   TX knob low, or Windows playback level ~20–30%).
4. Key TX on a tuning/test signal and **raise the PC audio slowly** until RF output stops rising.
   Then **back off** so the **ALC meter barely moves / reads near zero**.
5. For rigs with a **USB/DATA input-gain menu** (Icom "USB MOD Level", Yaesu menu items,
   Kenwood "PROC/AF"), adjust that instead of slamming the OS volume — aim ~30–50%.

**Target:** rated (or reduced) RF output with **minimal ALC**. If ALC is pegged, you are too hot.

---

## 3. PTT — pick the first method your radio+software supports (in this order)

1. **CAT PTT** (a rig-control command keys TX) — cleanest, one cable, no extra wiring.
   Works on most modern Icom/Yaesu/Kenwood/Elecraft.
2. **RTS or DTR** on a serial/COM port toggles a keying line (Digirig, SignaLink jumpered,
   homebrew). You tell the software which COM line.
3. **VOX** — the radio transmits when it hears PC audio. Zero wiring, but slower and can false-key.
   Good fallback for no-CAT rigs and handhelds. Set radio VOX gain + a short anti-VOX/delay.
4. **Hardware data-jack PTT** (a dedicated PTT pin on the ACC/DATA/mini-DIN connector).

> Don't let **two programs open the same COM port** for PTT/CAT at once. Use a rig-control hub
> (**flrig**, **Omnirig**, **DXLab Commander**, **Hamlib rigctld**) and point the other apps at it.

---

## 4. Put the radio in the right DATA mode

| Radio family | Digital/data mode to select |
|---|---|
| Icom (IC-7300/705/7610/9700…) | `USB-D` (a.k.a. Data-ON with USB) — set USB MOD input, connectors = USB |
| Yaesu (FT-991A/FTdx10/817…) | `DATA-U` / `PKT`; set DATA IN = REAR (menu), DATA MODE = OTHERS/PSK |
| Kenwood (TS-590/890…) | `DATA` mode; route audio to ACC2/USB, set DATA PTT source |
| Elecraft (K3/K4/KX…) | `DATA A` (AFSK/FT8) or `DATA` per app |
| Xiegu (G90/X6100…) | `USB`/`DATA` per firmware; G90 via Digirig cable set |

Using LSB/USB *voice* instead of the data mode routes mic audio and enables speech processing —
wrong for digital. Always use the data/packet mode.

---

## 5. Finding the COM port / sound device

- **Windows:** Device Manager → *Ports (COM & LPT)* for the CAT COM number; *Sound settings* or
  the app's audio picker for the codec (built-in rigs enumerate as **"USB Audio CODEC"**; Digirig
  as **"USB PnP Sound Device"**; SignaLink as **"USB Audio CODEC"** too).
- **Linux:** CAT = `/dev/ttyUSB0` or `/dev/ttyACM0` (`dmesg | tail` after plugging in); audio =
  `plughw:` / PulseAudio device (`arecord -l`, `aplay -l`). Add your user to the `dialout` group.
- **macOS:** CAT = `/dev/cu.usbserial-*` or `/dev/cu.SLAB_USBtoUART`; audio in *Audio MIDI Setup*.

The **COM number is assigned by the OS** and differs per machine/USB port — it can never be
pre-filled in a table; always look it up. Baud/bits/parity, however, are radio properties (in the
CSV).

---

## 6. Interface quick-setup

**Digirig Mobile** (the recommended default outboard interface):
- One box = a CM108 USB **sound card** + a CP2102 USB **serial** (CAT + RTS/DTR PTT).
- Buy the **radio-specific cable set** (it wires audio + CAT/PTT to your rig's connectors).
- In software: audio device = the Digirig sound card; CAT = the Digirig COM port; PTT = **RTS**
  on that COM port (Digirig default). Serial mode (TTL / RS-232 / CI-V) is set by the cable.

**SignaLink USB** (popular audio-only interface):
- Provides audio + **VOX or jumpered PTT** only — **no CAT**. Pair it with a separate CAT cable
  if you want rig control. Set the **TX / RX / DLY** knobs (start TX low per §2).
- Install the correct **jumper module** for your radio.

**Built-in USB codec rigs** (IC-7300, FT-991A, TS-890, K4, X6100…): you usually need **no**
outboard interface — one USB cable carries CAT **and** audio.

---

## 7. FT8/FT4 specifics (WSJT-X / JTDX / JS8Call / MSHV)

- **Split Operation:** set to **Rig** (or **Fake It**) so the TX audio stays 1500–2000 Hz in the
  passband and keeps IMD low. Don't run wide-open low audio frequencies.
- **Time sync** matters more than any setting: keep the PC clock within ~1 s (Meinberg/NTP,
  `chrony`, or an app like Dimension 4 / BktTimeSync). Bad clock = no decodes.
- Radio `Pwr` slider = TX audio level (see §2), **not** the radio's power knob.

---

## 8. SDR / panadapter apps (SDR Console, SDR#, HDSDR, SDRuno…)

- For a **traditional rig + SDR display**, sync frequency with **Omnirig**; route receiver audio
  to a decoder with a **Virtual Audio Cable** (VAC/VB-Cable, or PulseAudio loopback).
- For **SDR transceivers** (FlexRadio, Apache ANAN, Hermes-Lite) the vendor app (SmartSDR,
  Thetis) *is* the radio; digital apps connect via **DAX / virtual audio + virtual serial CAT**.

---

## 9. Common pitfalls

- **CAT won't connect:** baud/bits mismatch, wrong COM, or `CI-V Transceive` left ON (Icom) —
  turn transceive OFF for polled apps. Yaesu: watch for **2 stop bits** on older rigs.
- **Keys up but no output / no decode:** wrong sound device selected, or radio in voice mode not
  data mode, or PC audio muted.
- **Transmits then immediately drops (false VOX):** lower PC audio or raise anti-VOX.
- **RF in the shack (CAT drops on TX):** add ferrites/chokes, improve ground, shorten USB.
- **Two apps, one radio:** run one CAT hub (flrig/Omnirig/rigctld) and slave the rest.
