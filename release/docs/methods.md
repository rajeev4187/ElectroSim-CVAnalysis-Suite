# Scientific Methods

The equations and conventions used by ElectroSim-CV Analysis Suite.

---

## Dunn's Method

### Mechanism classification (b-value)

For each scan rate v, the peak current i_p obeys a power law:

```
i_p(v) = a · v^b
```

Taking log₁₀ of both sides linearises the relationship:

```
log10(|i_p|) = log10(a) + b · log10(v)
```

A linear regression of `log10(|i_p|)` against `log10(v)` recovers the exponent **b** as the slope. The exponent indicates the dominant charge-storage mechanism:

| b-value | Mechanism | Typical device |
| --- | --- | --- |
| `b ≈ 1.0` | Surface-controlled (capacitive) | EDLC supercapacitor |
| `0.75 < b < 1.0` | Predominantly capacitive | Supercapacitor |
| `0.55 < b < 0.75` | Mixed capacitive / diffusion | Hybrid capacitor |
| `b ≈ 0.5` | Diffusion-controlled | Battery / pseudocapacitor |

### Current decomposition at a fixed potential

At any potential V, the total current decomposes into capacitive (scan-rate-linear) and diffusion (scan-rate-power-law) contributions:

```
i(V) = k1 · v + k2 · √v
```

Dividing both sides by √v linearises it:

```
i(V) / √v = k1 · √v + k2
```

For each potential E in a grid, the suite interpolates i(E) at every scan rate, then fits the linear equation above. The slope gives k₁ (capacitive coefficient) and the intercept gives k₂ (diffusion coefficient).

The fractional contributions are then:

```
Capacitive % = |k1·v| / |i(V)| · 100
Diffusion %  = |k2·√v| / |i(V)| · 100
```

The "decomposition" plot in the Dunn's Method tab shows i_capacitive as a shaded area underneath the total i(V) curve at the highest scan rate.

---

## ECASA — Electrochemically Active Surface Area

In the **non-Faradaic window** of a CV (a flat region with no redox features), the current arises purely from double-layer charging:

```
i = Cdl · v
```

For each scan rate v, the time-averaged |i| inside the window is half the rectangle width:

```
<|i|>_window = Cdl · v
```

A linear fit of `<|i|>_window` versus `v` across multiple scan rates yields the double-layer capacitance C_dl directly as the slope. The electrochemically active surface area is then:

```
ECASA = Cdl / Cs
```

where **Cs** is the material-class specific capacitance (a literature constant). The suite defaults to **40 µF/cm²** for carbon-based materials; adjust per material.

---

## Randles–Sevcik — Diffusion Coefficient

For a reversible redox couple at 25 °C, the peak current scales as:

```
|i_p| = 2.69 × 10^5 · n^(3/2) · A · C · D^(1/2) · v^(1/2)
```

| Symbol | Meaning | Units |
| --- | --- | --- |
| n | electrons transferred | dimensionless |
| A | electrode area | cm² |
| C | bulk concentration of redox species | mol/cm³ (the GUI accepts mmol/L and converts) |
| D | diffusion coefficient | cm²/s (the unknown) |
| v | scan rate | V/s |

A linear fit of `|i_p|` vs `√v` has slope:

```
slope = 2.69 × 10^5 · n^(3/2) · A · C · √D
```

from which:

```
D = (slope / (2.69e5 · n^(3/2) · A · C))^2
```

The intercept of the fit should be near zero; a large intercept indicates the system is not purely diffusion-controlled, and the result should be interpreted with caution.

---

## Trasatti Analysis — Inner / Outer / Total Charge

Partitions the voltammetric charge `q*` by **site accessibility** from its scan-rate dependence — the charge-based companion to Dunn's mechanism split. Two canonical extrapolations:

```
q*(v)   = q*_o  + k  · v^(-1/2)      (outer charge, as v -> infinity)
1/q*(v) = 1/q*_T + k' · v^(1/2)      (total charge, as v -> 0)
```

- **Outer charge** `q*_o` — intercept of `q*` vs `v^(-1/2)` as `v -> infinity` (readily accessible surface).
- **Total charge** `q*_T` — from the intercept of `1/q*` vs `v^(1/2)` as `v -> 0` (all sites).
- **Inner charge** `q*_i = q*_T - q*_o` (less-accessible / porous sites).

Charge per scan rate uses an anodic, cathodic, or average (`½ ∮|i| dE`) basis, integrated over a user-set window. A linear-region selector excludes scan rates that bend away from the straight line. Needs ≥3 scan rates; charge is reported per cm². The accessibility ratio is `q*_o / q*_T`.

---

## Areal Capacitance & Rate Capability

Areal capacitance from the enclosed CV loop area at each scan rate:

```
C   = (∮ i dV) / (2 · v · ΔV)
C_A = C / A
```

where `∮ i dV` is the area enclosed by the CV loop, `v` the scan rate, `ΔV` the potential window, and `A` the electrode area. Reports the per-scan-rate `C_A`, the rate-capability plot (`C_A` vs `v`), and the retention curve relative to the slowest scan rate. Use a non-Faradaic (capacitive) window. Gravimetric capacitance (F/g) is intentionally **not** computed from CV — it is determined from galvanostatic charge–discharge (GCD).

---

## Peak Area / Charge

Integrates a redox peak on a single CV after baseline subtraction:

```
Q = (1/v) ∫_{E1}^{E2} ( i(E) - i_base(E) ) dE
Γ = Q / (n F A)        (surface coverage)
N = Q / (n F)          (moles)
```

Baseline options: linear endpoint-to-endpoint, horizontal, or none. Reports `Q`, surface coverage `Γ`, moles `N`, and the `Q_a/Q_c` ratio (≈1 ⇒ chemically reversible/stable couple). A **Faradaic gate** skips the analysis if the window has no genuine redox peak.

**Unknown n:** leave `n` blank to estimate it from the baseline-subtracted full width at half maximum:

```
W_1/2 = 3.53 RT / (nF) = 90.6 / n  mV at 25 °C   =>   n = 3.53 RT / (F · W_1/2)
```

`Q` and `Q_a/Q_c` do not depend on `n`; only `Γ` and `N` scale as `1/n`.

---

## Electron-Transfer Kinetics (Nicholson & Laviron)

Heterogeneous rate constant from how peak positions move with scan rate.

**Nicholson** (freely diffusing couple), via the Lavagnini analytical fit to Nicholson's working curve:

```
ψ  = ( -0.6288 + 0.0021 X ) / ( 1 - 0.017 X ),   X = n · ΔEp [mV]
k0 = ψ · sqrt( π D n F v / (R T) )
```

**Laviron** (surface-confined / adsorbed), from `Ep` vs `ln(v)` slopes:

```
slope_a =  RT / (α n F)
slope_c = -RT / ((1 - α) n F)     =>   α, (1 - α), k_s
```

A **Faradaic gate** prevents running on non-Faradaic CVs. An auto-calculate-n helper offers two independent estimates — `n` from reversible `ΔEp` (`= 2.303 RT / (F · ΔEp)`, slowest scan rate) and `n` from the anodic-peak FWHM — for confirmation before `k0` / `α` / `k_s` are computed.

---

## Peak detection

Peaks are detected per scan rate using `scipy.signal.find_peaks` with a prominence threshold set as a fraction of the per-scan-rate amplitude (`max(i) − min(i)`). The default fraction is **0.05** (5 %), adjustable in the Dunn's Method tab. Anodic peaks (max +i) and cathodic peaks (max −i) are detected independently; the largest peak of each polarity is reported.

For multi-peak CVs the current build reports the single dominant peak per polarity. Multi-peak handling is planned for a future release.

---

## References

1. Dunn et al., *Where Do Batteries End and Supercapacitors Begin?* Science, 2014.
2. Bard & Faulkner, *Electrochemical Methods: Fundamentals and Applications*, 2nd ed., Wiley, 2001 — Randles-Sevcik equation, Ch. 6.
3. Wang, Zhang & Zhang, *A review of electrode materials for electrochemical supercapacitors*, Chem. Soc. Rev., 41 (2012) 797.
4. Harish & Sathyakam, *Identifying Supercapacitor Charge Storage Mechanism using Dunn's Method: A Status Quo Review*, J. Energy Storage, 2025, 12481.
5. Ardizzone, Fregonara & Trasatti, *"Inner" and "outer" active surface of RuO₂ electrodes*, Electrochim. Acta, 35 (1990) 263 — Trasatti inner/outer charge.
6. Nicholson, *Theory and Application of Cyclic Voltammetry for Measurement of Electrode Reaction Kinetics*, Anal. Chem., 37 (1965) 1351.
7. Lavagnini, Antiochia & Magno, *An Extended Method for the Practical Evaluation of the Standard Rate Constant from Cyclic Voltammetric Data*, Electroanalysis, 16 (2004) 505 — Nicholson working-curve fit.
8. Laviron, *General expression of the linear potential sweep voltammogram for surface electrochemical reactions*, J. Electroanal. Chem., 101 (1979) 19.
